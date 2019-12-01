-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------


-- tb_sp.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: testbench for simple processor for CPRE 381 Lab 3 P2c
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use work.vectorarraytype.all;
use IEEE.numeric_std.all;

entity tb_sp is
  generic(gCLK_HPER   : time := 50 ps);
end tb_sp;

architecture behavior of tb_sp is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

  component simpleprocessor is
  port(i_CLK : in std_logic; -- clock
       i_RST : in std_logic; -- reset
       i_rs : in std_logic_vector(4 downto 0);  -- read address 1
	   i_rt : in std_logic_vector(4 downto 0);  -- read address 2
	   i_rd : in std_logic_vector(4 downto 0);  -- write address
	   i_wd : in std_logic_vector(31 downto 0);  -- write data
	   i_nAdd_Sub : in std_logic;
	   i_ALUSrc : in std_logic;
	   i_immediate : in std_logic_vector(31 downto 0));

  end component;
  
  signal s_CLK, s_RST, s_nAdd_Sub, s_ALUSrc : std_logic := '0';
  signal s_rs, s_rt, s_rd : std_logic_vector(4 downto 0) := "00000";
  signal s_wd, s_immediate : std_logic_vector(31 downto 0) := x"00000000";
  
  begin
  sp : simpleprocessor
    port map (s_CLK, s_RST, s_rs, s_rt, s_rd, s_wd, s_nAdd_Sub, s_ALUSrc, s_immediate);
  
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
  
    s_RST <= '1'; -- reset registers
	wait for cCLK_PER;
    
	s_RST <= '0';
	s_rs <= "00000";
	s_rd <= "00001";
	s_nAdd_Sub <= '0';
	s_ALUSrc <= '1';
	s_immediate <= x"00000001";
    wait for cCLK_PER;
	
	s_rd <= "00010";
	s_immediate <= x"00000002";
    wait for cCLK_PER;
	
	s_rd <= "00011";
	s_immediate <= x"00000003";
    wait for cCLK_PER;
	
	s_rd <= "00100";
	s_immediate <= x"00000004";
    wait for cCLK_PER;
	
	s_rd <= "00101";
	s_immediate <= x"00000005";
    wait for cCLK_PER;
	
	s_rd <= "00110";
	s_immediate <= x"00000006";
    wait for cCLK_PER;
	
	s_rd <= "00111";
	s_immediate <= x"00000007";
    wait for cCLK_PER;
	
	s_rd <= "01000";
	s_immediate <= x"00000008";
    wait for cCLK_PER;
	
	s_rd <= "01001";
	s_immediate <= x"00000009";
    wait for cCLK_PER;
	
	s_rd <= "01010";
	s_immediate <= x"0000000a";
    wait for cCLK_PER;
	
	s_rs <= "00001";
	s_rt <= "00010";
	s_rd <= "01011";
	s_ALUSrc <= '0';
    wait for cCLK_PER;
	
	s_rs <= "01011";
	s_rt <= "00011";
	s_rd <= "01100";
	s_nAdd_Sub <= '1';
    wait for cCLK_PER;
	
	s_rs <= "01100";
	s_rt <= "00100";
	s_rd <= "01101";
	s_nAdd_Sub <= '0';
    wait for cCLK_PER;
	
	s_rs <= "01101";
	s_rt <= "00101";
	s_rd <= "01110";
	s_nAdd_Sub <= '1';
    wait for cCLK_PER;
	
	s_rs <= "01110";
	s_rt <= "00110";
	s_rd <= "01111";
	s_nAdd_Sub <= '0';
    wait for cCLK_PER;
	
	s_rs <= "01111";
	s_rt <= "00111";
	s_rd <= "10000";
	s_nAdd_Sub <= '1';
    wait for cCLK_PER;
	
	s_rs <= "10000";
	s_rt <= "01000";
	s_rd <= "10001";
	s_nAdd_Sub <= '0';
    wait for cCLK_PER;
	
	s_rs <= "10001";
	s_rt <= "01001";
	s_rd <= "10010";
	s_nAdd_Sub <= '1';
    wait for cCLK_PER;
	
	s_rs <= "10010";
	s_rt <= "01010";
	s_rd <= "10011";
	s_nAdd_Sub <= '0';
    wait for cCLK_PER;
	
	s_rs <= "00000";
	s_rd <= "10100";
	s_nAdd_Sub <= '0';
	s_ALUSrc <= '1';
	s_immediate <= x"00000023";
    wait for cCLK_PER;
	
	s_rs <= "10010";
	s_rt <= "01010";
	s_rd <= "10101";
	s_nAdd_Sub <= '0';
	s_ALUSrc <= '0';
    wait for cCLK_PER;
		
    wait;
  end process;
  
end behavior;
