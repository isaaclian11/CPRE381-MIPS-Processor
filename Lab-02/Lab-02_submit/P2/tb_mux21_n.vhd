-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------


-- tb_mux21_n.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Testbench for 2-1 n-bit muxes for CPRE 381 Lab 2 P2e
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_mux21_n is
  generic(N : integer := 32);
  port(o_X  : out std_logic_vector(N-1 downto 0);
       o_Y  : out std_logic_vector(N-1 downto 0));

end tb_mux21_n;

architecture behavior of tb_mux21_n is

component mux21_n_st
  generic(N : integer := 32);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       i_B  : in std_logic_vector(N-1 downto 0);
       i_S  : in std_logic;
       o_F  : out std_logic_vector(N-1 downto 0));
end component;

component mux21_n_df
  generic(N : integer := 32);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       i_B  : in std_logic_vector(N-1 downto 0);
       i_S  : in std_logic;
       o_F  : out std_logic_vector(N-1 downto 0));
end component;

signal s_A : std_logic_vector(N-1 downto 0);
signal s_B : std_logic_vector(N-1 downto 0);
signal s_S : std_logic;

begin

  mux_st : mux21_n_st
    port map(i_A  => s_A,
             i_B  => s_B,
             i_S  => s_S,
  	         o_F  => o_X);
  mux_df : mux21_n_df
    port map(i_A  => s_A,
             i_B  => s_B,
             i_S  => s_S,
  	         o_F  => o_Y);
  
  process
    begin
	  s_A <= "11111111111111110000000000000000";
	  s_B <= "00000000000000001111111111111111";
	  s_S <= '0';
      wait for 100 ps;
      s_S <= '1';
      wait for 100 ps;
      s_A <= "11110000111100001111000011110000";
	  s_S <= '0';
      wait for 100 ps;  
  end process;
end behavior;