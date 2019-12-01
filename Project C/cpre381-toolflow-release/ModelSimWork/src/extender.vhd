-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------
-- extender.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Sign/Zero extender for CPRE 381 Lab 4 P1c
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY extender IS
  GENERIC (N : INTEGER := 8);
  PORT (
    i_A : IN std_logic_vector(N - 1 DOWNTO 0); -- input vector
    i_B : IN std_logic; -- sign control bit
    o_Z : OUT std_logic_vector(31 DOWNTO 0)); -- output extension

END extender;

ARCHITECTURE dataflow OF extender IS

BEGIN
  -- For the lower bits, copy the bits from the input
  G1 : FOR i IN 0 TO N - 1 GENERATE
    o_Z(i) <= i_A(i);
  END GENERATE;
  -- Extend to 32 bits
  -- If i_B is 1, sign extend, else zero extend
  G2 : FOR i IN N TO 31 GENERATE
    o_Z(i) <= i_A(N - 1) AND i_B; -- use AND to determine sign/zero extension
  END GENERATE;

END dataflow;