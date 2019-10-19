library IEEE;
use IEEE.std_logic_1164.all;

entity twoToOneMux_dataflow is
generic(N	:	integer:=8);
port(
	iX	:	in std_logic_vector(N-1 downto 0);
	iY	:	in std_logic_vector(N-1 downto 0);
	sel		:	in std_logic;
	o_F	:	out std_logic_vector(N-1 downto 0)
);
end twoToOneMux_dataflow;


architecture dataflow of twoToOneMux_dataflow is

begin

	o_F	<=	iX	when (sel='0') else iY;

end dataflow;