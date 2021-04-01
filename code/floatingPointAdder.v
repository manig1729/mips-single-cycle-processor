/* 
	This is the combined code from my floating-point-adder repository
	Only the testbench module has been removed

	Author : Manikandan Gunaseelan
*/

/* 
	The code is written in a modular form where all small functions in the adder have
	been implemented in different modules
*/
module floatingPointAdder (input [31:0] n1, input [31:0] n2, output [31:0] sum);

	wire [31:0] fraction1;
	wire [31:0] fraction2;
	wire [7:0] exponent1;
	wire [7:0] exponent2;
	wire sign1;
	wire sign2;

	// The following store intermediate values during calculations
	wire [7:0] exponentDiff;
	wire [7:0] exponentDiffAbs;

	wire [31:0] fractionTemp;
	wire [31:0] fractionSmall;
	wire [31:0] fractionLarge;
	wire [31:0] fractionSumInitial;
	wire [31:0] fractionFinal;

	wire [7:0] exponentTemp;
	wire [7:0] exponentFinal;
	wire signFinal;
	wire bigALUOp;

	// These are to store the final values after exceptions are tested
	wire [31:0] fractionFinalE;
	wire [7:0] exponentFinalE;
	wire signFinalE;

		/* 
			Since there is an implied 1 in IEEE 754 format, an extra 1 is added to the fractions
			Also, to avoid 2's complement notation issues and allow for easy rounding in the
			future, eight extra 0's are added at the MSB
			This makes our fractions 32 bits long instead of 23 bits
		*/
		assign fraction1 = {8'b0, 1'b1, n1[22:0]};
		assign fraction2 = {8'b0, 1'b1, n2[22:0]};

		assign exponent1 = n1[30:23];
		assign exponent2 = n2[30:23];
		assign sign1 = n1[31];
		assign sign2 = n2[31];

		smallALU_fpa ALU1 (exponent1, exponent2, exponentDiff);

		wire i;					// To be used as select signal in MUX
		selectSignalMux_fpa Control_Unit_Select_Signal (fraction1, fraction2, exponentDiff, i);

		/*
			if exponentDiff is negative, it will be represented in 2's complement format
			However, we need the absolute value of the exponent Difference to be able
			to shift the smaller fraction. Hence, we find exponentDiffAbs here -
		*/
		assign exponentDiffAbs = exponentDiff[7]?-(exponentDiff):exponentDiff;	// This will determine the shift amount

		MUX_8bit_fpa MUX1 (exponent1, exponent2, i, exponentTemp);
		MUX_32bit_fpa MUX2 (fraction2, fraction1, i, fractionTemp);

		wire j;
		assign j = ~i;								// To select the fraction and sign of the smaller and larger numbers

		MUX_32bit_fpa MUX3 (fraction2, fraction1, j, fractionLarge);

		MUX_1bit_fpa MUX4 (sign2, sign1, j, signLarge);
		MUX_1bit_fpa MUX5 (sign1, sign2, j, signSmall);
		assign bigALUOp = signLarge ^ signSmall;	// If both numbers have the same sign, addition is to be done, else subtraction
		assign signFinal = signLarge;				// The sign of the final number is the sign of the number with the bigger absolute value

		shiftRight_fpa SHIFT (fractionTemp, exponentDiffAbs, fractionSmall);	// smaller number's fraction is shifted by the amount of difference in exponents

		bigALU_fpa ALU2 (fractionLarge, fractionSmall, bigALUOp, fractionSumInitial);	// Main calculation using adjusted numbers

		normaliseSum_fpa NORMALISE (fractionSumInitial, exponentTemp, bigALUOp, fractionFinal, exponentFinal);	// Normalising the result to be shown in IEEE754 format

		exceptionCheckOutput_fpa EXCEPTION_OUTPUT (fractionFinal, exponentFinal, signLarge, fractionFinalE, exponentFinalE, signFinalE); // Check for overflow or underflow

		assign sum = {signFinalE, exponentFinalE, fractionFinalE[22:0]};	// final assignment of sum value

