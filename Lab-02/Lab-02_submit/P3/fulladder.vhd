-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------


-- fulladder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Full Adder for CPRE 381 Lab 2 P3b
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity fulladder is
  port(i_A  : in std_logic;
       i_B  : in std_logic;
       i_Cin  : in std_logic; -- carry in
	   o_Cout  : out std_logic; -- carry out
       o_Sum  : out std_logic); -- sum

end fulladder;

architecture structure of fulladder is

component xorg2
  port(i_A  : in std_logic;
       i_B  : in std_logic;
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

signal s_X : std_logic; -- xor
signal s_y : std_logic; -- and1
signal s_Z : std_logic; -- and2

begin

or1  : org2 port map (i_A => s_Y,
                      i_B => s_Z,
					  o_F => o_Cout);

xor1 : xorg2 port map (i_A => i_A,
                       i_B => i_B,
					   o_F => s_X);

xor2 : xorg2 port map (i_A => s_X,
                       i_B => i_Cin,
					   o_F => o_Sum);
					   
and1 : andg2 port map (i_A => i_A,
                       i_B => i_B,
					   o_F => s_Y);

and2 : andg2 port map (i_A => s_X,
                       i_B => i_Cin,
					   o_F => s_Z);
					   
end structure;