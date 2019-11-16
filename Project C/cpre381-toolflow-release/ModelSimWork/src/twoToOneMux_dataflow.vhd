LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY twoToOneMux_dataflow IS
	GENERIC (N : INTEGER := 8);
	PORT (
		iX : IN std_logic_vector(N - 1 DOWNTO 0);
		iY : IN std_logic_vector(N - 1 DOWNTO 0);
		sel : IN std_logic;
		o_F : OUT std_logic_vector(N - 1 DOWNTO 0)
	);
END twoToOneMux_dataflow;
ARCHITECTURE dataflow OF twoToOneMux_dataflow IS

BEGIN

	o_F <= iX WHEN (sel = '0') ELSE
		iY;

END dataflow;