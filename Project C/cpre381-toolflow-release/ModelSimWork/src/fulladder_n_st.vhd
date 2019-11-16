-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------
-- fulladder_n_st.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Structural n-bit Full Adder for CPRE 381 Lab 2 P3c
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY fulladder_n_st IS
  GENERIC (N : INTEGER := 14);
  PORT (
    i_A : IN std_logic_vector(N - 1 DOWNTO 0);
    i_B : IN std_logic_vector(N - 1 DOWNTO 0);
    i_Cin : IN std_logic; -- carry in
    o_Cout : OUT std_logic; -- carry out
    o_Sum : OUT std_logic_vector(N - 1 DOWNTO 0)); -- sum

END fulladder_n_st;

ARCHITECTURE structure OF fulladder_n_st IS

  COMPONENT fulladder IS
    PORT (
      i_A : IN std_logic;
      i_B : IN std_logic;
      i_Cin : IN std_logic; -- carry in
      o_Cout : OUT std_logic; -- carry out
      o_Sum : OUT std_logic); -- sum
  END COMPONENT;

  -- using N rather than n-1 here because the signal will store both carry ins and outs
  -- s_A(n) will hold the carryout
  SIGNAL s_A : std_logic_vector(N DOWNTO 0);

BEGIN

  s_A(0) <= i_Cin; -- store our carry in value in the first bit

  G1 : FOR i IN 0 TO N - 1 GENERATE
    fa1 : fulladder PORT MAP(
      i_A => i_A(i),
      i_B => i_B(i),
      i_Cin => s_A(i),
      o_Cout => s_A(i + 1),
      o_Sum => o_Sum(i));
  END GENERATE;

  o_Cout <= s_A(N);
