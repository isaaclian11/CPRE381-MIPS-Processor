library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- IF/ID Pipeline Register
entity IFIDreg is
  generic (N : integer := 32);
  port (flush     : in  std_logic;
		stall	  : in  std_logic;
		instr     : in  std_logic_vector(N-1 downto 0); -- instruction data
        pcp4      : in  std_logic_vector(N-1 downto 0); -- PC+4
        clock     : in  std_logic;
		out_pcp4  : out std_logic_vector(N-1 downto 0);
		out_instr : out std_logic_vector(N-1 downto 0));
end IFIDreg;

architecture behavior of IFIDreg is
begin
  reg : process (clock)
  begin
    if (rising_edge(clock) and not stall) then
		with flush select out_instr <=
			instr when 0,
			x"00000000" when others;
		out_pcp4  <= pcp4;
    end if;
  end process;

end behavior;