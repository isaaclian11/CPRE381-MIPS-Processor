-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------


-- addsub_n_st.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Structural n-bit adder/subtractor for CPRE 381 Lab 2 P4b
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity addsub_n_st is
  generic(N : integer := 1);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       i_B  : in std_logic_vector(N-1 downto 0);
       i_nAdd_Sub  : in std_logic; -- carry in
	   o_Cout  : out std_logic; -- carry out
       o_Sum  : out std_logic_vector(N-1 downto 0)); -- sum

end addsub_n_st;

architecture structure of addsub_n_st is

component fulladder_n_st is
  generic(N : integer := 1);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       i_B  : in std_logic_vector(N-1 downto 0);
       i_Cin  : in std_logic; -- carry in
	   o_Cout  : out std_logic; -- carry out
       o_Sum  : out std_logic_vector(N-1 downto 0)); -- sum
end component;

component mux21_n_st is
  generic(N : integer := 1);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       i_B  : in std_logic_vector(N-1 downto 0);
       i_S  : in std_logic;
       o_F  : out std_logic_vector(N-1 downto 0));
end component;

component ones_complementer is
  generic(N : integer := 1);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       o_F  : out std_logic_vector(N-1 downto 0));
end component;

signal s_A : std_logic_vector(N-1 downto 0); -- output from inverter, input to mux in b
signal s_B : std_logic_vector(N-1 downto 0); -- output from mux, input to adder in b

begin

fa_st : fulladder_n_st
  port map (i_A => i_A,
            i_B => s_B,
            i_Cin => i_nAdd_Sub,
	        o_Cout => o_Cout,
            o_Sum => o_Sum);

mux_st : mux21_n_st
  port map (i_A => i_B,
            i_B => s_A,
            i_S => i_nAdd_Sub,
			o_F => s_B);

oc_st : ones_complementer
  port map (i_A => i_B,
            o_F => s_A);

end structure;