-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------


-- registerfile.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: registerfile for CPRE 381 Lab 3 P1i
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.vectorarraytype.all;

entity registerfile is
  port(i_CLK : in std_logic; -- clock
       i_RST : in std_logic; -- reset
       i_rs  : in std_logic_vector(4 downto 0);  -- read address 1
	   i_rt  : in std_logic_vector(4 downto 0);  -- read address 2
	   i_rd  : in std_logic_vector(4 downto 0);  -- write address
	   i_wd  : in std_logic_vector(31 downto 0);  -- write data
	   o_rd1 : out std_logic_vector(31 downto 0);  -- read data 1
	   o_rd2 : out std_logic_vector(31 downto 0)); -- read data 2

end registerfile;

architecture structural of registerfile is

component dff_n is
  generic(N  : integer := 32);
  port(i_CLK : in std_logic;
       i_RST : in std_logic;
       i_WE  : in std_logic;
       i_D   : in std_logic_vector(N-1 downto 0);
       o_Q   : out std_logic_vector(N-1 downto 0));
end component;

component mux_321_df is
  port(i_A : vectorarray;
       i_S : in std_logic_vector(4 downto 0);
       o_X : out std_logic_vector(31 downto 0));
end component;

component decoder_532_df is
  port(i_A : in std_logic_vector(4 downto 0);
       o_B : out std_logic_vector(31 downto 0));
end component;

signal s_A : std_logic_vector(31 downto 0); -- stores write enable status of registers
signal s_B : vectorarray; -- array of vectors holding our data
begin
  
  dec1 : decoder_532_df
    port map (i_A => i_rd,
	          o_B => s_A); -- store bits to write to in s_A
			  
  s_B(0) <= x"00000000";
  G1: for i in 1 to 31 generate
  begin
    dff_i : dff_n
	  generic map (N => 32)
	  port map (i_CLK => i_CLK,
                i_RST => i_RST,
                i_WE => s_A(i),
                i_D => i_wd,
                o_Q => s_B(i));
  end generate;
  
  mux1 : mux_321_df
    port map (i_A => s_B,
	          i_S => i_rs,
			  o_X => o_rd1);

  mux2 : mux_321_df
    port map (i_A => s_B,
	          i_S => i_rt,
			  o_X => o_rd2);

end structural;