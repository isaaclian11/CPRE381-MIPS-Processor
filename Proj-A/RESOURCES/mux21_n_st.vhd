-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------


-- mux21_n_st.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Structural 2-1 n-bit mux for CPRE 381 Lab 2 P2c
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux21_n_st is
  generic(N : integer := 1);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       i_B  : in std_logic_vector(N-1 downto 0);
       i_S  : in std_logic;
       o_F  : out std_logic_vector(N-1 downto 0));

end mux21_n_st;

architecture structure of mux21_n_st is

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

signal s_X : std_logic_vector(N-1 downto 0);
signal s_y : std_logic_vector(N-1 downto 0);
signal s_Z : std_logic_vector(N-1 downto 0);

begin

G1: for i in 0 to N-1 generate
  and1_i : andg2 port map (i_A(i),s_X(i),s_Y(i));
  and2_i : andg2 port map (i_S,i_B(i),s_Z(i));
  or2_i  : org2 port map (s_Y(i),s_Z(i),o_F(i));
  not1_i : invg port map (i_S,s_X(i));
end generate;

end structure;