LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
-- EX/MEM Pipeline Register
-- referenced: https://github.com/renataghisloti/VHDL-Mips-Pipeline-Microprocessor/blob/master/vhdl/regaux3.vhd
ENTITY EXMEMreg IS
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
END EXMEMreg;

ARCHITECTURE behavior OF EXMEMreg IS
BEGIN
  reg : PROCESS (clock)
  BEGIN
    IF (rising_edge(clock)) THEN
	  IF (stall = '0') THEN
        out_RegWrite <= ctl_RegWrite;
        out_MemtoReg <= ctl_MemtoReg;
        out_MemWrite <= ctl_RegWrite;
        out_aluresult <= alu_result;
        out_writedata <= readdata2;
        out_writereg <= writereg;
		out_instr <= instr;
		out_pcp4 <= pcp4;
		out_jal <= ctl_jal;
		out_lui <= ctl_lui;
	  END IF;
    END IF;
  END PROCESS;

END behavior;