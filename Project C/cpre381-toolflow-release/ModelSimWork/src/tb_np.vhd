-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------
-- tb_np.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: testbench for new processor for CPRE 381 Lab 4 P3
-------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE work.vectorarraytype.ALL;
USE IEEE.numeric_std.ALL;

ENTITY tb_np IS
	GENERIC (gCLK_HPER : TIME := 50 ns);
END tb_np;

ARCHITECTURE behavior OF tb_np IS

	-- Calculate the clock period as twice the half-period
	CONSTANT cCLK_PER : TIME := gCLK_HPER * 2;

	COMPONENT newprocessor IS
		PORT (
			i_CLK : IN std_logic; -- clock
			i_RST : IN std_logic; -- reset
			i_rs : IN std_logic_vector(4 DOWNTO 0); -- read address 1
			i_rt : IN std_logic_vector(4 DOWNTO 0); -- read address 2
			i_rd : IN std_logic_vector(4 DOWNTO 0); -- write address
			i_nAdd_Sub : IN std_logic; -- 0:add, 1:subtract
			i_ALUSrc : IN std_logic; -- 0:register, 1:extender
			i_immediate : IN std_logic_vector(15 DOWNTO 0);
			i_RegWrite : IN std_logic; -- 0:disabled, 1:enabled
			i_MemWrite : IN std_logic; -- 0:disabled, 1:enabled
			i_DataSel : IN std_logic; -- 0:regdata from alu, 1:regdata from memory
			i_SignCtrl : IN std_logic); -- 0:zero extend, 1:sign extend

	END COMPONENT;

	SIGNAL s_CLK, s_RST, s_nAdd_Sub, s_ALUSrc, s_RegWrite, s_MemWrite,
	s_DataSel, s_SignCtrl : std_logic := '0';
	SIGNAL s_rs, s_rt, s_rd : std_logic_vector(4 DOWNTO 0) := "00000";
	SIGNAL s_immediate : std_logic_vector(15 DOWNTO 0) := x"0000";

