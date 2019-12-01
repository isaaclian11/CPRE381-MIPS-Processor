LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY reg IS
  GENERIC (N : INTEGER := 32); -- Size of the register
  PORT (
    D : IN std_logic_vector(N - 1 DOWNTO 0); -- Data input
    Q : OUT std_logic_vector(N - 1 DOWNTO 0); -- Data output
    WE : IN std_logic; -- Write enable
    reset : IN std_logic; 
    clock : IN std_logic); 
END reg;

ARCHITECTURE behavior OF reg IS
BEGIN
  REG : PROCESS (clock, reset)
  BEGIN
	IF (reset = '1') THEN
        Q <= std_logic_vector(to_unsigned(4194304, Q'length));
    ELSIF (rising_edge(clock)) THEN
		Q <= D;
    END IF;
  END PROCESS;

END behavior;