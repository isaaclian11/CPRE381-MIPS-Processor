-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------
-- tb_dmem.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Testbench for CPRE 381 Lab 4 P2c
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY tb_dmem IS
	GENERIC (gCLK_HPER : TIME := 50 ps);
END tb_dmem;

ARCHITECTURE behavioral OF tb_dmem IS

	-- Calculate the clock period as twice the half-period
	CONSTANT cCLK_PER : TIME := gCLK_HPER * 2;

	COMPONENT mem IS

		GENERIC (
			DATA_WIDTH : NATURAL := 32;
			ADDR_WIDTH : NATURAL := 12
		);

		PORT (
			clk : IN std_logic;
			addr : IN std_logic_vector((ADDR_WIDTH - 1) DOWNTO 0);
			data : IN std_logic_vector((DATA_WIDTH - 1) DOWNTO 0);
			we : IN std_logic := '1';
			q : OUT std_logic_vector((DATA_WIDTH - 1) DOWNTO 0)
		);

	END COMPONENT;

	--SIGNALS
	SIGNAL s_clk, s_we : std_logic;
	SIGNAL s_addr : std_logic_vector(11 DOWNTO 0);
	SIGNAL s_data, s_q : std_logic_vector(31 DOWNTO 0);

BEGIN
	dmem : mem
	GENERIC MAP(ADDR_WIDTH => 12)
	PORT MAP(
		clk => s_clk,
		addr => s_addr,
		data => s_data,
		we => s_we,
		q => s_q);

	P_CLK : PROCESS
	BEGIN
		s_clk <= '0';
		WAIT FOR gCLK_HPER;
		s_clk <= '1';
		WAIT FOR gCLK_HPER;
	END PROCESS;

	P_TB : PROCESS
	BEGIN
		--  read memory addr 0x000, q follows
		s_we <= '0';
		s_addr <= x"000";
		WAIT FOR cCLK_PER;

		-- write q (memory addr 0x000) to memory addr 0x100
		s_we <= '1';
		s_addr <= x"100";
		s_data <= s_q;
		WAIT FOR cCLK_PER;

		--  read memory addr 0x001, q follows
		s_we <= '0';
		s_addr <= x"001";
		WAIT FOR cCLK_PER;

		-- write q (memory addr 0x001) to memory addr 0x101
		s_we <= '1';
		s_addr <= x"101";
		s_data <= s_q;
		WAIT FOR cCLK_PER;

		--  read memory addr 0x002, q follows
		s_we <= '0';
		s_addr <= x"002";
		WAIT FOR cCLK_PER;

		-- write q (memory addr 0x002) to memory addr 0x102
		s_we <= '1';
		s_addr <= x"102";
		s_data <= s_q;
		WAIT FOR cCLK_PER;

		--  read memory addr 0x003, q follows
		s_we <= '0';
		s_addr <= x"003";
		WAIT FOR cCLK_PER;

		-- write q (memory addr 0x003) to memory addr 0x103
		s_we <= '1';
		s_addr <= x"103";
		s_data <= s_q;
		WAIT FOR cCLK_PER;

		--  read memory addr 0x004, q follows
		s_we <= '0';
		s_addr <= x"004";
		WAIT FOR cCLK_PER;

		-- write q (memory addr 0x004) to memory addr 0x104
		s_we <= '1';
		s_addr <= x"104";
		s_data <= s_q;
		WAIT FOR cCLK_PER;

		--  read memory addr 0x005, q follows
		s_we <= '0';
		s_addr <= x"005";
		WAIT FOR cCLK_PER;

		-- write q (memory addr 0x005) to memory addr 0x105
		s_we <= '1';
		s_addr <= x"105";
		s_data <= s_q;
		WAIT FOR cCLK_PER;

		--  read memory addr 0x006, q follows
		s_we <= '0';
		s_addr <= x"006";
		WAIT FOR cCLK_PER;

		-- write q (memory addr 0x006) to memory addr 0x106
		s_we <= '1';
		s_addr <= x"106";
		s_data <= s_q;
		WAIT FOR cCLK_PER;

		--  read memory addr 0x007, q follows
		s_we <= '0';
		s_addr <= x"007";
		WAIT FOR cCLK_PER;

		-- write q (memory addr 0x007) to memory addr 0x107
		s_we <= '1';
		s_addr <= x"107";
		s_data <= s_q;
		WAIT FOR cCLK_PER;

		--  read memory addr 0x008, q follows
		s_we <= '0';
		s_addr <= x"008";
		WAIT FOR cCLK_PER;

		-- write q (memory addr 0x008) to memory addr 0x108
		s_we <= '1';
		s_addr <= x"108";
		s_data <= s_q;
		WAIT FOR cCLK_PER;

		--  read memory addr 0x009, q follows
		s_we <= '0';
		s_addr <= x"009";
		WAIT FOR cCLK_PER;

		-- write q (memory addr 0x009) to memory addr 0x109
		s_we <= '1';
		s_addr <= x"109";
		s_data <= s_q;
		WAIT FOR cCLK_PER;

		--  read back written memory to make sure it worked
		s_we <= '0';
		s_addr <= x"100";
		WAIT FOR cCLK_PER;
		s_we <= '0';
		s_addr <= x"101";
		WAIT FOR cCLK_PER;
		s_we <= '0';
		s_addr <= x"102";
		WAIT FOR cCLK_PER;
		s_we <= '0';
		s_addr <= x"103";
		WAIT FOR cCLK_PER;
		s_we <= '0';
		s_addr <= x"104";
		WAIT FOR cCLK_PER;
		s_we <= '0';
		s_addr <= x"105";
		WAIT FOR cCLK_PER;
		s_we <= '0';
		s_addr <= x"106";
		WAIT FOR cCLK_PER;
		s_we <= '0';
		s_addr <= x"107";
		WAIT FOR cCLK_PER;
		s_we <= '0';
		s_addr <= x"108";
		WAIT FOR cCLK_PER;
		s_we <= '0';
		s_addr <= x"109";
		WAIT FOR cCLK_PER;

	END PROCESS;
END behavioral;