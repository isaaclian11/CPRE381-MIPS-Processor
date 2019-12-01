-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------


-- tb_dmem.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Testbench for CPRE 381 Lab 4 P2c
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_dmem is
  generic(gCLK_HPER   : time := 50 ps);
end tb_dmem;

architecture behavioral of tb_dmem is

-- Calculate the clock period as twice the half-period
constant cCLK_PER  : time := gCLK_HPER * 2;

component mem is

	generic 
	(
		DATA_WIDTH : natural := 32;
		ADDR_WIDTH : natural := 12
	);

	port 
	(
		clk		: in std_logic;
		addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
		data	        : in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);

end component;

--SIGNALS
signal s_clk, s_we : std_logic;
signal s_addr : std_logic_vector(11 downto 0);
signal s_data, s_q : std_logic_vector(31 downto 0);

begin
  dmem : mem
    generic map (ADDR_WIDTH => 12)
    port map (clk => s_clk,
              addr => s_addr,
			  data => s_data,
			  we => s_we,
			  q => s_q);

P_CLK: process
  begin
    s_clk <= '0';
    wait for gCLK_HPER;
    s_clk <= '1';
    wait for gCLK_HPER;
  end process;
  
P_TB: process
  begin
    --  read memory addr 0x000, q follows
    s_we <= '0';
	s_addr <= x"000";
    wait for cCLK_PER;
	
	-- write q (memory addr 0x000) to memory addr 0x100
    s_we <= '1';
	s_addr <= x"100";
	s_data <= s_q;
	wait for cCLK_PER;
	
    --  read memory addr 0x001, q follows
    s_we <= '0';
	s_addr <= x"001";
    wait for cCLK_PER;
	
	-- write q (memory addr 0x001) to memory addr 0x101
    s_we <= '1';
	s_addr <= x"101";
	s_data <= s_q;
	wait for cCLK_PER;
	
    --  read memory addr 0x002, q follows
    s_we <= '0';
	s_addr <= x"002";
    wait for cCLK_PER;
	
	-- write q (memory addr 0x002) to memory addr 0x102
    s_we <= '1';
	s_addr <= x"102";
	s_data <= s_q;
	wait for cCLK_PER;
	
    --  read memory addr 0x003, q follows
    s_we <= '0';
	s_addr <= x"003";
    wait for cCLK_PER;
	
	-- write q (memory addr 0x003) to memory addr 0x103
    s_we <= '1';
	s_addr <= x"103";
	s_data <= s_q;
	wait for cCLK_PER;
	
    --  read memory addr 0x004, q follows
    s_we <= '0';
	s_addr <= x"004";
    wait for cCLK_PER;
	
	-- write q (memory addr 0x004) to memory addr 0x104
    s_we <= '1';
	s_addr <= x"104";
	s_data <= s_q;
	wait for cCLK_PER;
	
    --  read memory addr 0x005, q follows
    s_we <= '0';
	s_addr <= x"005";
    wait for cCLK_PER;
	
	-- write q (memory addr 0x005) to memory addr 0x105
    s_we <= '1';
	s_addr <= x"105";
	s_data <= s_q;
	wait for cCLK_PER;
	
    --  read memory addr 0x006, q follows
    s_we <= '0';
	s_addr <= x"006";
    wait for cCLK_PER;
	
	-- write q (memory addr 0x006) to memory addr 0x106
    s_we <= '1';
	s_addr <= x"106";
	s_data <= s_q;
	wait for cCLK_PER;
	
    --  read memory addr 0x007, q follows
    s_we <= '0';
	s_addr <= x"007";
    wait for cCLK_PER;
	
	-- write q (memory addr 0x007) to memory addr 0x107
    s_we <= '1';
	s_addr <= x"107";
	s_data <= s_q;
	wait for cCLK_PER;
	
    --  read memory addr 0x008, q follows
    s_we <= '0';
	s_addr <= x"008";
    wait for cCLK_PER;
	
	-- write q (memory addr 0x008) to memory addr 0x108
    s_we <= '1';
	s_addr <= x"108";
	s_data <= s_q;
	wait for cCLK_PER;
	
    --  read memory addr 0x009, q follows
    s_we <= '0';
	s_addr <= x"009";
    wait for cCLK_PER;
	
	-- write q (memory addr 0x009) to memory addr 0x109
    s_we <= '1';
	s_addr <= x"109";
	s_data <= s_q;
	wait for cCLK_PER;
	
	--  read back written memory to make sure it worked
    s_we <= '0';
	s_addr <= x"100";
    wait for cCLK_PER;
    s_we <= '0';
	s_addr <= x"101";
    wait for cCLK_PER;
	s_we <= '0';
	s_addr <= x"102";
    wait for cCLK_PER;
    s_we <= '0';
	s_addr <= x"103";
    wait for cCLK_PER;
	s_we <= '0';
	s_addr <= x"104";
    wait for cCLK_PER;
    s_we <= '0';
	s_addr <= x"105";
    wait for cCLK_PER;
	s_we <= '0';
	s_addr <= x"106";
    wait for cCLK_PER;
	s_we <= '0';
	s_addr <= x"107";
    wait for cCLK_PER;
	s_we <= '0';
	s_addr <= x"108";
    wait for cCLK_PER;
	s_we <= '0';
	s_addr <= x"109";
    wait for cCLK_PER;
	
  end process;
	
	
end behavioral;