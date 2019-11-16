-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------
-- ones_complementer_df.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Dataflow one's complementer for CPRE 381 Lab 2 P1b
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY ones_complementer_df IS
      GENERIC (N : INTEGER := 14);
      PORT (
            i_A : IN std_logic_vector(N - 1 DOWNTO 0);
            o_F : OUT std_logic_vector(N - 1 DOWNTO 0));

END ones_complementer_df;

ARCHITECTURE dataflow OF ones_complementer_df IS
BEGIN

      G1 : FOR i IN 0 TO N - 1 GENERATE
            o_F(i) <= NOT i_A(i);
      END GENERATE;

END dataflow;