LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
-- IF/ID Pipeline Register
ENTITY IFIDreg IS
  GENERIC (N : INTEGER := 32);
  PORT (
    flush : IN std_logic;
    stall : IN std_logic;
    instr : IN std_logic_vector(N - 1 DOWNTO 0); -- instruction data
    pcp4 : IN std_logic_vector(N - 1 DOWNTO 0); -- PC+4
    clock : IN std_logic;
    out_pcp4 : OUT std_logic_vector(N - 1 DOWNTO 0);
    out_instr : OUT std_logic_vector(N - 1 DOWNTO 0));
END IFIDreg;

ARCHITECTURE behavior OF IFIDreg IS
BEGIN
  reg : PROCESS (clock)
  BEGIN
    IF (rising_edge(clock) AND NOT stall) THEN
      WITH flush SELECT out_instr <=
        instr WHEN 0,
        x"00000000" WHEN OTHERS;
      out_pcp4 <= pcp4;
    END IF;
  END PROCESS;

END behavior;