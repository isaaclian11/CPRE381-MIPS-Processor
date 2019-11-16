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
      ctl_ALUOp : IN std_logic_vector(2 DOWNTO 0); -- propagate to EX
      ctl_ALUSrc : IN std_logic; -- propagate to EX
      ctl_RegDst : IN std_logic; -- propagate to EX
      out_RegWrite : OUT std_logic;
      out_MemtoReg : OUT std_logic;
      out_MemWrite : OUT std_logic;
      out_ALUOp : OUT std_logic_vector(2 DOWNTO 0);
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

  --signals
  SIGNAL s_CLK, s_flush, s_stall, s_instr,
  : std_logic := '0';

  SIGNAL s_instr : std_logic_vector(31 DOWNTO 0) := x"00000000";
  --testbench

BEGIN
  IFID : IFIDreg
  PORT MAP(
    flush => s_flush,
    stall => s_stall,
    instr => s_instr
    pcp4 => '4',
    clock => s_CLK,
    out_pcp4 => pcp4_ifid,
    out_instr => instr_ifid);

  IDEX : IDEXreg
  PORT MAP(
    stall => s_stall,
    readdata1 => x"11111111", --emulated read data 1
    readdata2 => x"22222222", --emulated read data 2
    pcp4 => pcp4_ifid,
    sign_ext => x"aaaaaaaa", --emulated sign extension
    rt => instr_ifid(20 DOWNTO 16),
    rd => instr_ifid(15 DOWNTO 11),
    clock => s_CLK,
    ctl_RegWrite => dec_RegWrite,
    ctl_MemtoReg => dec_MemtoReg,
    ctl_MemWrite => dec_MemWrite,
    ctl_ALUOp => dec_ALUOp,
    ctl_ALUSrc => dec_ALUSrc,
    ctl_RegDst => dec_RegDst,
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
    stall => s_stall,
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
  PORT MAP();

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
    s_stall <= '0';
    s_flush <= '1';
    WAIT FOR cCLK_PER;
    s_flush <= '0';
    WAIT FOR cCLK_PER;
    s_instr <= x"00000001";
    WAIT FOR cCLK_PER;
    s_instr <= x"00000010";
    s_stall <= '1';
    WAIT FOR cCLK_PER;
    s_instr <= x"00000011";
    s_stall <= '0';
    WAIT FOR cCLK_PER;
    s_instr <= x"00000100";
    WAIT FOR cCLK_PER;
    s_instr <= x"00000101";
    WAIT;
  END PROCESS;

END behavior;