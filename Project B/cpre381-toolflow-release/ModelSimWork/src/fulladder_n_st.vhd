-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------


-- fulladder_n_st.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Structural n-bit Full Adder for CPRE 381 Lab 2 P3c
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity fulladder_n_st is
  generic(N : integer := 14);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       i_B  : in std_logic_vector(N-1 downto 0);
       i_Cin  : in std_logic; -- carry in
	   o_Cout  : out std_logic; -- carry out
       o_Sum  : out std_logic_vector(N-1 downto 0)); -- sum

end fulladder_n_st;

architecture structure of fulladder_n_st is

component fulladder is
  port(i_A  : in std_logic;
       i_B  : in std_logic;
       i_Cin  : in std_logic; -- carry in
	   o_Cout  : out std_logic; -- carry out
       o_Sum  : out std_logic); -- sum
end component;

-- using N rather than n-1 here because the signal will store both carry ins and outs
-- s_A(n) will hold the carryout
signal s_A : std_logic_vector(N downto 0);

begin

s_A(0) <= i_Cin; -- store our carry in value in the first bit

G1: for i in 0 to N-1 generate
  fa1 : fulladder port map (i_A => i_A(i),
                            i_B => i_B(i),
							i_Cin => s_A(i),
							o_Cout => s_A(i+1),
							o_Sum => o_Sum(i));
end generate;
  
o_Cout <= s_A(N);
					   
end structure;