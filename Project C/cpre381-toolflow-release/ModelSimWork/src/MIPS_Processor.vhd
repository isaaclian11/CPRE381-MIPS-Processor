-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------
-- SoftwarerPipeline.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Software scheduled pipeline for Project C phase 1
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
			o_rd2 : OUT std_logic_vector(31 DOWNTO 0);
			v0 : OUT std_logic_vector(31 DOWNTO 0)); -- read data 2
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
			stall : IN std_logic; -- Write enableenable
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
	
	COMPONENT IFIDreg IS
    GENERIC (N : INTEGER := 32);
    PORT (
      flush : IN std_logic;
      stall : IN std_logic;
      instr : IN std_logic_vector(N - 1 DOWNTO 0); -- instruction data
      pcp4 : IN std_logic_vector(N - 1 DOWNTO 0); -- PC+4
      clock : IN std_logic;
	  reset : IN std_logic;
      out_pcp4 : OUT std_logic_vector(N - 1 DOWNTO 0);
      out_instr : OUT std_logic_vector(N - 1 DOWNTO 0));
  END COMPONENT;

  COMPONENT IDEXreg IS
    GENERIC (N : INTEGER := 32);
    PORT (
     stall : IN std_logic;
	 flush : IN std_logic;
    readdata1 : IN std_logic_vector(N - 1 DOWNTO 0); -- register read data 1
    readdata2 : IN std_logic_vector(N - 1 DOWNTO 0); -- register read data 2
    pcp4 : IN std_logic_vector(N - 1 DOWNTO 0); -- PC+4
    sign_ext : IN std_logic_vector(N - 1 DOWNTO 0); -- output of sign extender
    instr: IN std_logic_vector(N-1 DOWNTO 0);
    shamt : IN std_logic_vector(N-1 downto 0);
    clock : IN std_logic;
    ctl_RegWrite : IN std_logic; -- propagate to WB
    ctl_MemtoReg : IN std_logic; -- propagate to WB
    ctl_MemWrite : IN std_logic; -- propagate to MEM
    ctl_ALUOp : IN std_logic_vector(3 DOWNTO 0); -- propagate to EX
    ctl_ALUSrc : IN std_logic; -- propagate to EX
    ctl_RegDst : IN std_logic; -- propagate to EX
    ctl_jal : IN std_logic;
    ctl_lui : IN std_logic;
	ctl_unsigned: IN std_logic;
	ctl_shamt : IN std_logic;
	reset : IN std_logic;
    out_RegWrite : OUT std_logic;
    out_MemtoReg : OUT std_logic;
    out_MemWrite : OUT std_logic;
    out_ALUOp : OUT std_logic_vector(3 DOWNTO 0);
    out_ALUSrc : OUT std_logic;
    out_RegDst : OUT std_logic;
    out_jal : OUT std_logic;
    out_lui : OUT std_logic;
	out_shamtCtl : OUT std_logic;
    out_readdata1 : OUT std_logic_vector(N - 1 DOWNTO 0);
    out_readdata2 : OUT std_logic_vector(N - 1 DOWNTO 0);
    out_shamt : OUT std_logic_vector(N-1 DOWNTO 0);
	out_unsigned: OUT std_logic;
    out_inst : OUT std_logic_vector(N-1 DOWNTO 0);
    out_sign_ext : OUT std_logic_vector(N - 1 DOWNTO 0);
    out_pcp4 : OUT std_logic_vector(N - 1 DOWNTO 0);
	out_opcode : OUT std_logic_vector(5 DOWNTO 0));
  END COMPONENT;

  COMPONENT EXMEMreg IS
    GENERIC (N : INTEGER := 32);
    PORT (
		 stall : IN std_logic;
    clock : IN std_logic;
	instr : IN std_logic_vector(N-1 DOWNTO 0);
	pcp4 : IN std_logic_vector(N-1 DOWNTO 0);
    ctl_RegWrite : IN std_logic; -- propagate to WB
    ctl_MemtoReg : IN std_logic; -- propagate to WB
    ctl_MemWrite : IN std_logic; -- propagate to MEM
    alu_result : IN std_logic_vector(N - 1 DOWNTO 0); -- 32bit result of alu operation
    readdata2 : IN std_logic_vector(N - 1 DOWNTO 0); -- register read data 2
    writereg : IN std_logic_vector(4 DOWNTO 0); -- output of RegDst mux
	ctl_jal : IN std_logic;
    ctl_lui : IN std_logic;
	reset : IN std_logic;
    out_RegWrite : OUT std_logic;
    out_MemtoReg : OUT std_logic;
    out_MemWrite : OUT std_logic;
    out_aluresult : OUT std_logic_vector(N - 1 DOWNTO 0);
    out_writedata : OUT std_logic_vector(N - 1 DOWNTO 0);
    out_writereg : OUT std_logic_vector(4 DOWNTO 0);
	out_pcp4 : OUT std_logic_vector(N-1 DOWNTO 0);
	out_jal : OUT std_logic;
    out_lui : OUT std_logic;
	out_instr : OUT std_logic_vector(N-1 DOWNTO 0));
  END COMPONENT;

  COMPONENT MEMWBreg IS
    GENERIC (N : INTEGER := 32);
    PORT (
       stall : IN std_logic;
    clock : IN std_logic;
	instr : IN std_logic_vector(N-1 DOWNTO 0);
    ctl_RegWrite : IN std_logic; -- propagate to WB
    ctl_MemtoReg : IN std_logic; -- propagate to WB
    alu_result : IN std_logic_vector(N - 1 DOWNTO 0); -- 32bit result of alu operation
    memreaddata : IN std_logic_vector(N - 1 DOWNTO 0); -- read data from memory module
    writereg : IN std_logic_vector(4 DOWNTO 0); -- output of RegDst mux
	pcp4 : IN std_logic_vector(N-1 DOWNTO 0);
	ctl_jal : IN std_logic;
    ctl_lui : IN std_logic;
	reset : IN std_logic;
    out_RegWrite : OUT std_logic;
    out_MemtoReg : OUT std_logic;
    out_memreaddata : OUT std_logic_vector(N - 1 DOWNTO 0);
    out_aluresult : OUT std_logic_vector(N - 1 DOWNTO 0);
    out_writereg : OUT std_logic_vector(4 DOWNTO 0);
	out_jal : OUT std_logic;
    out_lui : OUT std_logic;
	out_pcp4 : OUT std_logic_vector(N-1 DOWNTO 0);
	out_instr : OUT std_logic_vector(N-1 DOWNTO 0));
  END COMPONENT;
  
  COMPONENT hazard_detection IS
  port(
	instr_idex: in std_logic_vector(31 downto 0); --Used to check lw and rt_idex
	instr_ifid: in std_logic_vector(31 downto 0); --Used for rs_ifid and rt_ifid
	branch : in std_logic; --Branch signal from the control unit
	branchTaken : in std_logic;
	jump : in std_logic;
	jr : in std_logic;
	stall : out std_logic;
	flush_ifid : out std_logic;
	flush_idex : out std_logic
	);
  END COMPONENT;
  
  COMPONENT forwarding_unit IS
  port(
	instr_idex : in std_logic_vector(31 downto 0);
	instr_ifid : in std_logic_vector(31 downto 0);
	rd_exmem : in std_logic_vector(4 downto 0);
	rd_memwb : in std_logic_vector(4 downto 0);
	regwrite_exmem : in std_logic;
	regwrite_memwb : in std_logic;
	forwardA : out std_logic_vector(1 downto 0);
	forwardB : out std_logic_vector(1 downto 0);
	forwardC : out std_logic;
	forwardD : out std_logic_vector(1 downto 0);
	forwardE : out std_logic_vector(1 downto 0)
	);
  END COMPONENT;
  
  COMPONENT control_mux is
  PORT (
		i_regDst : IN std_logic;
		i_jump : IN std_logic;
		i_jr : IN std_logic;
		i_beq : IN std_logic;
		i_bne : IN std_logic;
		i_memToReg : IN std_logic;
		i_ALUControl : IN std_logic_vector(3 DOWNTO 0);
		i_memWrite : IN std_logic;
		i_ALUSrc : IN std_logic;
		i_regWrite : IN std_logic;
		i_i_unsigned : IN std_logic;
		i_jal : IN std_logic;
		i_lui : IN std_logic;
		i_shamt : IN std_logic;
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
		shamt : OUT std_logic;
		sel : IN std_logic
	);
