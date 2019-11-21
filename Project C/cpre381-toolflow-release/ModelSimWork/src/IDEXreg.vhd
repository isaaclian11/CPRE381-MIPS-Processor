LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
-- ID/EX Pipeline Register
ENTITY IDEXreg IS
  GENERIC (N : INTEGER := 32);
  PORT (
    stall : IN std_logic;
    readdata1 : IN std_logic_vector(N - 1 DOWNTO 0); -- register read data 1
    readdata2 : IN std_logic_vector(N - 1 DOWNTO 0); -- register read data 2
    pcp4 : IN std_logic_vector(N - 1 DOWNTO 0); -- PC+4
    sign_ext : IN std_logic_vector(N - 1 DOWNTO 0); -- output of sign extender
    instr: IN std_logic_vector(N-1 DOWNTO 0);
    shamt : IN std_logic_vector(31 downto 0);
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
END IDEXreg;

ARCHITECTURE behavior OF IDEXreg IS
BEGIN
  reg : PROCESS (clock)
  BEGIN
    IF (rising_edge(clock)) THEN
	  IF (stall = '0') THEN
        out_RegWrite <= ctl_RegWrite;
        out_MemtoReg <= ctl_MemtoReg;
        out_MemWrite <= ctl_RegWrite;
        out_ALUOp <= ctl_ALUOp;
        out_ALUSrc <= ctl_ALUSrc;
        out_RegDst <= ctl_RegDst;
        out_jal <= ctl_jal;
        out_lui <= ctl_lui;
        out_readdata1 <= readdata1;
        out_readdata2 <= readdata2;
        out_inst <= instr;
        out_shamt <= shamt;
        out_sign_ext <= sign_ext;
        out_pcp4 <= pcp4;
		out_unsigned <= ctl_unsigned;
		out_shamtCtl <= ctl_shamt;
      END IF;
	END IF;
  END PROCESS;

END behavior;