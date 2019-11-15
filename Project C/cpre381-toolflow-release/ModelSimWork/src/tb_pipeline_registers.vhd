-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------


-- tb_pipeline_registers.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: testbench for new pipeline registers; IF/ID, ID/EX, etc.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_pipeline_registers is
  generic(gCLK_HPER   : time := 50 ns);
end tb_pipeline_registers;

architecture behavior of tb_pipeline_registers is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

  component IFIDreg is
  generic (N : integer := 32);
  port (flush     : in  std_logic;
		stall	  : in  std_logic;
		instr     : in  std_logic_vector(N-1 downto 0); -- instruction data
        pcp4      : in  std_logic_vector(N-1 downto 0); -- PC+4
        clock     : in  std_logic;
		out_pcp4  : out std_logic_vector(N-1 downto 0);
		out_instr : out std_logic_vector(N-1 downto 0));
  end component;
  
  component IDEXreg is
  generic (N : integer := 32);
  port (stall	      : in  std_logic;
		readdata1     : in  std_logic_vector(N-1 downto 0); -- register read data 1
		readdata2     : in  std_logic_vector(N-1 downto 0); -- register read data 2
        pcp4          : in std_logic_vector(N-1 downto 0);  -- PC+4
		sign_ext      : in std_logic_vector(N-1 downto 0);  -- output of sign extender
		rt  	      : in std_logic_vector(4 downto 0);  	-- instruction[20-16], Rt
		rd  	      : in std_logic_vector(4 downto 0);  	-- instruction[15-11], Rd
        clock         : in  std_logic;
		ctl_RegWrite  : in std_logic; 						-- propagate to WB
        ctl_MemtoReg  : in std_logic; 						-- propagate to WB
        ctl_MemWrite  : in std_logic; 						-- propagate to MEM
        ctl_ALUOp     : in std_logic_vector(2 downto 0);	-- propagate to EX
        ctl_ALUSrc    : in std_logic;						-- propagate to EX
        ctl_RegDst    : in std_logic;						-- propagate to EX
		out_RegWrite  : out std_logic;
        out_MemtoReg  : out std_logic;
        out_MemWrite  : out std_logic;
        out_ALUOp     : out std_logic_vector(2 downto 0);
        out_ALUSrc    : out std_logic;
        out_RegDst    : out std_logic;
        out_readdata1 : out std_logic_vector(N-1 downto 0);
        out_readdata2 : out std_logic_vector(N-1 downto 0);
        out_rt        : out std_logic_vector(4 downto 0);
        out_rd        : out std_logic_vector(4 downto 0);
        out_sign_ext  : out std_logic_vector(N-1 downto 0);
		out_pcp4      : out std_logic_vector(N-1 downto 0));
  end component;
  
  component EXMEMreg is
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
  end component;
  
  component MEMWBreg is
  generic (N : integer := 32);
  port (stall	        : in std_logic;
        clock           : in std_logic;
		ctl_RegWrite    : in std_logic; 					 -- propagate to WB
        ctl_MemtoReg    : in std_logic; 					 -- propagate to WB
        alu_result      : in std_logic_vector(N-1 downto 0); -- 32bit result of alu operation
        memreaddata     : in std_logic_vector(N-1 downto 0); -- read data from memory module
		writereg        : in std_logic_vector(4 downto 0);	 -- output of RegDst mux
		out_RegWrite    : out std_logic;
        out_MemtoReg    : out std_logic;
        out_memreaddata : out std_logic_vector(N-1 downto 0);
        out_aluresult   : out std_logic_vector(N-1 downto 0);
        out_writereg    : out std_logic_vector(4 downto 0));
  end component;
  
  --signals
  
  --testbench
  
  begin
  IFID : IFIDreg
    port map ();

  IDEX : IDEXreg
    port map ();
	
  EXMEM : EXMEMreg
    port map ();
	
  MEMWB : MEMWBreg
    port map ();
  
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin
  
  
	
    wait;
  end process;
  
end behavior;
