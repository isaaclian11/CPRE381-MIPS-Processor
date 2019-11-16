-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------
-- fulladder_n_df.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Dataflow n-bit Full Adder for CPRE 381 Lab 2 P3d
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY fulladder_n_df IS
  GENERIC (N : INTEGER := 14);
  PORT (
    i_A : IN std_logic_vector(N - 1 DOWNTO 0);
    i_B : IN std_logic_vector(N - 1 DOWNTO 0);
    i_Cin : IN std_logic; -- carry in
    o_Cout : OUT std_logic; -- carry out
    o_Sum : OUT std_logic_vector(N - 1 DOWNTO 0)); -- sum

END fulladder_n_df;

ARCHITECTURE dataflow OF fulladder_n_df IS

  SIGNAL s_A : std_logic_vector(N - 1 DOWNTO 0);
  SIGNAL s_B : std_logic_vector(N - 1 DOWNTO 0);
  SIGNAL s_C : std_logic_vector(N - 1 DOWNTO 0);
  SIGNAL s_D : std_logic_vector(N - 1 DOWNTO 0);

BEGIN

  s_A(0) <= i_Cin; -- store our carry in value in the first bit
  s_B <= i_A XOR i_B;
  s_C <= i_A AND i_B;
  s_D <= s_B AND s_A;

  G1 : FOR i IN 0 TO N - 2 GENERATE
    s_A(i + 1) <= s_C(i) OR s_D(i);
  END GENERATE;

  o_Sum <= s_B XOR s_A;
  o_Cout <= s_C(N - 1) OR s_D(N - 1);

END dataflow;