END COMPONENT;

	-- Control flow signals 
	SIGNAL s_ALUSrc, s_iUnsigned, s_shamt, s_memToReg, s_regDst, s_jump, s_bne, s_beq, s_jal, s_jr, s_lui : std_logic;

	-- Other signals
	SIGNAL s_mux2, s_mux3, s_mux4, s_shiftedSignExtend, s_iMux8, s_iPC, s_oExtend, s_oRs, i_mux3, s_readdata1,
	s_mux5, s_pcPlusFour, s_iMux6, s_mux7, s_mux8, s_branchAddr, s_rtout, 
	s_RsEqualsRt, s_RsNotEqualsRt, s_ALUOut, s_memDataForward, s_memDataForwardEXMEM, s_rtoForward, s_orsForward, s_ortForward : std_logic_vector(N - 1 DOWNTO 0);
	SIGNAL s_mux0, s_shiftAmount, s_regAddr : std_logic_vector(4 DOWNTO 0);
	SIGNAL s_ALUControl, s_stall, ctl_ALUControl : std_logic_vector(3 DOWNTO 0);
	SIGNAL s_Cout, s_overflow, s_zero, s_branch, s_addi, s_zeroSig, s_DMemWrite, s_RegWrite, s_hazardBranch, ctl_regDst, ctl_jump, ctl_jr, ctl_beq, ctl_bne, ctl_memToReg, ctl_memWrite, ctl_ALUSrc, ctl_regWrite, ctl_jal, ctl_lui, ctl_shamt, ctl_i_unsigned, s_nop : std_logic;
	
	-- added pipeline signals
	SIGNAL pcp4_ifid, instr_ifid, shamt_idex, readdata1_idex, memreaddata_memwb, 
	aluresult_memwb, inst_idex, instr_exmem, pcp4_exmem, instr_memwb, pcp4_memwb, readdata2_idex, sign_ext_idex, pcp4_idex, pcp4BeforeID,
			ALU_iA, ALU_iB: std_logic_vector(N - 1 DOWNTO 0);
	SIGNAL writereg_exmem : std_logic_vector(4 DOWNTO 0);
	SIGNAL aluop_idex : std_logic_vector(3 DOWNTO 0);
	SIGNAL s_flushifid, s_flushidex, regwrite_idex, memtoreg_idex, memwrite_idex, alusrc_idex, regdst_idex, 
			regwrite_exmem, memtoreg_exmem, memtoreg_memwb, jal_idex, lui_idex, unsigned_idex, 
			shamtCtl_idex, jal_exmem, lui_exmem, jal_memwb, lui_memwb, forwardC, s_bothBranches, s_flushBranch, s_bothJumps, s_branchJump : std_logic;
	SIGNAL forwardA, forwardB, forwardD, forwardE : std_logic_vector(1 downto 0);
			
	begin
	-- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
	WITH iInstLd SELECT
		s_IMemAddr <= s_NextInstAddr WHEN '0',
		iInstAddr WHEN OTHERS;
		
	s_stall <= "0000";
	
		
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
		
	pc : reg
	GENERIC MAP(N => N)
	PORT MAP(
		D => pcp4BeforeID,
		Q => s_NextInstAddr,
		stall => s_nop,
		reset => iRST,
		clock => iCLK);
	
	ifid : IFIDreg
	PORT MAP(
	  flush => s_flushifid,
	  stall => s_nop,
	  instr => s_inst,
	  pcp4 => s_pcPlusFour,
	  clock => iCLK,
	  reset => iRST,
	  out_pcp4 => pcp4_ifid,
	  out_instr => instr_ifid
	);
	
	regFile : registerfile
	PORT MAP(
		i_CLK => iCLK,
		i_RST => iRST,
		i_rw => s_RegWr,
		i_rs => instr_ifid(25 DOWNTO 21),
		i_rt => instr_ifid(20 DOWNTO 16),
		i_rd => s_RegWrAddr,
		i_wd => s_RegWrData,
		o_rd1 => s_oRs,
		o_rd2 => s_rtout,
		v0 => v0
	);
	
	signExtend : extender
	GENERIC MAP(N => 16)
	PORT MAP(
		i_A => instr_ifid(15 DOWNTO 0),
		i_B => s_addi,
		o_Z => s_oExtend
	);

	control : control_logic
	PORT MAP(
		opcode => instr_ifid(31 DOWNTO 26),
		func => instr_ifid(5 DOWNTO 0),
		regDst => ctl_regDst,
		jump => ctl_jump,
		jr => ctl_jr,
		beq => ctl_beq,
		bne => ctl_bne,
		memToReg => ctl_memToReg,
		ALUControl => ctl_ALUControl,
		memWrite => ctl_memWrite,
		ALUSrc => ctl_ALUSrc,
		regWrite => ctl_regWrite,
		i_unsigned => ctl_i_unsigned,
		jal => ctl_jal,
		lui => ctl_lui,
		shamt => ctl_shamt
	);
	
	controlmux : control_mux
	PORT MAP(
		i_regDst => ctl_regDst,
		i_jump => ctl_jump,
		i_jr => ctl_jr,
		i_beq => ctl_beq,
		i_bne => ctl_bne,
		i_memToReg => ctl_memToReg, 
		i_ALUControl => ctl_ALUControl, 
		i_memWrite => ctl_memWrite,
		i_ALUSrc => ctl_ALUSrc,
		i_regWrite => ctl_regWrite,
		i_i_unsigned => ctl_i_unsigned,
		i_jal => ctl_jal,
		i_lui => ctl_lui,
		i_shamt => ctl_shamt,
		regDst => s_regDst,
		jump => s_jump,
		jr => s_jr,
		beq => s_beq,
		bne => s_bne,
		memToReg => s_memToReg,
		ALUControl => s_ALUControl,
		memWrite => s_DMemWrite,
		ALUSrc => s_ALUSrc,
		regWrite => s_RegWrite,
		i_unsigned => s_iUnsigned,
		jal => s_jal,
		lui => s_lui,
		shamt => s_shamt,
		sel => '0'
	);
	
	mux7 : mux21_n_st
	GENERIC MAP(N => N)
	PORT MAP(
		i_A => pcp4_ifid,
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
		i_B => s_orsForward,
		i_S => s_jr,
		o_F => s_iPC
	);
	
	idex : IDEXreg
	PORT MAP(
	  stall => '0',
	  flush => s_flushidex,
	  readdata1 => s_orsForward, -- pre-existing rd1 signal from registerfile
	  readdata2 => s_ortForward, -- pre-existing rd2 signal from registerfile
	  pcp4 => pcp4_ifid, -- propagated pcp4 from ifid
      sign_ext => s_oExtend, -- pre-existing output from extender
      instr => instr_ifid,
	  shamt => i_mux3,
      clock => iCLK,
      ctl_RegWrite => s_RegWrite, -- control signals from control unit
      ctl_MemtoReg => s_memToReg,
      ctl_MemWrite => s_DMemWrite,
      ctl_ALUOp => s_ALUControl,
      ctl_ALUSrc => s_ALUSrc,
	  ctl_RegDst => s_regDst,
	  ctl_lui => s_lui,
	  ctl_jal => s_jal,
	  ctl_shamt => s_shamt,
	  ctl_unsigned => s_iUnsigned,
      out_RegWrite => regwrite_idex,
      out_MemtoReg => memtoreg_idex,
      out_MemWrite => memwrite_idex,
      out_ALUOp => aluop_idex,
      out_ALUSrc => alusrc_idex,
	  out_RegDst => regdst_idex,
	  out_unsigned => unsigned_idex,
	  out_jal => jal_idex,
	  out_lui => lui_idex,
	  reset => iRST,
	  out_shamtCtl => shamtCtl_idex,
      out_readdata1 => readdata1_idex,
      out_readdata2 => readdata2_idex,
      out_inst => inst_idex,
	  out_shamt => shamt_idex,
      out_sign_ext => sign_ext_idex,
      out_pcp4 => pcp4_idex
	);
	
	mux2 : mux21_n_st
	GENERIC MAP(N => N)
	PORT MAP(
		i_A => s_mux2,
		i_B => sign_ext_idex,
		i_S => alusrc_idex,
		o_F => ALU_iB
	);
	
	with forwardA select
		ALU_iA 	<= readdata1_idex when "00",
				s_RegWrData when "01",
				s_DMemAddr when others;
	
	with forwardB select
		s_mux2 	<= readdata2_idex when "00",
				s_RegWrData when "01",
				s_DMemAddr when others;
	
		
	
	mux3 : mux21_n_st
	GENERIC MAP(N => N)
	PORT MAP(
		i_A => ALU_iA,
		i_B => shamt_idex,
		i_S => shamtCtl_idex,
		o_F => s_mux3
	);
	
	ALU : ALU32
	PORT MAP(
		i_A => ALU_iA,
		i_B => ALU_iB,
		i_sel => aluop_idex,
		i_unsigned => unsigned_idex,
		i_shiftamount => s_shiftAmount,
		o_Cout => s_Cout,
		o_result => s_ALUOut,
		o_overflow => s_overflow,
		o_Zero => s_zero
	);
	
	mux0 : mux21_n_st
	GENERIC MAP(N => 5)
	PORT MAP(
		i_A => inst_idex(20 DOWNTO 16),
		i_B => inst_idex(15 DOWNTO 11),
		i_S => regdst_idex,
		o_F => s_mux0
	);
	
	mux1 : mux21_n_st
	GENERIC MAP(N => 5)
	PORT MAP(
		i_A => s_mux0,
		i_B => "11111",
		i_S => jal_idex,
		o_F => s_regAddr
	);
	
	exmem : EXMEMreg
	PORT MAP(
	  stall => '0',
      clock => iCLK,
	  instr => inst_idex,
	  writereg => s_regAddr,
	  pcp4 => pcp4_idex,
      ctl_RegWrite => regwrite_idex,
      ctl_MemtoReg => memtoreg_idex,
      ctl_MemWrite => memwrite_idex,
	  ctl_jal => jal_idex,
	  ctl_lui => lui_idex,
      alu_result => s_ALUOut, -- pre-existing output from ALU in EX stage
      readdata2 => s_rtoForward,
      out_RegWrite => regwrite_exmem,
      out_MemtoReg => memtoreg_exmem,
      out_MemWrite => s_DMemWr,
      out_aluresult => s_DMemAddr,
      out_writedata => s_DMemData,
      out_writereg => writereg_exmem,
	  out_instr => instr_exmem,
	  reset => iRST,
	  out_pcp4 => pcp4_exmem,
	  out_jal => jal_exmem,
	  out_lui => lui_exmem
	);
	
	
	with forwardB select
	s_memDataForward <= s_DMemAddr when "10",
					readdata2_idex when others;
					
	with forwardC select 
	s_rtoForward <= s_RegWrData when '1',
					s_memDataForward when others;
					
	with forwardD select
	s_orsForward <= s_RegWrData when "10",
					s_DMemAddr when "01",
					s_oRs when others;
	
	with forwardE select
	s_ortForward <= s_RegWrData when "10",
					s_DMemAddr when "01",
					s_rtout when others;
					
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
		
	memwb : MEMWBreg
	PORT MAP(
	  stall => '0',
      clock => iCLK,
	  instr => instr_exmem,
	  ctl_RegWrite => regwrite_exmem,
      ctl_MemtoReg => memtoreg_exmem,
	  alu_result => s_DMemAddr,
	  ctl_jal => jal_exmem,
	  ctl_lui => lui_exmem,
	  pcp4 => pcp4_exmem,
	  memreaddata => s_DMemOut, -- pre-existing read data from memory module in MEM stage
	  writereg => writereg_exmem,
	  out_RegWrite => s_RegWr,
	  out_MemToReg => memtoreg_memwb,
	  out_memreaddata => memreaddata_memwb,
	  out_aluresult => aluresult_memwb,
	  out_writereg => s_RegWrAddr,
	  out_instr => instr_memwb,
	  out_pcp4 => pcp4_memwb,
	  out_jal => jal_memwb,
	  reset => iRST,
	  out_lui => lui_memwb
	);
	
	
	mux4 : mux21_n_st
	GENERIC MAP(N => N)
	PORT MAP(
		i_A => aluresult_memwb,
		i_B => memreaddata_memwb,
		i_S => memtoreg_memwb,
		o_F => s_mux4
	);
	
	mux5 : mux21_n_st
	GENERIC MAP(N => N)
	PORT MAP(
		i_A => s_mux4,
		i_B => pcp4_memwb,
		i_S => jal_memwb,
		o_F => s_mux5
	);
	
	mux6 : mux21_n_st
	GENERIC MAP(N => N)
	PORT MAP(
		i_A => s_mux5,
		i_B => s_iMux6,
		i_S => lui_memwb,
		o_F => s_RegWrData
	);
	
	forward: forwarding_unit
	PORT MAP(
		instr_idex => inst_idex,
		instr_ifid => instr_ifid,
		rd_exmem => writereg_exmem,
		rd_memwb => s_RegWrAddr,
		regwrite_exmem => regwrite_exmem,
		regwrite_memwb => s_RegWr,
		forwardA => forwardA,
		forwardB => forwardB,
		forwardC => forwardC,
		forwardD => forwardD,
		forwardE => forwardE
	);
	
	hazards : hazard_detection
	port MAP(
		instr_idex => inst_idex,
		instr_ifid => instr_ifid,
		branch => s_bothBranches,
		branchTaken => s_branch,
		jr => s_jr,
		jump => s_jump,
		stall => s_nop,
		flush_ifid => s_flushifid,
		flush_idex => s_flushidex
	);
	
	s_pcPlusFour <= std_logic_vector(to_unsigned(to_integer(unsigned(s_NextInstAddr)) + 4, 32));
		
	-- for addi, ori, xori instructions, extender needs to sign extend
	s_addi <= '0' WHEN (instr_ifid(31 DOWNTO 26) = "001100") OR (instr_ifid(31 DOWNTO 26) = "001101") OR (instr_ifid(31 DOWNTO 26) = "001110") ELSE '1';
	
	--sll2 sign extended
	s_shiftedSignExtend <= s_oExtend(29 DOWNTO 0) & "00";
	
	s_RsEqualsRt <= s_oRs - s_rtout;
	
	Branch : ALU32
	PORT MAP(
		i_A => s_orsForward,
		i_B => s_ortForward,
		i_sel => "0001",
		i_unsigned => s_iUnsigned,
		i_shiftamount => "00000",
		o_overflow => s_overflow,
		o_Zero => s_zeroSig
	);
	
	--This will be used in the mux that goes into the PC Reg as a select input. 
	with s_flushifid select
	s_hazardBranch <= '0' when '1',
				s_bothBranches when others;
		
	
	s_flushBranch <= (s_jr OR s_jump OR s_branch);


	--Output of mux that goes into PC reg
	pcp4BeforeID <= s_pcPlusFour WHEN (s_flushBranch = '0') else s_iPC;
	
	--Determines whether to branch or not to branch
	s_branch <= ((s_zeroSig AND s_beq) OR ((NOT s_zeroSig) AND s_bne));
	
	s_bothBranches <= (s_beq or s_bne);
	
	--Branch address
	s_branchAddr <= pcp4_ifid + s_shiftedSignExtend;
	
	--shift amount that goes into mux that goes into the ALU
	i_mux3 <= "000000000000000000000000000" & instr_ifid(10 DOWNTO 6);
	
	--Since the output of mux3 is 32 bits, we need this condition to handle the shift amount
	s_shiftAmount <= s_mux3(4 DOWNTO 0);

	s_Halt <= '1' WHEN (instr_memwb(31 DOWNTO 26) = "000000") AND (instr_memwb(5 DOWNTO 0) = "001100") AND (v0 = "00000000000000000000000000001010") ELSE
		'0';
		
	--PC+4[31..28] + instr_ifid(26 downto 0) shifted left by 2
	s_iMux8 <= pcp4_ifid(31 DOWNTO 28) & instr_ifid(25 DOWNTO 0) & "00";
	
	--i_B for mux 6
	s_iMux6 <= instr_memwb(15 DOWNTO 0) & "0000000000000000";
	
	oALUOut <= s_ALUOut;

end structure;