LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY control_mux IS
	PORT (
		i_regDst : IN std_logic;
		i_jump : IN std_logic;
		i_jr : IN std_logic;
		i_beq : IN std_logic;
		i_bne : IN std_logic;
		i_memToReg : IN std_logic;
		i_ALUControl : IN std_logic_vector(3 DOWNTO 0);
		i_memWrite : IN std_logic;
		i_ALUSrc : IN std_logic;
		i_regWrite : IN std_logic;
		i_i_unsigned : IN std_logic;
		i_jal : IN std_logic;
		i_lui : IN std_logic;
		i_shamt : IN std_logic;
		regDst : OUT std_logic;
		jump : OUT std_logic;
		jr : OUT std_logic;
		beq : OUT std_logic;
		bne : OUT std_logic;
		memToReg : OUT std_logic;
		ALUControl : OUT std_logic_vector(3 DOWNTO 0);
		memWrite : OUT std_logic;
		ALUSrc : OUT std_logic;
		regWrite : OUT std_logic;
		i_unsigned : OUT std_logic;
		jal : OUT std_logic;
		lui : OUT std_logic;
		shamt : OUT std_logic;
		sel : IN std_logic
	);
END control_mux;

ARCHITECTURE dataflow OF control_mux IS

BEGIN
	process(sel, i_regDst, i_jump, i_jr, i_beq, i_bne, i_memToReg, i_ALUSrc, i_regWrite, i_i_unsigned, i_jal, i_lui, i_shamt, i_ALUControl)
	begin
	if(sel = '0')then
		regDst <= i_regDst;
		jump <= i_jump;
		jr <= i_jr;
		beq <= i_beq;
		bne <= i_bne;
		memToReg <= i_memToReg;
		memWrite <= i_memWrite;
		ALUSrc <= i_ALUSrc;
		regWrite <= i_regWrite;
		i_unsigned <= i_i_unsigned;
		jal <= i_jal;
		lui <= i_lui;
		shamt <= i_shamt;
		ALUControl <= i_ALUControl;
	else 
		regDst <= '0';
		jump <= '0';
		jr <= '0';
		beq <= '0';
		bne <= '0';
		memToReg <= '0';
		memWrite <= '0';
		ALUSrc <= '0';
		regWrite <= '0';
		i_unsigned <= '0';
		jal <= '0';
		lui <= '0';
		shamt <= '0';
		ALUControl <= "0000";
	end if;
	end process;
END dataflow;