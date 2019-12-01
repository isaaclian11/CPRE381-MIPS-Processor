-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------


-- mux21.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Structural 2-1 mux for CPRE 381 Lab 2 P2B
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux21 is
  port(i_A  : in std_logic;
       i_B  : in std_logic;
       i_S  : in std_logic;
       o_F  : out std_logic);

end mux21;

architecture structure of mux21 is

component invg
  port(i_A  : in std_logic;
       o_F  : out std_logic);
end component;

component andg2
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component org2
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

signal s_X : std_logic;
signal s_y : std_logic;
signal s_Z : std_logic;
  
begin

and1 : andg2 port map (i_A,s_X,s_Y);
and2 : andg2 port map (i_S,i_B,s_Z);
or2  : org2 port map (s_Y,s_Z,o_F);
not1 : invg port map (i_S,s_X);

end structure;