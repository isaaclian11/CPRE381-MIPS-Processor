-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------


-- ones_complementer.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Structural one's complementer for CPRE 381 Lab 2 P1a
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ones_complementer is
  generic(N : integer := 14);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       o_F  : out std_logic_vector(N-1 downto 0));

end ones_complementer;

architecture structure of ones_complementer is

component invg
  port(i_A  : in std_logic;
       o_F  : out std_logic);
end component;

begin

G1: for i in 0 to N-1 generate
  invg_i: invg
    port map(i_A  => i_A(i),
  	     o_F  => o_F(i));
end generate;
  
end structure;