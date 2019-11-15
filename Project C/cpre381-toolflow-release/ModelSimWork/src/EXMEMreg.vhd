library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- EX/MEM Pipeline Register
-- referenced: https://github.com/renataghisloti/VHDL-Mips-Pipeline-Microprocessor/blob/master/vhdl/regaux3.vhd
entity EXMEMreg is
  generic (N : integer := 32);
  port (stall	      : in std_logic;
        clock         : in std_logic;
		ctl_RegWrite  : in std_logic; 						-- propagate to WB
        ctl_MemtoReg  : in std_logic; 						-- propagate to WB
        ctl_MemWrite  : in std_logic; 						-- propagate to MEM
        alu_result    : in std_logic_vector(N-1 downto 0);	-- 32bit result of alu operation
        readdata2     : in std_logic_vector(N-1 downto 0);  -- register read data 2
		writereg      : in std_logic_vector(4 downto 0);	-- output of RegDst mux
		out_RegWrite  : out std_logic;
        out_MemtoReg  : out std_logic;
        out_MemWrite  : out std_logic;
        out_aluresult : out std_logic_vector(N-1 downto 0);
		out_writedata : out std_logic_vector(N-1 downto 0);
        out_writereg  : out std_logic_vector(4 downto 0));
end EXMEMreg;

architecture behavior of EXMEMreg is
begin
  reg : process (clock)
  begin
    if (rising_edge(clock) and not stall) then
		out_RegWrite  <= ctl_RegWrite;
        out_MemtoReg  <= ctl_MemtoReg;
        out_MemWrite  <= ctl_RegWrite;
		out_aluresult <= alu_result;
        out_writedata <= readdata2;
		out_writereg  <= writereg;
    end if;
  end process;

end behavior;