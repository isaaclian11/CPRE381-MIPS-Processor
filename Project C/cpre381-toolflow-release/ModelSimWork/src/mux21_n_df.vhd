-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------
-- mux21_n_df.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Dataflow 2-1 n-bit mux for CPRE 381 Lab 2 P2d
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY mux21_n_df IS
  GENERIC (N : INTEGER := 14);
  PORT (
    i_A : IN std_logic_vector(N - 1 DOWNTO 0);
    i_B : IN std_logic_vector(N - 1 DOWNTO 0);
    i_S : IN std_logic;
    o_F : OUT std_logic_vector(N - 1 DOWNTO 0));

END mux21_n_df;

ARCHITECTURE dataflow OF mux21_n_df IS

BEGIN

  G1 : FOR i IN 0 TO N - 1 GENERATE
    o_F(i) <= (i_S AND i_B(i)) OR (NOT i_S AND i_A(i));
  END GENERATE;

END dataflow;