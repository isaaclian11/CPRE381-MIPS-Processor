-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------


-- simpleprocessor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: simple processor for CPRE 381 Lab 3 P2c
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.vectorarraytype.all;

entity simpleprocessor is
  port(i_CLK : in std_logic; -- clock
       i_RST : in std_logic; -- reset
       i_rs : in std_logic_vector(4 downto 0);  -- read address 1
	   i_rt : in std_logic_vector(4 downto 0);  -- read address 2
	   i_rd : in std_logic_vector(4 downto 0);  -- write address
	   i_wd : in std_logic_vector(31 downto 0);  -- write data
	   i_nAdd_Sub : in std_logic;
	   i_ALUSrc : in std_logic;
	   i_immediate : in std_logic_vector(31 downto 0));

end simpleprocessor;

architecture structural of simpleprocessor is

component registerfile is
  port(i_CLK : in std_logic; -- clock
       i_RST : in std_logic; -- reset
       i_rs  : in std_logic_vector(4 downto 0);  -- read address 1
	   i_rt  : in std_logic_vector(4 downto 0);  -- read address 2
	   i_rd  : in std_logic_vector(4 downto 0);  -- write address
	   i_wd  : in std_logic_vector(31 downto 0);  -- write data
	   o_rd1 : out std_logic_vector(31 downto 0);  -- read data 1
	   o_rd2 : out std_logic_vector(31 downto 0)); -- read data 2

end component;

component addsub_n_st_new is
  generic(N : integer := 32);
  port(i_A : in std_logic_vector(N-1 downto 0);
       i_B : in std_logic_vector(N-1 downto 0);
       i_nAdd_Sub : in std_logic;
	   i_ALUSrc : in std_logic;
	   i_immediate : in std_logic_vector(N-1 downto 0);
	   o_Cout : out std_logic; -- carry out
       o_Sum : out std_logic_vector(N-1 downto 0)); -- sum

end component;

signal s_rd1 : std_logic_vector(31 downto 0);  -- read data 1
signal s_rd2 : std_logic_vector(31 downto 0); -- read data 2
signal s_A : std_logic_vector(31 downto 0); -- ALU output
signal s_Cout : std_logic;

begin

rf : registerfile
  port map (i_CLK => i_CLK,
            i_RST => i_RST,
            i_rs => i_rs,
	        i_rt => i_rt,
	        i_rd => i_rd,
	        i_wd => s_A,
	        o_rd1 => s_rd1,
	        o_rd2 => s_rd2);

alu : addsub_n_st_new
  port map (i_A => s_rd1,
            i_B => s_rd2,
			i_nAdd_Sub => i_nAdd_Sub,
            i_ALUSrc => i_ALUSrc,
			i_immediate => i_immediate,
			o_Cout => s_Cout,
			o_Sum => s_A);

end structural;