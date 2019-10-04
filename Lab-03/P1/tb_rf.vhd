-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------


-- tb_rf.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: testbench for registerfile for CPRE 381 Lab 3 P1i
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use work.vectorarraytype.all;
use IEEE.numeric_std.all;

entity tb_rf is
  generic(gCLK_HPER   : time := 50 ps);
end tb_rf;

architecture behavior of tb_rf is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

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
  
  signal s_A : vectorarray := (x"00000000",x"01010101",x"02020202",x"03030303",
                               x"04040404",x"05050505",x"06060606",x"07070707",
							   x"08080808",x"09090909",x"0a0a0a0a",x"0b0b0b0b",
							   x"0c0c0c0c",x"0d0d0d0d",x"0e0e0e0e",x"0f0f0f0f",
							   x"10101010",x"11111111",x"12121212",x"13131313",
							   x"14141414",x"15151515",x"16161616",x"17171717",
							   x"18181818",x"19191919",x"1a1a1a1a",x"1b1b1b1b",
							   x"1c1c1c1c",x"1d1d1d1d",x"1e1e1e1e",x"1f1f1f1f");
  signal s_CLK, s_RST : std_logic := '0';
  signal s_rs, s_rt, s_rd : std_logic_vector(4 downto 0) := "00000";
  signal s_wd, s_rd1, s_rd2 : std_logic_vector(31 downto 0) := x"00000000";
  
  begin
  rf : registerfile
    port map (s_CLK, s_RST, s_rs, s_rt, s_rd, s_wd, s_rd1, s_rd2);
  
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin
  
    s_RST <= '1'; -- reset to make sure every register is at 0
	wait for cCLK_PER;
    
	s_RST <= '0';
	s_wd <= x"aaaaaaaa"; -- make r1 scream
	s_rd <= "00001";
	s_rs <= "00001";
	s_rt <= "00001";
    wait for cCLK_PER;
	
	s_wd <= x"aaaaaaaa"; -- try to scare r0
	s_rd <= "00000"; -- but r0 is a badass and doesn't scream
	s_rt <= "00000";
    wait for cCLK_PER;
	
	s_wd <= x"decea5ed"; -- murder r31
	s_rd <= "11111";
	s_rs <= "11111";
    wait for cCLK_PER;
	
	s_RST <= '1'; -- reset
	wait for cCLK_PER;
	
	s_RST <= '0';
	s_wd <= x"1badbeef"; -- an evil cow attacks r18
	s_rd <= "10010";
	s_rs <= "10010";
    wait for cCLK_PER;
	
	s_wd <= x"beefdead"; -- r17 fights off r18's attacker
	s_rd <= "10001";
	s_rt <= "10001";
    wait for cCLK_PER;
	
	-- populate all registers with corresponding the values in s_A
	G1 : for i in 0 to 31 loop
      s_wd <= s_A(i);
	  s_rd <= std_logic_vector(to_unsigned(i, s_rd'length));
	  s_rt <= std_logic_vector(to_unsigned(i, s_rd'length));
	  wait for cCLK_PER;
    end loop G1;
    wait;
  end process;
  
end behavior;