BEGIN
	np : newprocessor
	PORT MAP(
		s_CLK, s_RST, s_rs, s_rt, s_rd, s_nAdd_Sub, s_ALUSrc,
		s_immediate, s_RegWrite, s_MemWrite, s_DataSel, s_SignCtrl);

	P_CLK : PROCESS
	BEGIN
		s_CLK <= '0';
		WAIT FOR gCLK_HPER;
		s_CLK <= '1';
		WAIT FOR gCLK_HPER;
	END PROCESS;

	-- Testbench process  
	P_TB : PROCESS
	BEGIN

		s_RST <= '1'; -- reset registers
		WAIT FOR cCLK_PER;--100
		s_RST <= '0'; -- clear reset bit

		-- load &A into $25
		s_rd <= "11001"; -- write to $25
		s_RegWrite <= '1'; -- enable register write
		s_ALUSrc <= '0'; -- alu outputs read1+read2: 0
		-- mux outputs alu: &A=0
		WAIT FOR cCLK_PER;--200

		-- load &B into $26
		s_rd <= "11010"; -- write to $26
		s_immediate <= x"0100"; -- immediate is &B: 256
		s_ALUSrc <= '1';
		-- alu still outputs immediate, mux still outputs from alu:  &B=256
		s_DataSel <= '0';
		WAIT FOR cCLK_PER;--300

		-- load A[0] into $1
		s_DataSel <= '1'; -- mux outputs q
		s_rs <= "11001"; -- read1: $25
		s_immediate <= x"0000";
		s_rd <= "00001"; -- write: $1
		s_ALUSrc <= '1'; -- alu outputs read1+read2: 0(A[0])
		WAIT FOR cCLK_PER;--400

		-- load A[1] into $2
		s_immediate <= x"0004"; -- immediate is offset to A[1]: 4
		s_rd <= "00010"; -- write: $2
		s_ALUSrc <= '1'; -- alu outputs read1+immediate: 4(A[0])=A[1]
		WAIT FOR cCLK_PER;--500

		-- $1 += $2
		s_rs <= "00001"; -- read1: $1
		s_rt <= "00010"; -- read2: $2
		s_rd <= "00001"; -- write: $1
		s_ALUSrc <= '0'; -- alu outputs read1+read2: $1+$2
		s_DataSel <= '0'; -- mux outputs alu
		WAIT FOR cCLK_PER;--600

		-- store $1 into B[0]
		s_DataSel <= '1';
		s_rs <= "11010"; -- read1: $26
		s_rt <= "00001"; -- read2: $1
		s_immediate <= x"0000"; -- immediate: 0
		s_ALUSrc <= '1'; -- alu outputs read1+immediate: $26 + 0
		s_RegWrite <= '0'; -- disable register write
		s_MemWrite <= '1'; -- enable memory write
		WAIT FOR cCLK_PER;--700

		-- load A[2] into $2
		s_RegWrite <= '1'; -- enable register write
		s_MemWrite <= '0'; -- disable memory write
		s_rs <= "11001"; -- read1: $25
		s_immediate <= x"0008"; -- immediate is offset to A[2]: 8
		s_rd <= "00010"; -- write: $2
		-- alu outputs read1+immediate: 8(A[0])=A[2]
		WAIT FOR cCLK_PER;--800

		-- $1 += $2
		s_rs <= "00001"; -- read1: $1
		s_rt <= "00010"; -- read2: $2
		s_rd <= "00001"; -- write: $1
		s_ALUSrc <= '0'; -- alu outputs read1+read2: $1+$2
		s_DataSel <= '0'; -- mux outputs alu
		WAIT FOR cCLK_PER;--900

		-- store $1 into B[1]
		s_DataSel <= '1';
		s_ALUSrc <= '1'; -- alu outputs read1+immediate: $26 + 4
		s_rs <= "11010"; -- read1: $26
		s_rt <= "00001"; -- read2: $1
		s_immediate <= x"0004"; -- immediate is offset to B[1]: 4
		s_RegWrite <= '0'; -- disable register write
		s_MemWrite <= '1'; -- enable memory write
		WAIT FOR cCLK_PER;--1000

		-- load A[3] into $2
		s_RegWrite <= '1'; -- enable register write
		s_MemWrite <= '0'; -- disable memory write
		s_rs <= "11001"; -- read1: $25
		s_immediate <= x"000c"; -- immediate is offset to A[3]: 12
		s_rd <= "00010"; -- write: $2
		-- alu outputs read1+immediate: 12(A[0])=A[3]
		WAIT FOR cCLK_PER;--1100

		-- $1 += $2
		s_rs <= "00001"; -- read1: $1
		s_rt <= "00010"; -- read2: $2
		s_rd <= "00001"; -- write: $1
		s_ALUSrc <= '0'; -- alu outputs read1+read2: $1+$2
		s_DataSel <= '0'; -- mux outputs alu
		WAIT FOR cCLK_PER;--1200

		-- store $1 into B[2]
		s_DataSel <= '1';
		s_ALUSrc <= '1'; -- alu outputs read1+immediate: $26 + 8
		s_rs <= "11010"; -- read1: $26
		s_rt <= "00001"; -- read2: $1
		s_immediate <= x"0008"; -- immediate is offset to B[2]: 8
		s_RegWrite <= '0'; -- disable register write
		s_MemWrite <= '1'; -- enable memory write
		WAIT FOR cCLK_PER;--1300

		-- load A[4] into $2
		s_RegWrite <= '1'; -- enable register write
		s_MemWrite <= '0'; -- disable memory write
		s_rs <= "11001"; -- read1: $25
		s_immediate <= x"0010"; -- immediate is offset to A[4]: 16
		s_rd <= "00010"; -- write: $2
		-- alu outputs read1+immediate: 16(A[0])=A[4]
		WAIT FOR cCLK_PER;--1400

		-- $1 += $2
		s_rs <= "00001"; -- read1: $1
		s_rt <= "00010"; -- read2: $2
		s_rd <= "00001"; -- write: $1
		s_ALUSrc <= '0'; -- alu outputs read1+read2: $1+$2
		s_DataSel <= '0'; -- mux outputs alu
		WAIT FOR cCLK_PER;--1500

		-- store $1 into B[3]
		s_DataSel <= '1';
		s_ALUSrc <= '1'; -- alu outputs read1+immediate: $26 + 12
		s_rs <= "11010"; -- read1: $26
		s_rt <= "00001"; -- read2: $1
		s_immediate <= x"000c"; -- immediate is offset to B[3]: 12
		s_RegWrite <= '0'; -- disable register write
		s_MemWrite <= '1'; -- enable memory write
		WAIT FOR cCLK_PER;--1600

		-- load A[5] into $2
		s_RegWrite <= '1'; -- enable register write
		s_MemWrite <= '0'; -- disable memory write
		s_rs <= "11001"; -- read1: $25
		s_immediate <= x"0014"; -- immediate is offset to A[5]: 20
		s_rd <= "00010"; -- write: $2
		-- alu outputs read1+immediate: 20(A[0])=A[5]
		WAIT FOR cCLK_PER;--1700

		-- $1 += $2
		s_rs <= "00001"; -- read1: $1
		s_rt <= "00010"; -- read2: $2
		s_rd <= "00001"; -- write: $1
		s_ALUSrc <= '0'; -- alu outputs read1+read2: $1+$2
		s_DataSel <= '0'; -- mux outputs alu
		WAIT FOR cCLK_PER;--1800

		-- store $1 into B[4]
		s_DataSel <= '1';
		s_ALUSrc <= '1'; -- alu outputs read1+immediate: $26 + 16
		s_rs <= "11010"; -- read1: $26
		s_rt <= "00001"; -- read2: $1
		s_immediate <= x"0010"; -- immediate is offset to B[4]: 16
		s_RegWrite <= '0'; -- disable register write
		s_MemWrite <= '1'; -- enable memory write
		WAIT FOR cCLK_PER;--1900

		-- load A[6] into $2
		s_DataSel <= '0';
		s_RegWrite <= '1'; -- enable register write
		s_MemWrite <= '0'; -- disable memory write
		s_rs <= "11001"; -- read1: $25
		s_immediate <= x"0018"; -- immediate is offset to A[6]: 24
		s_rd <= "00010"; -- write: $2
		-- alu outputs read1+immediate: 24(A[0])=A[6]
		WAIT FOR cCLK_PER;--2000

		-- $1 += $2
		s_rs <= "00001"; -- read1: $1
		s_rt <= "00010"; -- read2: $2
		s_rd <= "00001"; -- write: $1
		s_ALUSrc <= '0'; -- alu outputs read1+read2: $1+$2
		s_DataSel <= '0'; -- mux outputs alu
		WAIT FOR cCLK_PER;--2100

		-- load &B[256] into $27
		s_rd <= "11011"; -- write to $27
		s_immediate <= x"0200"; -- immediate is &B[256]: 512
		s_ALUSrc <= '1'; -- alu outputs immediate
		s_DataSel <= '0'; -- mux outputs from alu: &B[256]=512
		WAIT FOR cCLK_PER;--2200

		-- store $1 into B[255]
		s_ALUSrc <= '1'; -- alu outputs read1+immediate: -4(B[256])=B[255]
		s_RegWrite <= '0'; -- disable register write
		s_MemWrite <= '1'; -- enable memory write
		s_SignCtrl <= '1'; -- enable sign extend
		s_rs <= "11011"; -- read1: $27
		s_rt <= "00001"; -- read2: $1
		s_immediate <= x"FFFC"; -- immediate is offset to B[255]: -4
		WAIT FOR cCLK_PER;--2300

		WAIT;
	END PROCESS;

END behavior;