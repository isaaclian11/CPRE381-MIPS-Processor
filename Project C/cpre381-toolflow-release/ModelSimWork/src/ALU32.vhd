-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------
-- ALU32.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: 32-bit ALU for CPRE 381 Project A P2b
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY ALU32 IS

	PORT (
		i_A : IN std_logic_vector(31 DOWNTO 0);
		i_B : IN std_logic_vector(31 DOWNTO 0);
		i_sel : IN std_logic_vector(3 DOWNTO 0); -- operation select
		i_unsigned : IN std_logic; -- determines if math is signed/unsigned
		i_shiftamount : IN std_logic_vector(4 DOWNTO 0); --shift amount
		o_Cout : OUT std_logic; -- carry out
		o_result : OUT std_logic_vector(31 DOWNTO 0); -- result F
		o_overflow : OUT std_logic;
		o_Zero : OUT std_logic);

END ALU32;

ARCHITECTURE mixed OF ALU32 IS

	COMPONENT onebitalu IS
		PORT (
			i_A : IN std_logic;
			i_B : IN std_logic;
			i_Cin : IN std_logic; -- carry in
			i_less : IN std_logic; -- used for slt operation
			i_sel : IN std_logic_vector(3 DOWNTO 0); -- operation select
			o_set : OUT std_logic; -- used for slt operation
			o_Cout : OUT std_logic; -- carry out
			o_result : OUT std_logic);
	END COMPONENT;

	COMPONENT barrelShifter
		GENERIC (
			DATA_WIDTH : INTEGER := 32;
			SEL_WIDTH : INTEGER := 5
		);
		PORT (
			input : IN std_logic_vector(DATA_WIDTH - 1 DOWNTO 0); -- input to be shifted
			arith : IN std_logic; -- arithmetic shift if 1, logical shift if 0
			rightShift : IN std_logic; --right shift if 1, left shift if 0
			output : OUT std_logic_vector(DATA_WIDTH - 1 DOWNTO 0); --output of the shifter
			sel : IN std_logic_vector(SEL_WIDTH - 1 DOWNTO 0) --amount to be shifted
		);

	END COMPONENT;

	SIGNAL s_carry : std_logic_vector(31 DOWNTO 0);
	SIGNAL s_zero : std_logic_vector(31 DOWNTO 0);
	SIGNAL s_result : std_logic_vector(31 DOWNTO 0);
	SIGNAL s_shifterResult : std_logic_vector(31 DOWNTO 0);
	SIGNAL s_set : std_logic; -- o_set for msb
	SIGNAL s_Cout : std_logic; -- cout for msb
	SIGNAL s_overflow : std_logic; -- overflow for msb
	SIGNAL s_ignore : std_logic_vector(31 DOWNTO 0) := x"00000000"; -- signal to store o_set for all bits but msb
	SIGNAL s_0bitless, s_msbxor, s_ofxorset, s_tmp1 : std_logic;
	SIGNAL s_shiftSelect : std_logic_vector(1 DOWNTO 0); -- signal to hold sra, sla, srl, sll
BEGIN

	WITH i_sel SELECT s_carry(0) <=
		'1' WHEN "0001",
		'1' WHEN "0010",
		'0' WHEN OTHERS;

	--0th bit selects arith, 1st bit selects right shift
	WITH i_sel SELECT s_shiftSelect <=
		"11" WHEN "1000", --sra
		"01" WHEN "1001", --sla 
		"10" WHEN "1010", --srl
		"00" WHEN OTHERS; --sll 

	lsb : onebitalu
	PORT MAP(
		i_A => i_A(0),
		i_B => i_B(0),
		i_Cin => s_carry(0),
		i_less => s_0bitless,
		i_sel => i_sel,
		o_set => s_ignore(0),
		o_Cout => s_carry(1),
		o_result => s_result(0));

	G1 : FOR i IN 1 TO 30 GENERATE
		biti : onebitalu
		PORT MAP(
			i_A => i_A(i),
			i_B => i_B(i),
			i_Cin => s_carry(i),
			i_less => '0',
			i_sel => i_sel,
			o_set => s_ignore(i),
			o_Cout => s_carry(i + 1),
			o_result => s_result(i));
	END GENERATE;

	msb : onebitalu
	PORT MAP(
		i_A => i_A(31),
		i_B => i_B(31),
		i_Cin => s_carry(31),
		i_less => '0',
		i_sel => i_sel,
		o_set => s_set,
		o_Cout => s_Cout,
		o_result => s_result(31));

	s_overflow <= (s_carry(31) XOR s_Cout);

	shift : barrelShifter
	PORT MAP(
		input => i_B,
		arith => s_shiftSelect(0),
		rightShift => s_shiftSelect(1),
		output => s_shifterResult,
		sel => i_shiftamount
	);

	G3 : FOR i IN 0 TO 31 GENERATE
		s_zero(i) <= s_result(i);
	END GENERATE;

	WITH s_zero SELECT o_zero <=
		'1' WHEN x"00000000",
		'0' WHEN OTHERS;

	WITH i_sel SELECT o_result <=
		s_shifterResult WHEN "1000",
		s_shifterResult WHEN "1001",
		s_shifterResult WHEN "1010",
		s_shifterResult WHEN "1011",
		s_result WHEN OTHERS;

	s_msbxor <= i_B(31) XOR i_A(31);
	s_tmp1 <= s_ofxorset WHEN s_msbxor = '0' ELSE
		i_B(31);

	s_ofxorset <= s_overflow XOR s_Set;

	s_0bitless <= s_ofxorset WHEN i_unsigned = '0' ELSE
		s_tmp1;

	o_Cout <= s_Cout;
	o_overflow <= s_overflow WHEN i_unsigned = '0' ELSE
		s_Cout;

END mixed;