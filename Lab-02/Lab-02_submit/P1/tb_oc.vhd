-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------


-- tb_oc.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Testbench for one's complementers for CPRE 381 Lab 2 P1c
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_oc is
  generic(M : integer := 32);
  port(o_X  : out std_logic_vector(M-1 downto 0);
       o_Y  : out std_logic_vector(M-1 downto 0));

end tb_oc;

architecture behavior of tb_oc is

component ones_complementer
  generic(N : integer := 32);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       o_F  : out std_logic_vector(N-1 downto 0));
end component;

component ones_complementer_df
  generic(N : integer := 32);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       o_F  : out std_logic_vector(N-1 downto 0));
end component;

signal s_A : std_logic_vector(M-1 downto 0);

begin
  
  oc : ones_complementer
    generic map(N => M)
    port map(i_A  => s_A,
             o_F  => o_X);

  ocdf : ones_complementer_df
    generic map(N => M)
    port map(i_A  => s_A,
             o_F  => o_Y);
  
  process
    begin
      s_A <= "00000000000000001111111111111111";
      wait for 100 ps;
      s_A <= "01010101010101010101010101010101";
      wait for 100 ps;
      s_A <= "11110000111100001111000011110000";
      wait for 100 ps;
  end process;
end behavior;