-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------


-- extender.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Sign/Zero extender for CPRE 381 Lab 4 P1c
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity extender is
  generic(N : integer := 8);
  port(i_A  : in std_logic_vector(N-1 downto 0); -- input vector
       i_B  : in std_logic; -- sign control bit
       o_Z  : out std_logic_vector(31 downto 0)); -- output extension

end extender;

architecture dataflow of extender is

begin
-- For the lower bits, copy the bits from the input
G1: for i in 0 to N-1 generate
  o_Z(i) <= i_A(i);
end generate;
-- Extend to 32 bits
-- If i_B is 1, sign extend, else zero extend
G2: for i in N to 31 generate
  o_Z(i) <= i_A(N-1) and i_B; -- use AND to determine sign/zero extension
end generate;

end dataflow;