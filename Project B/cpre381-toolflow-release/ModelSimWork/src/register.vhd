library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity reg is
  generic (N : integer := 32);                  -- Size of the register
  port (D      : in  std_logic_vector(N-1 downto 0);  -- Data input
        Q      : out std_logic_vector(N-1 downto 0);  -- Data output
        WE     : in  std_logic;                  -- Write enableenable
        reset  : in  std_logic;                  -- The clock signal
        clock  : in  std_logic);                 -- The reset signal
end reg;

architecture behavior of reg is
begin
  REG : process (clock)
  begin
    if (rising_edge(clock)) then
      if (reset = '1') then
	Q <= std_logic_vector(to_unsigned(0, Q'length));
      elsif (WE = '1') then
        Q <= D;
      end if;
    end if;
  end process;

end behavior;