endmodule 

module exceptionCheckOutput_fpa (input [31:0] frac, input [7:0] exp, input s, output reg [31:0] fracfinE, output reg [7:0] expfinE, output reg sfinE);

always @(*) begin
	// If exponent is 255 (or higher) result is infinity not NaN
	if (exp >= 255) begin
		fracfinE = 0;
		expfinE = 255;
		sfinE = s;
	end

	// If exponent is 0 (after bias) result is zero
	else if (exp == 0) begin
		fracfinE = 0;
		expfinE = 0;
		sfinE = 0;
	end

	// No exceptions
	else begin
		fracfinE = frac;
		expfinE = exp;
		sfinE = s;
	end
end	

endmodule 

module selectSignalMux_fpa (input [31:0] frac1, input [31:0] frac2, input [7:0] expdiff, output reg sel);
	// This could have been done easily by just checking exponent
	// However, an extra case has been taken to check for fractions in case the exponents are equal
	
reg [31:0] fracdiff;
always @(*) begin
	if(expdiff != 0) begin
		sel = expdiff[7];
	end
	else if(expdiff == 0) begin
		fracdiff = frac1 - frac2;
		sel = fracdiff[31];
	end		
end

endmodule 

module normaliseSum_fpa (input [31:0] fracIn, input [7:0] exponentIn, input op, output reg [31:0] fracOut, output reg [7:0] exponentOut);

integer breakout;
integer shAmt;
integer index;

always @(*) begin

	breakout = 0;

	if(op == 0) begin					// In addition, if the sum exceeds a single bit before the decimal, frac [24] will become 1
		if(fracIn[24] == 1) begin
			fracOut = fracIn >> 1;
			exponentOut = exponentIn + 1;
		end
		else begin
			fracOut = fracIn;
			exponentOut = exponentIn;
		end 
	end

	else if(op == 1) begin				// In subtraction, if the numbers are close, there may be a lot of shifts needed for the decimal

		// While loops and break statements are not synthesisable and hence, the code is written in this way
		for(index = 22; index >= 0; index = index - 1) begin
			if (breakout != 1)
          		if (fracIn[index] == 1) begin
               		shAmt = 23 - index;
               		breakout = 1;
          		end
		end
		fracOut = fracIn << shAmt;
		exponentOut = exponentIn - shAmt;
	end

end

endmodule 

/*
	This module is the initial implementation of the BIG ALU
	shown in the figure, which sums up the two fractions for now
	The larger fraction is added with the shifted smaller fraction
*/
module bigALU_fpa (input [31:0] num1, input [31:0] num2, input op , output reg [31:0] sum);

always @(*) begin
	if(op == 0)
		sum = num1 + num2;
	else if(op == 1)
		sum = num1 - num2;
end
endmodule 

/*
	This module is the Small ALU as shown in the figure
	It returns the difference of two inputs 
*/
module smallALU_fpa (input [7:0] num1, input [7:0] num2, output [7:0] diff);
	assign diff = num1 - num2;
endmodule 

/* 
	This module is the "Shift Right" block shown in the figure
	It shifts an input by a specified amount
*/
module shiftRight_fpa (input [31:0] num, input [7:0] shiftAmt, output [31:0] shitftAns);
	assign shitftAns = num >> shiftAmt;
endmodule 

/*
	These are the MUXes in the circuit
	One is for sign (1 bit), one is for exponent (8 bit) and one is for fraction (32 bit)
	The MUXes are also implemented using modules, given below
*/

module MUX_1bit_fpa (input a, input b, input Sel, output out);
	assign out = Sel?b:a;
endmodule

module MUX_32bit_fpa (input [31:0] a, input [31:0] b, input Sel, output [31:0] out);
	assign out = Sel?b:a;
endmodule

module MUX_8bit_fpa (input [7:0] a, input [7:0] b, input Sel, output [7:0] out);
	assign out = Sel?b:a;
endmodule