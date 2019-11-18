-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------
-- tb_pipeline_registers.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: testbench for new pipeline registers; IF/ID, ID/EX, etc.
-------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY tb_pipeline_registers IS
  GENERIC (gCLK_HPER : TIME := 50 ns);
END tb_pipeline_registers;

ARCHITECTURE behavior OF tb_pipeline_registers IS

  -- Calculate the clock period as twice the half-period
  CONSTANT cCLK_PER : TIME := gCLK_HPER * 2;

  COMPONENT IFIDreg IS
    GENERIC (N : INTEGER := 32);
    PORT (
      flush : IN std_logic;
      stall : IN std_logic;
      instr : IN std_logic_vector(N - 1 DOWNTO 0); -- instruction data
      pcp4 : IN std_logic_vector(N - 1 DOWNTO 0); -- PC+4
      clock : IN std_logic;
      out_pcp4 : OUT std_logic_vector(N - 1 DOWNTO 0);
      out_instr : OUT std_logic_vector(N - 1 DOWNTO 0));
  END COMPONENT;

  COMPONENT IDEXreg IS
    GENERIC (N : INTEGER := 32);
    PORT (
      stall : IN std_logic;
      readdata1 : IN std_logic_vector(N - 1 DOWNTO 0); -- register read data 1
      readdata2 : IN std_logic_vector(N - 1 DOWNTO 0); -- register read data 2
      pcp4 : IN std_logic_vector(N - 1 DOWNTO 0); -- PC+4
      sign_ext : IN std_logic_vector(N - 1 DOWNTO 0); -- output of sign extender
      rt : IN std_logic_vector(4 DOWNTO 0); -- instruction[20-16], Rt
      rd : IN std_logic_vector(4 DOWNTO 0); -- instruction[15-11], Rd
      clock : IN std_logic;
      ctl_RegWrite : IN std_logic; -- propagate to WB
      ctl_MemtoReg : IN std_logic; -- propagate to WB
      ctl_MemWrite : IN std_logic; -- propagate to MEM
      ctl_ALUOp : IN std_logic_vector(3 DOWNTO 0); -- propagate to EX
      ctl_ALUSrc : IN std_logic; -- propagate to EX
      ctl_RegDst : IN std_logic; -- propagate to EX
      out_RegWrite : OUT std_logic;
      out_MemtoReg : OUT std_logic;
      out_MemWrite : OUT std_logic;
      out_ALUOp : OUT std_logic_vector(3 DOWNTO 0);
      out_ALUSrc : OUT std_logic;
      out_RegDst : OUT std_logic;
      out_readdata1 : OUT std_logic_vector(N - 1 DOWNTO 0);
      out_readdata2 : OUT std_logic_vector(N - 1 DOWNTO 0);
      out_rt : OUT std_logic_vector(4 DOWNTO 0);
      out_rd : OUT std_logic_vector(4 DOWNTO 0);
      out_sign_ext : OUT std_logic_vector(N - 1 DOWNTO 0);
      out_pcp4 : OUT std_logic_vector(N - 1 DOWNTO 0));
  END COMPONENT;

  COMPONENT EXMEMreg IS
    GENERIC (N : INTEGER := 32);
    PORT (
      stall : IN std_logic;
      clock : IN std_logic;
      ctl_RegWrite : IN std_logic; -- propagate to WB
      ctl_MemtoReg : IN std_logic; -- propagate to WB
      ctl_MemWrite : IN std_logic; -- propagate to MEM
      alu_result : IN std_logic_vector(N - 1 DOWNTO 0); -- 32bit result of alu operation
      readdata2 : IN std_logic_vector(N - 1 DOWNTO 0); -- register read data 2
      writereg : IN std_logic_vector(4 DOWNTO 0); -- output of RegDst mux
      out_RegWrite : OUT std_logic;
      out_MemtoReg : OUT std_logic;
      out_MemWrite : OUT std_logic;
      out_aluresult : OUT std_logic_vector(N - 1 DOWNTO 0);
      out_writedata : OUT std_logic_vector(N - 1 DOWNTO 0);
      out_writereg : OUT std_logic_vector(4 DOWNTO 0));
  END COMPONENT;

  COMPONENT MEMWBreg IS
    GENERIC (N : INTEGER := 32);
    PORT (
      stall : IN std_logic;
      clock : IN std_logic;
      ctl_RegWrite : IN std_logic; -- propagate to WB
      ctl_MemtoReg : IN std_logic; -- propagate to WB
      alu_result : IN std_logic_vector(N - 1 DOWNTO 0); -- 32bit result of alu operation
      memreaddata : IN std_logic_vector(N - 1 DOWNTO 0); -- read data from memory module
      writereg : IN std_logic_vector(4 DOWNTO 0); -- output of RegDst mux
      out_RegWrite : OUT std_logic;
      out_MemtoReg : OUT std_logic;
      out_memreaddata : OUT std_logic_vector(N - 1 DOWNTO 0);
      out_aluresult : OUT std_logic_vector(N - 1 DOWNTO 0);
      out_writereg : OUT std_logic_vector(4 DOWNTO 0));
  END COMPONENT;

  COMPONENT control_logic IS
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

  --signals
  SIGNAL s_CLK, s_flush, ctl_RegDst, ctl_jump, ctl_jr, ctl_beq, ctl_bne, ctl_MemtoReg, ctl_MemWrite, ctl_ALUSrc, ctl_RegWrite, ctl_jal, ctl_lui, ctl_shamt, RegDst_idex, RegWrite_exmem, RegWrite_idex, RegWrite_memwb, MemToReg_exmem, MemToReg_idex, MemToReg_memwb, MemWrite_exmem, MemWrite_idex, ctl_unsigned, ALUSrc_idex: std_logic := '0';
  SIGNAL ctl_ALUOp, ALUOp_idex, s_stall : std_logic_vector(3 DOWNTO 0) := "0000";
  SIGNAL rt_idex, rd_idex, writereg_exmem, writereg_memwb : std_logic_vector(4 DOWNTO 0) := "00000";
  SIGNAL s_instr, instr_ifid, pcp4_idex, pcp4_ifid, readdata1_idex, readdata2_idex, aluresult_exmem, aluresult_memwb, sign_ext_idex, writedata_exmem, memreaddata_memwb : std_logic_vector(31 DOWNTO 0) := x"00000000";
  --testbench

