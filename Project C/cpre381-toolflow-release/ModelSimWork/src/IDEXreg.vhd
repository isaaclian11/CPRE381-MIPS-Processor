library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- ID/EX Pipeline Register
entity IDEXreg is
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
end IDEXreg;

architecture behavior of IDEXreg is
begin
  reg : process (clock)
  begin
    if (rising_edge(clock) and not stall) then
		out_RegWrite  <= ctl_RegWrite;
        out_MemtoReg  <= ctl_MemtoReg;
        out_MemWrite  <= ctl_RegWrite;
        out_ALUOp	  <= ctl_ALUOp;
        out_ALUSrc	  <= ctl_ALUSrc;
        out_RegDst	  <= ctl_RegDst;
        out_readdata1 <= readdata1;
        out_readdata2 <= readdata2;
        out_rt		  <= rt;
        out_rd		  <= rd;
        out_sign_ext  <= sign_ext;
		out_pcp4	  <= pcp4;
    end if;
  end process;

end behavior;