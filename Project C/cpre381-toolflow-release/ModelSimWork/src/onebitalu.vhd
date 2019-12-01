-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------
-- onebitalu.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: 1-bit ALU for CPRE 381 Project A P1b
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY onebitalu IS

  PORT (
    i_A : IN std_logic;
    i_B : IN std_logic;
    i_Cin : IN std_logic; -- carry in
    i_less : IN std_logic; -- used for slt operation
    i_sel : IN std_logic_vector(3 DOWNTO 0); -- operation select
    o_set : OUT std_logic; -- used for slt operation
    o_Cout : OUT std_logic; -- carry out
    o_result : OUT std_logic);

END onebitalu;

ARCHITECTURE dataflow OF onebitalu IS

  SIGNAL s_NotA : std_logic;
  SIGNAL s_NotB : std_logic;
  SIGNAL s_And : std_logic;
  SIGNAL s_Or : std_logic;
  SIGNAL s_Nand : std_logic;
  SIGNAL s_Nor : std_logic;
  SIGNAL s_Xor : std_logic;
  SIGNAL s_AddSub : std_logic;
  SIGNAL s_FinalB : std_logic;
  SIGNAL s_Cout : std_logic;

BEGIN

  s_NotA <= NOT i_A;
  s_NotB <= NOT i_B;
  s_And <= i_A AND i_B;
  s_Or <= i_A OR i_B;
  s_Nand <= i_A NAND i_B;
  s_Nor <= i_A NOR i_B;
  s_Xor <= i_A XOR i_B;
  -- we want to invert B for subtraction, slt(since it uses subtraction), xor, and nand
  WITH i_sel SELECT s_FinalB <=
    s_NotB WHEN "0001",
    s_NotB WHEN "0010",
    s_NotB WHEN "0101",
    s_NotB WHEN "0110",
    i_B WHEN OTHERS;
  s_AddSub <= i_A XOR s_FinalB XOR i_Cin;
  o_set <= s_AddSub;
  s_Cout <= (i_A AND s_FinalB) OR ((i_A XOR s_FinalB) AND i_Cin);
  o_Cout <= s_Cout;
  WITH i_sel SELECT o_result <=
    s_AddSub WHEN "0000", -- add
    s_AddSub WHEN "0001", -- sub
    i_less WHEN "0010", -- slt
    s_And WHEN "0011", -- and
    s_Or WHEN "0100", -- or
    s_Xor WHEN "0101", -- xor
    s_Nand WHEN "0110", -- nand
    s_Nor WHEN "0111", -- nor
    '0' WHEN OTHERS;

END dataflow;