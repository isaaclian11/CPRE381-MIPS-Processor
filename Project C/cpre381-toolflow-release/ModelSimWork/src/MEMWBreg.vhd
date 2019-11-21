LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
-- MEM/WB Pipeline Register
ENTITY MEMWBreg IS
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
    out_RegWrite : OUT std_logic;
    out_MemtoReg : OUT std_logic;
    out_memreaddata : OUT std_logic_vector(N - 1 DOWNTO 0);
    out_aluresult : OUT std_logic_vector(N - 1 DOWNTO 0);
    out_writereg : OUT std_logic_vector(4 DOWNTO 0);
	out_jal : OUT std_logic;
    out_lui : OUT std_logic;
	out_pcp4 : OUT std_logic_vector(N-1 DOWNTO 0);
	out_instr : OUT std_logic_vector(N-1 DOWNTO 0));
END MEMWBreg;

ARCHITECTURE behavior OF MEMWBreg IS
BEGIN
  reg : PROCESS (clock)
  BEGIN
    IF (rising_edge(clock)) THEN
	  IF (stall = '0') THEN
        out_RegWrite <= ctl_RegWrite;
        out_MemtoReg <= ctl_MemtoReg;
        out_aluresult <= alu_result;
        out_memreaddata <= memreaddata;
        out_writereg <= writereg;
		out_instr <= instr;
		out_pcp4 <= pcp4;
		out_jal <= ctl_jal;
		out_lui <= ctl_lui;
      END IF;
	END IF;
  END PROCESS;

END behavior;