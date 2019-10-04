-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------


-- onebitalu.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: 1-bit ALU for CPRE 381 Project A P1b
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity onebitalu is
  
  port(i_A  : in std_logic;
       i_B  : in std_logic;
       i_Cin  : in std_logic; -- carry in
	   i_less  : in std_logic; -- used for slt operation
	   i_sel  : in std_logic_vector(2 downto 0); -- operation select
	   o_set  : out std_logic; -- used for slt operation
	   o_Cout  : out std_logic; -- carry out
       o_result  : out std_logic);

end onebitalu;

architecture dataflow of onebitalu is
  
  signal s_NotA : std_logic;
  signal s_NotB : std_logic;
  signal s_And : std_logic;
  signal s_Or : std_logic;
  signal s_Nand : std_logic;
  signal s_Nor : std_logic;
  signal s_Xor : std_logic;
  signal s_AddSub : std_logic;
  signal s_FinalB : std_logic;
  signal s_Cout : std_logic;
  
  begin

  s_NotA <= not i_A;
  s_NotB <= not i_B;
  s_And <= i_A and i_B;
  s_Or <= i_A or i_B;
  s_Nand <= i_A nand i_B;
  s_Nor <= i_A nor i_B;
  s_Xor <= i_A xor i_B;
  -- we want to invert B for subtraction, slt(since it uses subtraction), xor, and nand
  with i_sel select s_FinalB <=
    s_NotB when "001",
    s_NotB when "010",
	s_NotB when "101",
    s_NotB when "110",
    i_B when others;
  s_AddSub <= i_A xor s_FinalB xor i_Cin;
  o_set <= s_AddSub;
  s_Cout <= (i_A and s_FinalB) or ((i_A xor s_FinalB) and i_Cin);
  o_Cout <= s_Cout;
  with i_sel select o_result <=
    s_AddSub when "000", -- add
    s_AddSub when "001", -- sub
    i_less when "010", -- slt
    s_And when "011", -- and
    s_Or when "100", -- or
    s_Xor when "101", -- xor
    s_Nand when "110", -- nand
    s_Nor when "111", -- nor
    '0' when others;
	
end dataflow;