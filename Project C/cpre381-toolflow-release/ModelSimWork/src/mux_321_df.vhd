-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------
-- mux_321_df.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Dataflow 32:1 mux for CPRE 381 Lab 3 P1g
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

PACKAGE vectorarraytype IS
  TYPE vectorarray IS ARRAY (0 TO 31) OF std_logic_vector(31 DOWNTO 0);

END PACKAGE vectorarraytype;

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE work.vectorarraytype.ALL;
USE IEEE.numeric_std.ALL;

ENTITY mux_321_df IS
  PORT (
    i_MuxData : vectorarray;
    i_MuxSel : IN std_logic_vector(4 DOWNTO 0); -- select bits
    o_MuxOut : OUT std_logic_vector(31 DOWNTO 0));

END mux_321_df;

ARCHITECTURE dataflow OF mux_321_df IS
BEGIN
  o_MuxOut <= i_MuxData(to_integer(unsigned(i_MuxSel))); -- convert i_S to the index of i_A

END dataflow;