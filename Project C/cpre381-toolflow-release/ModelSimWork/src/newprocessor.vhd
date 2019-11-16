-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------
-- newprocessor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: processor for CPRE 381 Lab 4 P3c
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE work.vectorarraytype.ALL;

ENTITY newprocessor IS
	PORT (
		i_CLK : IN std_logic; -- clock
		i_RST : IN std_logic; -- reset
		i_rs : IN std_logic_vector(4 DOWNTO 0); -- read address 1
		i_rt : IN std_logic_vector(4 DOWNTO 0); -- read address 2
		i_rd : IN std_logic_vector(4 DOWNTO 0); -- write address
		i_nAdd_Sub : IN std_logic;
		i_ALUSrc : IN std_logic;
		i_immediate : IN std_logic_vector(15 DOWNTO 0);
		i_RegWrite : IN std_logic;
		i_MemWrite : IN std_logic;
		i_DataSel : IN std_logic;
		i_SignCtrl : IN std_logic);

END newprocessor;

ARCHITECTURE structural OF newprocessor IS

	COMPONENT registerfile IS
		PORT (
			i_CLK : IN std_logic; -- clock
			i_RST : IN std_logic; -- reset
			i_rw : IN std_logic; -- read/write toggle
			i_rs : IN std_logic_vector(4 DOWNTO 0); -- read address 1
			i_rt : IN std_logic_vector(4 DOWNTO 0); -- read address 2
			i_rd : IN std_logic_vector(4 DOWNTO 0); -- write address
			i_wd : IN std_logic_vector(31 DOWNTO 0); -- write data
			o_rd1 : OUT std_logic_vector(31 DOWNTO 0); -- read data 1
			o_rd2 : OUT std_logic_vector(31 DOWNTO 0)); -- read data 2

	END COMPONENT;

	COMPONENT addsub_n_st_new IS
		GENERIC (N : INTEGER := 32);
		PORT (
			i_A : IN std_logic_vector(N - 1 DOWNTO 0);
			i_B : IN std_logic_vector(N - 1 DOWNTO 0);
			i_nAdd_Sub : IN std_logic;
			i_ALUSrc : IN std_logic;
			i_immediate : IN std_logic_vector(N - 1 DOWNTO 0);
			o_Cout : OUT std_logic; -- carry out
			o_Sum : OUT std_logic_vector(N - 1 DOWNTO 0)); -- sum

	END COMPONENT;

	COMPONENT mux21_n_df IS
		GENERIC (N : INTEGER := 14);
		PORT (
			i_A : IN std_logic_vector(N - 1 DOWNTO 0);
			i_B : IN std_logic_vector(N - 1 DOWNTO 0);
			i_S : IN std_logic;
			o_F : OUT std_logic_vector(N - 1 DOWNTO 0));

	END COMPONENT;

	COMPONENT extender IS
		GENERIC (N : INTEGER := 8);
		PORT (
			i_A : IN std_logic_vector(N - 1 DOWNTO 0); -- input vector
			i_B : IN std_logic; -- sign control bit
			o_Z : OUT std_logic_vector(31 DOWNTO 0)); -- output extension

	END COMPONENT;

	COMPONENT mem IS
		GENERIC (
			DATA_WIDTH : NATURAL := 32;
			ADDR_WIDTH : NATURAL := 10);
		PORT (
			clk : IN std_logic;
			addr : IN std_logic_vector((ADDR_WIDTH - 1) DOWNTO 0);
			data : IN std_logic_vector((DATA_WIDTH - 1) DOWNTO 0);
			we : IN std_logic := '1';
			q : OUT std_logic_vector((DATA_WIDTH - 1) DOWNTO 0));

	END COMPONENT;

	SIGNAL s_rd1 : std_logic_vector(31 DOWNTO 0); -- read data 1
	SIGNAL s_rd2 : std_logic_vector(31 DOWNTO 0); -- read data 2
	SIGNAL s_ALUOut : std_logic_vector(31 DOWNTO 0); -- ALU to mux/memory
	SIGNAL s_MuxOut : std_logic_vector(31 DOWNTO 0); -- mux to register data
	SIGNAL s_ExtOut : std_logic_vector(31 DOWNTO 0); -- Extender to ALU
	SIGNAL s_Q : std_logic_vector(31 DOWNTO 0); -- q to mux
	SIGNAL s_Cout : std_logic;

BEGIN

	dmem : mem
	GENERIC MAP(ADDR_WIDTH => 12)
	PORT MAP(
		clk => i_CLK,
		addr => s_ALUOut(13 DOWNTO 2),
		data => s_rd2,
		we => i_MemWrite,
		q => s_Q);

	ex : extender
	GENERIC MAP(N => 16)
	PORT MAP(
		i_A => i_immediate,
		i_B => i_SignCtrl,
		o_Z => s_ExtOut);

	rf : registerfile
	PORT MAP(
		i_CLK => i_CLK,
		i_RST => i_RST,
		i_rw => i_RegWrite,
		i_rs => i_rs,
		i_rt => i_rt,
		i_rd => i_rd,
		i_wd => s_MuxOut,
		o_rd1 => s_rd1,
		o_rd2 => s_rd2);

	datamux : mux21_n_df
	GENERIC MAP(N => 32)
	PORT MAP(
		i_A => s_ALUOut,
		i_B => s_Q,
		i_S => i_DataSel,
		o_F => s_MuxOut);

	alu : addsub_n_st_new
	PORT MAP(
		i_A => s_rd1,
		i_B => s_rd2,
		i_nAdd_Sub => i_nAdd_Sub,
		i_ALUSrc => i_ALUSrc,
		i_immediate => s_ExtOut,
		o_Cout => s_Cout,
		o_Sum => s_ALUOut);

END structural;