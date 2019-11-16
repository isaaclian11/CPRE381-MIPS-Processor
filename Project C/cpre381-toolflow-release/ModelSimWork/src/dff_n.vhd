-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------
-- dff_n.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: n-bit register for CPRE 381 Lab 3 1b
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY dff_n IS
  GENERIC (N : INTEGER := 2);
  PORT (
    i_CLK : IN std_logic; -- Clock input
    i_RST : IN std_logic; -- Reset input
    i_WE : IN std_logic; -- Write enable input
    i_D : IN std_logic_vector(N - 1 DOWNTO 0); -- Data value input
    o_Q : OUT std_logic_vector(N - 1 DOWNTO 0)); -- Data value output

END dff_n;

ARCHITECTURE structural OF dff_n IS

  COMPONENT dffx IS
    PORT (
      i_CLK : IN std_logic; -- Clock input
      i_RST : IN std_logic; -- Reset input
      i_WE : IN std_logic; -- Write enable input
      i_D : IN std_logic; -- Data value input
      o_Q : OUT std_logic); -- Data value output
  END COMPONENT;

BEGIN

  G1 : FOR i IN 0 TO N - 1 GENERATE
    dff_i : dffx
    PORT MAP(
      i_CLK => i_CLK,
      i_RST => i_RST,
      i_WE => i_WE,
      i_D => i_D(i),
      o_Q => o_Q(i));
  END GENERATE;

END structural;