-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------


-- addsub_n_st_new.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Structural n-bit adder/subtractor for CPRE 381 Lab 3 P2a
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity addsub_n_st_new is
  generic(N : integer := 32);
  port(i_A : in std_logic_vector(N-1 downto 0);
       i_B : in std_logic_vector(N-1 downto 0);
       i_nAdd_Sub : in std_logic;
	   i_ALUSrc : in std_logic;
	   i_immediate : in std_logic_vector(N-1 downto 0);
	   o_Cout : out std_logic; -- carry out
       o_Sum : out std_logic_vector(N-1 downto 0)); -- sum

end addsub_n_st_new;

architecture structure of addsub_n_st_new is

component addsub_n_st is
  generic(N : integer := 32);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       i_B  : in std_logic_vector(N-1 downto 0);
       i_nAdd_Sub  : in std_logic; -- carry in
	   o_Cout  : out std_logic; -- carry out
       o_Sum  : out std_logic_vector(N-1 downto 0)); -- sum

end component;

component mux21_n_st is
  generic(N : integer := 32);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       i_B  : in std_logic_vector(N-1 downto 0);
       i_S  : in std_logic;
       o_F  : out std_logic_vector(N-1 downto 0));
end component;

signal s_A : std_logic_vector(N-1 downto 0);

begin

as_st : addsub_n_st
  port map (i_A => i_A,
            i_B => s_A,
            i_nAdd_Sub => i_nAdd_Sub,
	        o_Cout => o_Cout,
            o_Sum => o_Sum);

mux_st : mux21_n_st
  port map (i_A => i_B,
            i_B => i_immediate,
            i_S => i_ALUSrc,
			o_F => s_A);

end structure;