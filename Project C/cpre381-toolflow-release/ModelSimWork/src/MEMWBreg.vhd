library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- MEM/WB Pipeline Register
entity MEMWBreg is
  generic (N : integer := 32);
  port (stall	        : in std_logic;
        clock           : in std_logic;
		ctl_RegWrite    : in std_logic; 						-- propagate to WB
        ctl_MemtoReg    : in std_logic; 						-- propagate to WB
        alu_result      : in std_logic_vector(N-1 downto 0);	-- 32bit result of alu operation
        memreaddata     : in std_logic_vector(N-1 downto 0);  	-- read data from memory module
		writereg        : in std_logic_vector(4 downto 0);		-- output of RegDst mux
		out_RegWrite    : out std_logic;
        out_MemtoReg    : out std_logic;
        out_memreaddata : out std_logic_vector(N-1 downto 0);
        out_aluresult   : out std_logic_vector(N-1 downto 0);
        out_writereg    : out std_logic_vector(4 downto 0));
end MEMWBreg;

architecture behavior of MEMWBreg is
begin
  reg : process (clock)
  begin
    if (rising_edge(clock) and not stall) then
		out_RegWrite    <= ctl_RegWrite;
        out_MemtoReg    <= ctl_MemtoReg;
		out_aluresult   <= alu_result;
        out_memreaddata <= memreaddata;
		out_writereg    <= writereg;
    end if;
  end process;

end behavior;