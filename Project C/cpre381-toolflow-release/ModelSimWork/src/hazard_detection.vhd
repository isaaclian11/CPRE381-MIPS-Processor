LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity hazard_detection is
port(
	instr_idex: in std_logic_vector(31 downto 0); --Used to check lw and rt_idex
	instr_ifid: in std_logic_vector(31 downto 0); --Used for rs_ifid and rt_ifid
	branch : in std_logic; --Branch signal from the control unit
	jump : in std_logic;
	jr : in std_logic;
	stall : out std_logic;
	flush_ifid : out std_logic;
	flush_idex : out std_logic
);
end hazard_detection;

architecture dataflow of hazard_detection is

signal branchStall : BOOLEAN;

begin
	
branchStall <= ((branch='1') and (((instr_idex(15 downto 11)=instr_ifid(25 downto 21)) and (instr_ifid(25 downto 21)/="00000")) or ((instr_idex(15 downto 11)=instr_ifid(20 downto 16)) and (instr_ifid(20 downto 16)/="00000"))));

process(instr_idex, instr_ifid, branch, jr, jump,branchStall)
begin
	
	stall <= '0';
	flush_idex <= '0';
	flush_ifid <= '0';
	
-- lw/lui/jal hazard
if((instr_idex(31 downto 26) = "100011" or instr_idex(31 downto 26)="001111" or instr_idex(31 downto 26)="000011") and ((instr_idex(20 downto 16) = instr_ifid(25 downto 21) and instr_ifid(25 downto 21) /= "00000") or (instr_idex(20 downto 16) = instr_ifid(20 downto 16) and instr_ifid(20 downto 16) /= "00000"))) then
	stall <= '1';
	flush_idex <= '1';
	flush_ifid <= '0';
end if;
--branch hazard
if(branch = '1') then
	flush_ifid <= '1';
	stall <= '0';
	flush_idex <='0';
end if;
if(jump = '1') then
	flush_ifid <= '1';
	stall <= '0';
	flush_idex <='0';
end if;
if(jr='1') then
	flush_ifid <= '1';
	stall <= '0';
	flush_idex <='0';
end if;
if(jr = '1' and (instr_idex(31 downto 26)="001000" and instr_idex(20 downto 16)="11111")) then
	stall <= '1';
	flush_idex <= '1';
	flush_ifid <= '0';
end if;
if(branchStall)then
	stall <= '1';
	flush_idex <='1';
	flush_ifid <= '0';
end if;
end process;

end dataflow;
	