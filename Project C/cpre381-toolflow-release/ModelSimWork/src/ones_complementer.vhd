-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------
-- ones_complementer.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Structural one's complementer for CPRE 381 Lab 2 P1a
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY ones_complementer IS
  GENERIC (N : INTEGER := 14);
  PORT (
    i_A : IN std_logic_vector(N - 1 DOWNTO 0);
    o_F : OUT std_logic_vector(N - 1 DOWNTO 0));

END ones_complementer;

ARCHITECTURE structure OF ones_complementer IS

  COMPONENT invg
    PORT (
      i_A : IN std_logic;
      o_F : OUT std_logic);
  END COMPONENT;

BEGIN

  G1 : FOR i IN 0 TO N - 1 GENERATE
    invg_i : invg
    PORT MAP(
      i_A => i_A(i),
      o_F => o_F(i));
  END GENERATE;
END structure;