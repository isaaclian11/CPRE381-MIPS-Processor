LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity hazard_detection is
port(
	instr_idex: in std_logic_vector(31 downto 0); --Used to check lw and rt_idex
	instr_ifid: in std_logic_vector(31 downto 0); --Used for rs_ifid and rt_ifid
	jump : in std_logic; --Jump signal from the control unit
	stall : out std_logic;
	flush_ifid : out std_logic;
	flush_idex : out std_logic
);
end hazard_detection;

architecture dataflow of hazard_detection is

begin
process(instr_idex, instr_ifid)
begin
	
	stall <= '0';
	flush_idex <= '0';
	flush_ifid <= '0';
	
-- lw/lui/jal hazard
if((instr_idex(31 downto 26) = "100011" or instr_idex(31 downto 26)="001111" or instr_idex(31 downto 26)="000011") and ((instr_idex(20 downto 16) = instr_ifid(25 downto 21) and instr_ifid(25 downto 21) /= "00000") or (instr_idex(20 downto 16) = instr_ifid(20 downto 16) and instr_ifid(20 downto 16) /= "00000"))) then
	stall <= '1';
	flush_idex <= '1';
end if;
--jump hazard
if(jump = '1') then
	flush_ifid <= '1';
end if;

end process;

end dataflow;
	