-- Quartus Prime VHDL Template
-- Single-port RAM with single read/write address

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mem IS

	GENERIC (
		DATA_WIDTH : NATURAL := 32;
		ADDR_WIDTH : NATURAL := 10
	);

	PORT (
		clk : IN std_logic;
		addr : IN std_logic_vector((ADDR_WIDTH - 1) DOWNTO 0);
		data : IN std_logic_vector((DATA_WIDTH - 1) DOWNTO 0);
		we : IN std_logic := '1';
		q : OUT std_logic_vector((DATA_WIDTH - 1) DOWNTO 0)
	);

END mem;

ARCHITECTURE rtl OF mem IS

	-- Build a 2-D array type for the RAM
	SUBTYPE word_t IS std_logic_vector((DATA_WIDTH - 1) DOWNTO 0);
	TYPE memory_t IS ARRAY(2 ** ADDR_WIDTH - 1 DOWNTO 0) OF word_t;

	-- Declare the RAM signal and specify a default value.	Quartus Prime
	-- will load the provided memory initialization file (.mif).
	SIGNAL ram : memory_t;

BEGIN

	PROCESS (clk)
	BEGIN
		IF (rising_edge(clk)) THEN
			IF (we = '1') THEN
				ram(to_integer(unsigned(addr))) <= data;
			END IF;
		END IF;
	END PROCESS;

	q <= ram(to_integer(unsigned(addr)));

END rtl;