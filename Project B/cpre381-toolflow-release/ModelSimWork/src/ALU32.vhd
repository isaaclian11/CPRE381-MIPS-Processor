-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------


-- ALU32.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: 32-bit ALU for CPRE 381 Project A P2b
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ALU32 is
  
  port(i_A  : in std_logic_vector(31 downto 0);
       i_B  : in std_logic_vector(31 downto 0);
	   i_sel  : in std_logic_vector(3 downto 0); -- operation select
	   i_unsigned  : in std_logic; -- determines if math is signed/unsigned
	   i_shiftamount : in std_logic_vector(4 downto 0); --shift amount
	   o_Cout  : out std_logic; -- carry out
       o_result  : out std_logic_vector(31 downto 0); -- result F
	   o_overflow : out std_logic;
	   o_Zero : out std_logic);

end ALU32;

architecture mixed of ALU32 is
  
  component onebitalu is
     port(i_A  : in std_logic;
       i_B  : in std_logic;
       i_Cin  : in std_logic; -- carry in
	   i_less  : in std_logic; -- used for slt operation
	   i_sel  : in std_logic_vector(3 downto 0); -- operation select
	   o_set  : out std_logic; -- used for slt operation
	   o_Cout  : out std_logic; -- carry out
       o_result  : out std_logic);
  end component;
  
  component barrelShifter
	generic(
			DATA_WIDTH:	integer:=32;
			SEL_WIDTH:	integer:=5
		);
	port(
		input:	in std_logic_vector(DATA_WIDTH-1 downto 0); -- input to be shifted
		arith:	in std_logic; -- arithmetic shift if 1, logical shift if 0
		rightShift: in std_logic; --right shift if 1, left shift if 0
		output:	out std_logic_vector(DATA_WIDTH-1 downto 0); --output of the shifter
		sel:	in std_logic_vector(SEL_WIDTH-1 downto 0) --amount to be shifted
	);

	end component;
  
  signal s_carry: std_logic_vector(31 downto 0);
  signal s_zero : std_logic_vector(31 downto 0);
  signal s_result : std_logic_vector(31 downto 0);
  signal s_shifterResult : std_logic_vector(31 downto 0);
  signal s_set : std_logic; -- o_set for msb
  signal s_Cout : std_logic; -- cout for msb
  signal s_overflow : std_logic; -- overflow for msb
  signal s_ignore : std_logic_vector(31 downto 0):= x"00000000"; -- signal to store o_set for all bits but msb
  signal s_0bitless : std_logic;
  signal s_shiftSelect : std_logic_vector(1 downto 0); -- signal to hold sra, sla, srl, sll
  begin
  
  with i_sel select s_carry(0) <=
    '1' when "0001",
    '1' when "0010",
    '0' when others;
	
  --0th bit selects arith, 1st bit selects right shift
  with i_sel select s_shiftSelect <=
	"11" when "1000", --sra
	"01" when "1001", --sla 
	"10" when "1010", --srl
	"00" when others; --sll 
  
  lsb : onebitalu
    port map (i_A => i_A(0),
	          i_B => i_B(0),
			  i_Cin => s_carry(0),
			  i_less => s_0bitless,
			  i_sel => i_sel,
			  o_set => s_ignore(0),
			  o_Cout => s_carry(1),
			  o_result => s_result(0));
			  
  G1: for i in 1 to 30 generate
  biti : onebitalu
    port map (i_A => i_A(i),
	          i_B => i_B(i),
			  i_Cin => s_carry(i),
			  i_less => '0',
			  i_sel => i_sel,
			  o_set => s_ignore(i),
			  o_Cout => s_carry(i+1),
			  o_result => s_result(i));
  end generate;
  
  msb : onebitalu
   port map (i_A => i_A(31),
	          i_B => i_B(31),
			  i_Cin => s_carry(31),
			  i_less => '0',
			  i_sel => i_sel,
			  o_set => s_set,
			  o_Cout => s_Cout,
			  o_result => s_result(31));

  s_overflow <= (s_carry(31) xor s_Cout);
  
  shift: barrelShifter
  port map(
		input => i_B,
		arith => s_shiftSelect(0),
		rightShift => s_shiftSelect(1),
		output => s_shifterResult,
		sel => i_shiftamount
  );
  
  G3: for i in 0 to 31 generate
    s_zero(i) <= s_result(i);
  end generate;
  
  with s_zero select o_zero <=
   '1' when x"00000000",
   '0' when others;
   
  with i_sel select o_result <=
	s_shifterResult when "1000",
	s_shifterResult when "1001",
	s_shifterResult when "1010",
	s_shifterResult when "1011",
	s_result when others;

   
  s_0bitless <= s_overflow xor s_Set;
  
  o_Cout <= s_Cout;
  o_overflow <= s_overflow when i_unsigned = '0' else s_Cout;
  
end mixed;