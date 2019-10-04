-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------


-- mux_321_df.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Dataflow 32:1 mux for CPRE 381 Lab 3 P1g
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.vectorarraytype.all;
use IEEE.numeric_std.all;

entity mux_321_df is
  port(i_A : vectorarray;
       i_S : in std_logic_vector(4 downto 0); -- select bits
       o_X : out std_logic_vector(31 downto 0));

end mux_321_df;

architecture dataflow of mux_321_df is
begin
  o_X <= i_A(to_integer(unsigned(i_S))); -- convert i_S to the index of i_A

end dataflow;