BEGIN

  ctl : control_logic
  PORT MAP(
    opcode => instr_ifid(31 DOWNTO 26),
    func => instr_ifid(5 DOWNTO 0),
    regDst => ctl_RegDst,
    jump => ctl_jump,
    jr => ctl_jr,
    beq => ctl_beq,
    bne => ctl_bne,
    memToReg => ctl_MemtoReg,
    ALUControl => ctl_ALUOp,
    memWrite => ctl_MemWrite,
    ALUSrc => ctl_ALUSrc,
    regWrite => ctl_RegWrite,
    i_unsigned => ctl_unsigned, --emulated unsigned input
    jal => ctl_jal,
    lui => ctl_lui,
    shamt => ctl_shamt);

  IFID : IFIDreg
  PORT MAP(
    flush => s_flush,
    stall => s_stall(0),
    instr => s_instr,
    pcp4 => x"00000004",
    clock => s_CLK,
    out_pcp4 => pcp4_ifid,
    out_instr => instr_ifid);

  IDEX : IDEXreg
  PORT MAP(
    stall => s_stall(1),
    readdata1 => x"11111111", --emulated read data 1
    readdata2 => x"22222222", --emulated read data 2
    pcp4 => pcp4_ifid,
    sign_ext => x"aaaaaaaa", --emulated sign extension
    rt => instr_ifid(20 DOWNTO 16),
    rd => instr_ifid(15 DOWNTO 11),
    clock => s_CLK,
    ctl_RegWrite => ctl_RegWrite,
    ctl_MemtoReg => ctl_MemtoReg,
    ctl_MemWrite => ctl_MemWrite,
    ctl_ALUOp => ctl_ALUOp,
    ctl_ALUSrc => ctl_ALUSrc,
    ctl_RegDst => ctl_RegDst,
    out_RegWrite => RegWrite_idex,
    out_MemtoReg => MemToReg_idex,
    out_MemWrite => MemWrite_idex,
    out_ALUOp => ALUOp_idex,
    out_ALUSrc => ALUSrc_idex,
    out_RegDst => RegDst_idex,
    out_readdata1 => readdata1_idex,
    out_readdata2 => readdata2_idex,
    out_rt => rt_idex,
    out_rd => rd_idex,
    out_sign_ext => sign_ext_idex,
    out_pcp4 => pcp4_idex);

  EXMEM : EXMEMreg
  PORT MAP(
    stall => s_stall(2),
    clock => s_CLK,
    ctl_RegWrite => RegWrite_idex,
    ctl_MemtoReg => MemToReg_idex,
    ctl_MemWrite => MemWrite_idex,
    alu_result => x"33333333", --emulated alu result
    readdata2 => readdata2_idex,
    writereg => "10101", --emulated output of RegDst mux
    out_RegWrite => RegWrite_exmem,
    out_MemtoReg => MemToReg_exmem,
    out_MemWrite => MemWrite_exmem,
    out_aluresult => aluresult_exmem,
    out_writedata => writedata_exmem,
    out_writereg => writereg_exmem);

  MEMWB : MEMWBreg
  PORT MAP(
    stall => s_stall(3),
    clock => s_CLK,
    ctl_RegWrite => RegWrite_idex,
    ctl_MemtoReg => MemToReg_idex,
    alu_result => aluresult_exmem,
    memreaddata => x"44444444", --emulated memory read data
    writereg => writereg_exmem,
    out_RegWrite => RegWrite_memwb,
    out_MemtoReg => MemToReg_memwb,
    out_memreaddata => memreaddata_memwb,
    out_aluresult => aluresult_memwb,
    out_writereg => writereg_memwb);

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
    s_instr <= x"00000000";
    s_stall <= "0000";
	s_flush <= '0';
    WAIT FOR cCLK_PER;
    s_instr <= x"00000001";
    WAIT FOR cCLK_PER;
    s_instr <= x"00000010";
    WAIT FOR cCLK_PER;
    s_instr <= x"00000011";
    WAIT FOR cCLK_PER;
    s_instr <= x"00000100";
    WAIT FOR cCLK_PER;
    s_instr <= x"00000101";
    s_flush <= '1';
    WAIT FOR cCLK_PER;
	s_instr <= x"99999999";
    s_stall <= "1110";
    s_flush <= '0';
    WAIT FOR cCLK_PER;
	s_instr <= x"88888888";
    s_stall <= "1101";
    WAIT FOR cCLK_PER;
	s_instr <= x"77777777";
    s_stall <= "1011";
    WAIT FOR cCLK_PER;
	s_instr <= x"66666666";
    s_stall <= "0111";
    s_flush <= '1';
    WAIT FOR cCLK_PER;
    s_flush <= '1';
    WAIT FOR cCLK_PER;
    s_flush <= '1';
    WAIT FOR cCLK_PER;
	s_flush <= '1';
    WAIT FOR cCLK_PER;
	s_flush <= '1';
    WAIT FOR cCLK_PER;
    WAIT;
  END PROCESS;

END behavior;