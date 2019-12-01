-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------


-- fulladder_n_df.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Dataflow n-bit Full Adder for CPRE 381 Lab 2 P3d
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity fulladder_n_df is
  generic(N : integer := 14);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       i_B  : in std_logic_vector(N-1 downto 0);
       i_Cin  : in std_logic; -- carry in
	   o_Cout  : out std_logic; -- carry out
       o_Sum  : out std_logic_vector(N-1 downto 0)); -- sum

end fulladder_n_df;

architecture dataflow of fulladder_n_df is

signal s_A : std_logic_vector(N-1 downto 0);
signal s_B : std_logic_vector(N-1 downto 0);
signal s_C : std_logic_vector(N-1 downto 0);
signal s_D : std_logic_vector(N-1 downto 0);

begin

  s_A(0) <= i_Cin; -- store our carry in value in the first bit
  s_B <= i_A xor i_B;
  s_C <= i_A and i_B;
  s_D <= s_B and s_A;

  G1: for i in 0 to N-2 generate
    s_A(i+1) <= s_C(i) or s_D(i);
  end generate;
  
  o_Sum <= s_B xor s_A;
  o_Cout <= s_C(N-1) or s_D(N-1);
					   
end dataflow;