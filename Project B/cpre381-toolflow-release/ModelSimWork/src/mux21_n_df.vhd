-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------


-- mux21_n_df.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Dataflow 2-1 n-bit mux for CPRE 381 Lab 2 P2d
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux21_n_df is
  generic(N : integer := 14);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       i_B  : in std_logic_vector(N-1 downto 0);
       i_S  : in std_logic;
       o_F  : out std_logic_vector(N-1 downto 0));

end mux21_n_df;

architecture dataflow of mux21_n_df is

begin

G1: for i in 0 to N-1 generate
  o_F(i) <= (i_S and i_B(i)) or (not i_S and i_A(i));
end generate;

end dataflow;