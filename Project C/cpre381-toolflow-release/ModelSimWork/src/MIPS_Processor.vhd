-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY MIPS_Processor IS
	GENERIC (N : INTEGER := 32);
	PORT (
		iCLK : IN std_logic;
		iRST : IN std_logic;
		iInstLd : IN std_logic;
		iInstAddr : IN std_logic_vector(N - 1 DOWNTO 0);
		iInstExt : IN std_logic_vector(N - 1 DOWNTO 0);
		oALUOut : OUT std_logic_vector(N - 1 DOWNTO 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

END MIPS_Processor;
ARCHITECTURE structure OF MIPS_Processor IS

	-- Required data memory signals
	SIGNAL s_DMemWr : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
	SIGNAL s_DMemAddr : std_logic_vector(N - 1 DOWNTO 0); -- TODO: use this signal as the final data memory address input
	SIGNAL s_DMemData : std_logic_vector(N - 1 DOWNTO 0); -- TODO: use this signal as the final data memory data input
	SIGNAL s_DMemOut : std_logic_vector(N - 1 DOWNTO 0); -- TODO: use this signal as the data memory output

	-- Required register file signals 
	SIGNAL s_RegWr : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
	SIGNAL s_RegWrAddr : std_logic_vector(4 DOWNTO 0); -- TODO: use this signal as the final destination register address input
	SIGNAL s_RegWrData : std_logic_vector(N - 1 DOWNTO 0); -- TODO: use this signal as the final data memory data input

	-- Required instruction memory signals
	SIGNAL s_IMemAddr : std_logic_vector(N - 1 DOWNTO 0); -- Do not assign this signal, assign to s_NextInstAddr instead
	SIGNAL s_NextInstAddr : std_logic_vector(N - 1 DOWNTO 0); -- TODO: use this signal as your intended final instruction memory address input.
	SIGNAL s_Inst : std_logic_vector(N - 1 DOWNTO 0); -- TODO: use this signal as the instruction signal 

	-- Required halt signal -- for simulation
	SIGNAL v0 : std_logic_vector(N - 1 DOWNTO 0); -- TODO: should be assigned to the output of register 2, used to implement the halt SYSCALL
	SIGNAL s_Halt : std_logic; -- TODO: this signal indicates to the simulation that intended program execution has completed. This case happens when the syscall instruction is observed and the V0 register is at 0x0000000A. This signal is active high and should only be asserted after the last register and memory writes before the syscall are guaranteed to be completed.

	COMPONENT mem IS
		GENERIC (
			ADDR_WIDTH : INTEGER;
			DATA_WIDTH : INTEGER);
		PORT (
			clk : IN std_logic;
			addr : IN std_logic_vector((ADDR_WIDTH - 1) DOWNTO 0);
			data : IN std_logic_vector((DATA_WIDTH - 1) DOWNTO 0);
			we : IN std_logic := '1';
			q : OUT std_logic_vector((DATA_WIDTH - 1) DOWNTO 0));
	END COMPONENT;

	COMPONENT registerfile IS
		PORT (
			i_CLK : IN std_logic; -- clock
			i_RST : IN std_logic; -- reset
			i_rw : IN std_logic; -- register write
			i_rs : IN std_logic_vector(4 DOWNTO 0); -- read address 1
			i_rt : IN std_logic_vector(4 DOWNTO 0); -- read address 2
			i_rd : IN std_logic_vector(4 DOWNTO 0); -- write address
			i_wd : IN std_logic_vector(31 DOWNTO 0); -- write data
			o_rd1 : OUT std_logic_vector(31 DOWNTO 0); -- read data 1
			o_rd2 : OUT std_logic_vector(31 DOWNTO 0)); -- read data 2
	END COMPONENT;

	COMPONENT mux21_n_st
		GENERIC (N : INTEGER);
		PORT (
			i_A : IN std_logic_vector(N - 1 DOWNTO 0);
			i_B : IN std_logic_vector(N - 1 DOWNTO 0);
			i_S : IN std_logic;
			o_F : OUT std_logic_vector(N - 1 DOWNTO 0));
	END COMPONENT;

	COMPONENT extender
		GENERIC (N : INTEGER);
		PORT (
			i_A : IN std_logic_vector(N - 1 DOWNTO 0); -- input vector
			i_B : IN std_logic; -- sign control bit
			o_Z : OUT std_logic_vector(31 DOWNTO 0)); -- output extension
	END COMPONENT;

	COMPONENT control_logic
		PORT (
			opcode : IN std_logic_vector(5 DOWNTO 0);
			func : IN std_logic_vector(5 DOWNTO 0);
			regDst : OUT std_logic;
			jump : OUT std_logic;
			jr : OUT std_logic;
			beq : OUT std_logic;
			bne : OUT std_logic;
			memToReg : OUT std_logic;
			ALUControl : OUT std_logic_vector(3 DOWNTO 0);
			memWrite : OUT std_logic;
			ALUSrc : OUT std_logic;
			regWrite : OUT std_logic;
			i_unsigned : OUT std_logic;
			jal : OUT std_logic;
			lui : OUT std_logic;
			shamt : OUT std_logic
		);
	END COMPONENT;

	COMPONENT reg
		GENERIC (N : INTEGER); -- Size of the register
		PORT (
			D : IN std_logic_vector(N - 1 DOWNTO 0); -- Data input
			Q : OUT std_logic_vector(N - 1 DOWNTO 0); -- Data output
			WE : IN std_logic; -- Write enableenable
			reset : IN std_logic; -- The clock signal
			clock : IN std_logic); -- The reset signal
	END COMPONENT;

	COMPONENT ALU32
		PORT (
			i_A : IN std_logic_vector(N - 1 DOWNTO 0);
			i_B : IN std_logic_vector(N - 1 DOWNTO 0);
			i_sel : IN std_logic_vector(3 DOWNTO 0); -- operation select
			i_unsigned : IN std_logic; -- determines if math is signed/unsigned
			i_shiftamount : IN std_logic_vector(4 DOWNTO 0); --shift amount
			o_Cout : OUT std_logic; -- carry out
			o_result : OUT std_logic_vector(N - 1 DOWNTO 0); -- result F
			o_overflow : OUT std_logic;
			o_Zero : OUT std_logic);

	END COMPONENT;

	-- Control flow signals 
	SIGNAL s_ALUSrc, s_iUnsigned, s_shamt, s_memToReg, s_regDst, s_jump, s_bne, s_beq, s_jal, s_jr, s_lui : std_logic;

	-- Other signals
	SIGNAL s_mux2, s_mux3, s_mux4, s_shiftedSignExtend, s_iMux8, s_iPC, s_oExtend, s_oRs, i_mux3, s_mux5, s_pcPlusFour, s_iMux6, s_mux7, s_mux8, s_branchAddr : std_logic_vector(N - 1 DOWNTO 0);
	SIGNAL s_Cout, s_overflow, s_zero, s_branch, s_addi : std_logic;
	SIGNAL s_ALUControl : std_logic_vector(3 DOWNTO 0);
	SIGNAL s_mux0, s_shiftAmount : std_logic_vector(4 DOWNTO 0);

BEGIN

	i_mux3 <= "000000000000000000000000000" & s_Inst(10 DOWNTO 6);

	-- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
	WITH iInstLd SELECT
		s_IMemAddr <= s_NextInstAddr WHEN '0',
		iInstAddr WHEN OTHERS;
	IMem : mem
	GENERIC MAP(
		ADDR_WIDTH => 10,
		DATA_WIDTH => N)
	PORT MAP(
		clk => iCLK,
		addr => s_IMemAddr(11 DOWNTO 2),
		data => iInstExt,
		we => iInstLd,
		q => s_Inst);

	DMem : mem
	GENERIC MAP(
		ADDR_WIDTH => 10,
		DATA_WIDTH => N)
	PORT MAP(
		clk => iCLK,
		addr => s_DMemAddr(11 DOWNTO 2),
		data => s_DMemData,
		we => s_DMemWr,
		q => s_DMemOut);

	s_Halt <= '1' WHEN (s_Inst(31 DOWNTO 26) = "000000") AND (s_Inst(5 DOWNTO 0) = "001100") AND (v0 = "00000000000000000000000000001010") ELSE
		'0';

	mux0 : mux21_n_st
	GENERIC MAP(N => 5)
	PORT MAP(
		i_A => s_Inst(20 DOWNTO 16),
		i_B => s_Inst(15 DOWNTO 11),
		i_S => s_regDst,
		o_F => s_mux0
	);

	mux1 : mux21_n_st
	GENERIC MAP(N => 5)
	PORT MAP(
		i_A => s_mux0,
		i_B => "11111",
		i_S => s_jal,
		o_F => s_RegWrAddr
	);

	regFile : registerfile
	PORT MAP(
		i_CLK => iCLK,
		i_RST => iRST,
		i_rw => s_RegWr,
		i_rs => s_Inst(25 DOWNTO 21),
		i_rt => s_Inst(20 DOWNTO 16),
		i_rd => s_RegWrAddr,
		i_wd => s_RegWrData,
		o_rd1 => s_oRs,
		o_rd2 => s_DMemData
	);

	signExtend : extender
	GENERIC MAP(N => 16)
	PORT MAP(
		i_A => s_Inst(15 DOWNTO 0),
		i_B => s_addi,
		o_Z => s_oExtend
	);

	control : control_logic
	PORT MAP(
		opcode => s_Inst(31 DOWNTO 26),
		func => s_Inst(5 DOWNTO 0),
		regDst => s_regDst,
		jump => s_jump,
		jr => s_jr,
		beq => s_beq,
		bne => s_bne,
		memToReg => s_memToReg,
		ALUControl => s_ALUControl,
		memWrite => s_DMemWr,
		ALUSrc => s_ALUSrc,
		regWrite => s_RegWr,
		i_unsigned => s_iUnsigned,
		jal => s_jal,
		lui => s_lui,
		shamt => s_shamt
	);

	mux2 : mux21_n_st
	GENERIC MAP(N => N)
	PORT MAP(
		i_A => s_DMemData,
		i_B => s_oExtend,
		i_S => s_ALUSrc,
		o_F => s_mux2
	);

	mux3 : mux21_n_st
	GENERIC MAP(N => N)
	PORT MAP(
		i_A => s_oRs,
		i_B => i_mux3,
		i_S => s_shamt,
		o_F => s_mux3
	);

	ALU : ALU32
	PORT MAP(
		i_A => s_oRs,
		i_B => s_mux2,
		i_sel => s_ALUControl,
		i_unsigned => s_iUnsigned,
		i_shiftamount => s_shiftAmount,
		o_Cout => s_Cout,
		o_result => s_DMemAddr,
		o_overflow => s_overflow,
		o_Zero => s_zero
	);

	mux4 : mux21_n_st
	GENERIC MAP(N => N)
	PORT MAP(
		i_A => s_DMemAddr,
		i_B => s_DMemOut,
		i_S => s_memToReg,
		o_F => s_mux4
	);

	mux5 : mux21_n_st
	GENERIC MAP(N => N)
	PORT MAP(
		i_A => s_mux4,
		i_B => s_pcPlusFour,
		i_S => s_jal,
		o_F => s_mux5
	);

	mux6 : mux21_n_st
	GENERIC MAP(N => N)
	PORT MAP(
		i_A => s_mux5,
		i_B => s_iMux6,
		i_S => s_lui,
		o_F => s_RegWrData
	);
	mux7 : mux21_n_st
	GENERIC MAP(N => N)
	PORT MAP(
		i_A => s_pcPlusFour,
		i_B => s_branchAddr,
		i_S => s_branch,
		o_F => s_mux7
	);

	mux8 : mux21_n_st
	GENERIC MAP(N => N)
	PORT MAP(
		i_A => s_mux7,
		i_B => s_iMux8,
		i_S => s_jump,
		o_F => s_mux8
	);

	mux9 : mux21_n_st
	GENERIC MAP(N => N)
	PORT MAP(
		i_A => s_mux8,
		i_B => s_oRs,
		i_S => s_jr,
		o_F => s_iPC
	);

	pc : reg
	GENERIC MAP(N => N)
	PORT MAP(
		D => s_iPC,
		Q => s_NextInstAddr,
		WE => '1',
		reset => iRST,
		clock => iCLK);

	ExitReg : reg
	GENERIC MAP(N => N)
	PORT MAP(
		D => s_RegWrData,
		WE => '1',
		clock => iCLK,
		reset => '0',
		Q => v0);

	--Since the output of mux3 is 32 bits, we need this condition to handle the shift amount
	s_shiftAmount <= s_mux3(4 DOWNTO 0);

	oALUOut <= s_DMemAddr;

	-- for addi, ori, xori instructions, extender needs to sign extend
	s_addi <= '0' WHEN (s_Inst(31 DOWNTO 26) = "001100") OR (s_Inst(31 DOWNTO 26) = "001101") OR (s_Inst(31 DOWNTO 26) = "001110") ELSE
		'1';
	--PC+4
	s_pcPlusFour <= std_logic_vector(to_unsigned(to_integer(unsigned(s_NextInstAddr)) + 4, 32));

	--Branch
	s_branch <= (s_zero AND s_beq) OR ((NOT s_zero) AND s_bne);

	--Sign extend shifted left by 2
	s_shiftedSignExtend <= s_oExtend(29 DOWNTO 0) & "00";

	--Address of next instr when branching
	s_branchAddr <= s_pcPlusFour + s_shiftedSignExtend;

	--PC+4[31..28] & s_Inst(26 downto 0) shifted left by 2
	s_iMux8 <= s_pcPlusFour(31 DOWNTO 28) & s_Inst(25 DOWNTO 0) & "00";

	--i_B for mux6
	s_iMux6 <= s_Inst(15 DOWNTO 0) & "0000000000000000";
END structure;