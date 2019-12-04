LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity forwarding_unit is
port(
	instr_idex : in std_logic_vector(31 downto 0);
	rd_exmem : in std_logic_vector(4 downto 0);
	rd_memwb : in std_logic_vector(4 downto 0);
	regwrite_exmem : in std_logic;
	regwrite_memwb : in std_logic;
	forwardA : out std_logic_vector(1 downto 0);
	forwardB : out std_logic_vector(1 downto 0)
);

end forwarding_unit;

architecture mixed of forwarding_unit is

begin

process(instr_idex, rd_exmem, rd_memwb, regwrite_exmem, regwrite_memwb)

begin

forwardA <= "00";
forwardB <= "00";

--EX hazard
if((regwrite_exmem = '1' and rd_exmem /= "00000") and (rd_exmem = instr_idex(25 downto 21))) then
	forwardA <= "10";
end if;
if((regwrite_exmem = '1' and rd_exmem /= "00000") and (rd_exmem = instr_idex(20 downto 16))) then
	forwardB <= "10";
end if;
--MEM hazard
if((regwrite_memwb = '1' and rd_memwb /= "00000") and (rd_memwb = instr_idex(25 downto 21))) then
	forwardA <= "01";
end if;
if((regwrite_memwb = '1' and rd_memwb /= "00000") and (rd_memwb = instr_idex(20 downto 16))) then
	forwardB <= "01";
end if;
end process;
end mixed;