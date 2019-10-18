-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------


-- tb_np.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: testbench for new processor for CPRE 381 Lab 4 P3
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use work.vectorarraytype.all;
use IEEE.numeric_std.all;

entity tb_np is
  generic(gCLK_HPER   : time := 50 ns);
end tb_np;

architecture behavior of tb_np is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

  component newprocessor is
  port(i_CLK : in std_logic; -- clock
       i_RST : in std_logic; -- reset
       i_rs : in std_logic_vector(4 downto 0);  -- read address 1
	   i_rt : in std_logic_vector(4 downto 0);  -- read address 2
	   i_rd : in std_logic_vector(4 downto 0);  -- write address
	   i_nAdd_Sub : in std_logic; -- 0:add, 1:subtract
	   i_ALUSrc : in std_logic; -- 0:register, 1:extender
	   i_immediate : in std_logic_vector(15 downto 0);
	   i_RegWrite : in std_logic; -- 0:disabled, 1:enabled
	   i_MemWrite : in std_logic; -- 0:disabled, 1:enabled
	   i_DataSel : in std_logic; -- 0:regdata from alu, 1:regdata from memory
	   i_SignCtrl : in std_logic); -- 0:zero extend, 1:sign extend

  end component;
  
  signal s_CLK, s_RST, s_nAdd_Sub, s_ALUSrc, s_RegWrite, s_MemWrite,
         s_DataSel, s_SignCtrl : std_logic := '0';
  signal s_rs, s_rt, s_rd : std_logic_vector(4 downto 0) := "00000";
  signal s_immediate : std_logic_vector(15 downto 0) := x"0000";
  
  begin
  np : newprocessor
    port map (s_CLK, s_RST, s_rs, s_rt, s_rd, s_nAdd_Sub, s_ALUSrc,
	          s_immediate, s_RegWrite, s_MemWrite, s_DataSel, s_SignCtrl);
  
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
	wait for cCLK_PER;--100
	s_RST <= '0'; -- clear reset bit

	-- load &A into $25
	s_rd <= "11001"; -- write to $25
	s_RegWrite <= '1'; -- enable register write
	s_ALUSrc <= '0'; -- alu outputs read1+read2: 0
	-- mux outputs alu: &A=0
    wait for cCLK_PER;--200
	
	-- load &B into $26
	s_rd <= "11010"; -- write to $26
	s_immediate <= x"0100"; -- immediate is &B: 256
	s_ALUSrc <= '1';
	-- alu still outputs immediate, mux still outputs from alu:  &B=256
	s_DataSel <= '0';
    wait for cCLK_PER;--300
	
	-- load A[0] into $1
	s_DataSel <= '1'; -- mux outputs q
	s_rs <= "11001"; -- read1: $25
	s_immediate <= x"0000";
	s_rd <= "00001"; -- write: $1
	s_ALUSrc <= '1'; -- alu outputs read1+read2: 0(A[0])
    wait for cCLK_PER;--400
	
	-- load A[1] into $2
	s_immediate <= x"0004"; -- immediate is offset to A[1]: 4
	s_rd <= "00010"; -- write: $2
	s_ALUSrc <= '1'; -- alu outputs read1+immediate: 4(A[0])=A[1]
    wait for cCLK_PER;--500
	
	-- $1 += $2
	s_rs <= "00001"; -- read1: $1
	s_rt <= "00010"; -- read2: $2
	s_rd <= "00001"; -- write: $1
	s_ALUSrc <= '0'; -- alu outputs read1+read2: $1+$2
	s_DataSel <= '0'; -- mux outputs alu
    wait for cCLK_PER;--600
	
	-- store $1 into B[0]
	s_DataSel <= '1';
	s_rs <= "11010"; -- read1: $26
	s_rt <= "00001"; -- read2: $1
	s_immediate <= x"0000"; -- immediate: 0
	s_ALUSrc <= '1'; -- alu outputs read1+immediate: $26 + 0
	s_RegWrite <= '0'; -- disable register write
	s_MemWrite <= '1'; -- enable memory write
    wait for cCLK_PER;--700
	
	-- load A[2] into $2
	s_RegWrite <= '1'; -- enable register write
	s_MemWrite <= '0'; -- disable memory write
	s_rs <= "11001"; -- read1: $25
	s_immediate <= x"0008"; -- immediate is offset to A[2]: 8
	s_rd <= "00010"; -- write: $2
	-- alu outputs read1+immediate: 8(A[0])=A[2]
    wait for cCLK_PER;--800
	
	-- $1 += $2
	s_rs <= "00001"; -- read1: $1
	s_rt <= "00010"; -- read2: $2
	s_rd <= "00001"; -- write: $1
	s_ALUSrc <= '0'; -- alu outputs read1+read2: $1+$2
	s_DataSel <= '0'; -- mux outputs alu
    wait for cCLK_PER;--900
	
	-- store $1 into B[1]
	s_DataSel <= '1';
	s_ALUSrc <= '1'; -- alu outputs read1+immediate: $26 + 4
	s_rs <= "11010"; -- read1: $26
	s_rt <= "00001"; -- read2: $1
	s_immediate <= x"0004"; -- immediate is offset to B[1]: 4
	s_RegWrite <= '0'; -- disable register write
	s_MemWrite <= '1'; -- enable memory write
    wait for cCLK_PER;--1000
	
	-- load A[3] into $2
	s_RegWrite <= '1'; -- enable register write
	s_MemWrite <= '0'; -- disable memory write
	s_rs <= "11001"; -- read1: $25
	s_immediate <= x"000c"; -- immediate is offset to A[3]: 12
	s_rd <= "00010"; -- write: $2
	-- alu outputs read1+immediate: 12(A[0])=A[3]
    wait for cCLK_PER;--1100
	
	-- $1 += $2
	s_rs <= "00001"; -- read1: $1
	s_rt <= "00010"; -- read2: $2
	s_rd <= "00001"; -- write: $1
	s_ALUSrc <= '0'; -- alu outputs read1+read2: $1+$2
	s_DataSel <= '0'; -- mux outputs alu
    wait for cCLK_PER;--1200
	
	-- store $1 into B[2]
	s_DataSel <= '1';
	s_ALUSrc <= '1'; -- alu outputs read1+immediate: $26 + 8
	s_rs <= "11010"; -- read1: $26
	s_rt <= "00001"; -- read2: $1
	s_immediate <= x"0008"; -- immediate is offset to B[2]: 8
	s_RegWrite <= '0'; -- disable register write
	s_MemWrite <= '1'; -- enable memory write
    wait for cCLK_PER;--1300
	
	-- load A[4] into $2
	s_RegWrite <= '1'; -- enable register write
	s_MemWrite <= '0'; -- disable memory write
	s_rs <= "11001"; -- read1: $25
	s_immediate <= x"0010"; -- immediate is offset to A[4]: 16
	s_rd <= "00010"; -- write: $2
	-- alu outputs read1+immediate: 16(A[0])=A[4]
    wait for cCLK_PER;--1400
	
	-- $1 += $2
	s_rs <= "00001"; -- read1: $1
	s_rt <= "00010"; -- read2: $2
	s_rd <= "00001"; -- write: $1
	s_ALUSrc <= '0'; -- alu outputs read1+read2: $1+$2
	s_DataSel <= '0'; -- mux outputs alu
    wait for cCLK_PER;--1500
	
	-- store $1 into B[3]
	s_DataSel <= '1';
	s_ALUSrc <= '1'; -- alu outputs read1+immediate: $26 + 12
	s_rs <= "11010"; -- read1: $26
	s_rt <= "00001"; -- read2: $1
	s_immediate <= x"000c"; -- immediate is offset to B[3]: 12
	s_RegWrite <= '0'; -- disable register write
	s_MemWrite <= '1'; -- enable memory write
    wait for cCLK_PER;--1600
	
	-- load A[5] into $2
	s_RegWrite <= '1'; -- enable register write
	s_MemWrite <= '0'; -- disable memory write
	s_rs <= "11001"; -- read1: $25
	s_immediate <= x"0014"; -- immediate is offset to A[5]: 20
	s_rd <= "00010"; -- write: $2
	-- alu outputs read1+immediate: 20(A[0])=A[5]
    wait for cCLK_PER;--1700
	
	-- $1 += $2
	s_rs <= "00001"; -- read1: $1
	s_rt <= "00010"; -- read2: $2
	s_rd <= "00001"; -- write: $1
	s_ALUSrc <= '0'; -- alu outputs read1+read2: $1+$2
	s_DataSel <= '0'; -- mux outputs alu
    wait for cCLK_PER;--1800
	
	-- store $1 into B[4]
	s_DataSel <= '1';
	s_ALUSrc <= '1'; -- alu outputs read1+immediate: $26 + 16
	s_rs <= "11010"; -- read1: $26
	s_rt <= "00001"; -- read2: $1
	s_immediate <= x"0010"; -- immediate is offset to B[4]: 16
	s_RegWrite <= '0'; -- disable register write
	s_MemWrite <= '1'; -- enable memory write
    wait for cCLK_PER;--1900
	
	-- load A[6] into $2
	s_DataSel <= '0';
	s_RegWrite <= '1'; -- enable register write
	s_MemWrite <= '0'; -- disable memory write
	s_rs <= "11001"; -- read1: $25
	s_immediate <= x"0018"; -- immediate is offset to A[6]: 24
	s_rd <= "00010"; -- write: $2
	-- alu outputs read1+immediate: 24(A[0])=A[6]
    wait for cCLK_PER;--2000
	
	-- $1 += $2
	s_rs <= "00001"; -- read1: $1
	s_rt <= "00010"; -- read2: $2
	s_rd <= "00001"; -- write: $1
	s_ALUSrc <= '0'; -- alu outputs read1+read2: $1+$2
	s_DataSel <= '0'; -- mux outputs alu
    wait for cCLK_PER;--2100
	
	-- load &B[256] into $27
	s_rd <= "11011"; -- write to $27
	s_immediate <= x"0200"; -- immediate is &B[256]: 512
	s_ALUSrc <= '1'; -- alu outputs immediate
	s_DataSel <= '0'; -- mux outputs from alu: &B[256]=512
    wait for cCLK_PER;--2200
	
	-- store $1 into B[255]
	s_ALUSrc <= '1'; -- alu outputs read1+immediate: -4(B[256])=B[255]
	s_RegWrite <= '0'; -- disable register write
	s_MemWrite <= '1'; -- enable memory write
	s_SignCtrl <= '1'; -- enable sign extend
	s_rs <= "11011"; -- read1: $27
	s_rt <= "00001"; -- read2: $1
	s_immediate <= x"FFFC"; -- immediate is offset to B[255]: -4
    wait for cCLK_PER;--2300
	
    wait;
  end process;
  
end behavior;
