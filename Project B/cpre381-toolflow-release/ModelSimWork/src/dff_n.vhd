-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------


-- dff_n.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: n-bit register for CPRE 381 Lab 3 1b
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity dff_n is
  generic(N : integer := 2);
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output

end dff_n;

architecture structural of dff_n is

component dffx is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output
end component;

begin

G1: for i in 0 to N-1 generate
    dff_i : dffx
      port map (i_CLK => i_CLK,
                i_RST => i_RST,
                i_WE => i_WE,
                i_D => i_D(i),
                o_Q => o_Q(i));
end generate;

end structural;