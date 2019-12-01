-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------


-- tb_fulladder_n.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Testbench for n-bit fulladders for CPRE 381 Lab 2 P3e
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_fulladder_n is
  generic(N : integer := 32);
  port(o_Xc  : out std_logic; -- structural carry out
       o_Xs  : out std_logic_vector(N-1 downto 0); -- structural sum
	   o_Yc  : out std_logic; -- dataflow carry out
       o_Ys  : out std_logic_vector(N-1 downto 0)); -- dataflow sum

end tb_fulladder_n;

architecture behavior of tb_fulladder_n is

component fulladder_n_st
  generic(N : integer := 32);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       i_B  : in std_logic_vector(N-1 downto 0);
       i_Cin  : in std_logic; -- carry in
	   o_Cout  : out std_logic; -- carry out
       o_Sum  : out std_logic_vector(N-1 downto 0)); -- sum
end component;

component fulladder_n_df
  generic(N : integer := 32);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       i_B  : in std_logic_vector(N-1 downto 0);
       i_Cin  : in std_logic; -- carry in
	   o_Cout  : out std_logic; -- carry out
       o_Sum  : out std_logic_vector(N-1 downto 0)); -- sum
end component;

signal s_A : std_logic_vector(N-1 downto 0);
signal s_B : std_logic_vector(N-1 downto 0);
signal s_C : std_logic;

begin

  fa_st : fulladder_n_st
    port map (i_A => s_A,
              i_B => s_B,
              i_Cin => s_C,
	          o_Cout => o_Xc,
              o_Sum => o_Xs);
  fa_df : fulladder_n_df
    port map (i_A => s_A,
              i_B => s_B,
              i_Cin => s_C,
	          o_Cout => o_Yc,
              o_Sum => o_Ys);
  
  process
    begin
	  s_A <= "00000000000000000000000000000001";
	  s_B <= "00000000000000001111111111111111";
	  s_C <= '0';
	  wait for 100 ps;
	  s_C <= '1';
	  wait for 100 ps;
	  s_A <= "00000000000000000000000000000001";
	  s_B <= "11111111111111111111111111111111";
	  wait for 100 ps;
	  s_A <= "00000000000000000000000000000000";
	  s_B <= "00000000000000000000000000000000";
	  s_C <= '0';
      wait for 100 ps;
  end process;
end behavior;