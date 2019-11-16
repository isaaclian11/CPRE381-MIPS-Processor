-------------------------------------------------------------------------
-- Joseph Zambreno
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- dffx.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an edge-triggered
-- flip-flop with parallel access and reset.
--
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY dffx IS

  PORT (
    i_CLK : IN std_logic; -- Clock input
    i_RST : IN std_logic; -- Reset input
    i_WE : IN std_logic; -- Write enable input
    i_D : IN std_logic; -- Data value input
    o_Q : OUT std_logic); -- Data value output

END dffx;

ARCHITECTURE mixed OF dffx IS
  SIGNAL s_D : std_logic; -- Multiplexed input to the FF
  SIGNAL s_Q : std_logic; -- Output of the FF

BEGIN

  -- The output of the FF is fixed to s_Q
  o_Q <= s_Q;

  -- Create a multiplexed input to the FF based on i_WE
  WITH i_WE SELECT
    s_D <= i_D WHEN '1',
    s_Q WHEN OTHERS;

  -- This process handles the asyncrhonous reset and
  -- synchronous write. We want to be able to reset 
  -- our processor's registers so that we minimize
  -- glitchy behavior on startup.
  PROCESS (i_CLK, i_RST)
  BEGIN
    IF (i_RST = '1') THEN
      s_Q <= '0'; -- Use "(others => '0')" for N-bit values
    ELSIF (rising_edge(i_CLK)) THEN
      s_Q <= s_D;
    END IF;

  END PROCESS;

END mixed;