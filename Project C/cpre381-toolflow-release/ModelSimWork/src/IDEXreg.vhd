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
END IDEXreg;

ARCHITECTURE behavior OF IDEXreg IS
BEGIN
  reg : PROCESS (clock)
  BEGIN
    IF (rising_edge(clock) AND NOT stall) THEN
      out_RegWrite <= ctl_RegWrite;
      out_MemtoReg <= ctl_MemtoReg;
      out_MemWrite <= ctl_RegWrite;
      out_ALUOp <= ctl_ALUOp;
      out_ALUSrc <= ctl_ALUSrc;
      out_RegDst <= ctl_RegDst;
      out_readdata1 <= readdata1;
      out_readdata2 <= readdata2;
      out_rt <= rt;
      out_rd <= rd;
      out_sign_ext <= sign_ext;
      out_pcp4 <= pcp4;
    END IF;
  END PROCESS;

END behavior;