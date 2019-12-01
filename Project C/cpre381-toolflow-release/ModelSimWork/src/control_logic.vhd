LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY control_logic IS
	PORT (
		opcode : IN std_logic_vector(5 DOWNTO 0);
		func : IN std_logic_vector(5 DOWNTO 0);
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
		shamt : OUT std_logic
	);
END control_logic;

ARCHITECTURE dataflow OF control_logic IS

BEGIN

	PROCESS (opcode, func)
	BEGIN
		--R Instructions
		IF (opcode = "000000") THEN
			ALUSrc <= '0';
			beq <= '0';
			bne <= '0';
			jal <= '0';
			jump <= '0';
			memToReg <= '0';
			memWrite <= '0';
			regWrite <= '1';
			regDst <= '1';
			i_unsigned <= '0';
			jr <= '0';
			lui <= '0';
			shamt <= '0';
			CASE func IS
					--add 
				WHEN "100000" =>
					ALUControl <= "0000";
					--addu
				WHEN "100001" =>
					ALUControl <= "0000";
					i_unsigned <= '1';
					--and
				WHEN "100100" =>
					ALUControl <= "0011";
					--nor
				WHEN "100111" =>
					ALUControl <= "0111";
					--xor
				WHEN "100110" =>
					ALUControl <= "0101";
					--or 
				WHEN "100101" =>
					ALUControl <= "0100";
					--slt
				WHEN "101010" =>
					ALUControl <= "0010";
					--sltu
				WHEN "101011" =>
					ALUControl <= "0010";
					i_unsigned <= '1';
					--sll
				WHEN "000000" =>
					ALUControl <= "1011";
					shamt <= '1';
					--srl 
				WHEN "000010" =>
					ALUControl <= "1010";
					shamt <= '1';
					--sra
				WHEN "000011" =>
					ALUControl <= "1000";
					shamt <= '1';
					--sllv
				WHEN "000100" =>
					ALUControl <= "1011";
					--srlv
				WHEN "000110" =>
					ALUControl <= "1010";
					--srav
				WHEN "000111" =>
					ALUControl <= "1000";
					--sub
				WHEN "100010" =>
					ALUControl <= "0001";
					--subu
				WHEN "100011" =>
					ALUControl <= "0001";
					i_unsigned <= '1';
					--jr 
				WHEN "001000" =>
					ALUControl <= "0000";
					jr <= '1';
					regWrite <= '0';
				WHEN OTHERS =>
			END CASE;

			--addi
		ELSIF (opcode = "001000") THEN
			ALUSrc <= '1';
			beq <= '0';
			bne <= '0';
			jal <= '0';
			jump <= '0';
			memToReg <= '0';
			memWrite <= '0';
			regWrite <= '1';
			regDst <= '0';
			i_unsigned <= '0';
			jr <= '0';
			lui <= '0';
			ALUControl <= "0000";
			shamt <= '0';

			--addiu
		ELSIF (opcode = "001001") THEN
			ALUSrc <= '1';
			beq <= '0';
			bne <= '0';
			jal <= '0';
			jump <= '0';
			memToReg <= '0';
			memWrite <= '0';
			regWrite <= '1';
			regDst <= '0';
			i_unsigned <= '1';
			jr <= '0';
			lui <= '0';
			ALUControl <= "0000";
			shamt <= '0';

			--andi 
		ELSIF (opcode = "001100") THEN
			ALUSrc <= '1';
			beq <= '0';
			bne <= '0';
			jal <= '0';
			jump <= '0';
			memToReg <= '0';
			memWrite <= '0';
			regWrite <= '1';
			regDst <= '0';
			i_unsigned <= '0';
			jr <= '0';
			lui <= '0';
			ALUControl <= "0011";
			shamt <= '0';

			--lui
		ELSIF (opcode = "001111") THEN
			ALUSrc <= '0';
			beq <= '0';
			bne <= '0';
			jal <= '0';
			jump <= '0';
			memToReg <= '0';
			memWrite <= '0';
			regWrite <= '1';
			regDst <= '0';
			i_unsigned <= '0';
			jr <= '0';
			lui <= '1';
			ALUControl <= "0000";
			shamt <= '0';

			--lw
		ELSIF (opcode = "100011") THEN
			ALUSrc <= '1';
			beq <= '0';
			bne <= '0';
			jal <= '0';
			jump <= '0';
			memToReg <= '1';
			memWrite <= '0';
			regWrite <= '1';
			regDst <= '0';
			i_unsigned <= '0';
			jr <= '0';
			lui <= '0';
			ALUControl <= "0000";
			shamt <= '0';

			--xori
		ELSIF (opcode = "001110") THEN
			ALUSrc <= '1';
			beq <= '0';
			bne <= '0';
			jal <= '0';
			jump <= '0';
			memToReg <= '0';
			memWrite <= '0';
			regWrite <= '1';
			regDst <= '0';
			i_unsigned <= '0';
			jr <= '0';
			lui <= '0';
			ALUControl <= "0101";
			shamt <= '0';

			--ori
		ELSIF (opcode = "001101") THEN
			ALUSrc <= '1';
			beq <= '0';
			bne <= '0';
			jal <= '0';
			jump <= '0';
			memToReg <= '0';
			memWrite <= '0';
			regWrite <= '1';
			regDst <= '0';
			i_unsigned <= '0';
			jr <= '0';
			lui <= '0';
			ALUControl <= "0100";
			shamt <= '0';

			--slti
		ELSIF (opcode = "001010") THEN
			ALUSrc <= '1';
			beq <= '0';
			bne <= '0';
			jal <= '0';
			jump <= '0';
			memToReg <= '0';
			memWrite <= '0';
			regWrite <= '1';
			regDst <= '0';
			i_unsigned <= '0';
			jr <= '0';
			lui <= '0';
			ALUControl <= "0010";
			shamt <= '0';

			--sltiu
		ELSIF (opcode = "001011") THEN
			ALUSrc <= '1';
			beq <= '0';
			bne <= '0';
			jal <= '0';
			jump <= '0';
			memToReg <= '0';
			memWrite <= '0';
			regWrite <= '1';
			regDst <= '0';
			i_unsigned <= '1';
			jr <= '0';
			lui <= '0';
			ALUControl <= "0010";
			shamt <= '0';

			--sw
		ELSIF (opcode = "101011") THEN
			ALUSrc <= '1';
			beq <= '0';
			bne <= '0';
			jal <= '0';
			jump <= '0';
			memToReg <= '0';
			memWrite <= '1';
			regWrite <= '0';
			regDst <= '0';
			i_unsigned <= '0';
			jr <= '0';
			lui <= '0';
			ALUControl <= "0000";
			shamt <= '0';

			--beq
		ELSIF (opcode = "000100") THEN
			ALUSrc <= '0';
			beq <= '1';
			bne <= '0';
			jal <= '0';
			jump <= '0';
			memToReg <= '0';
			memWrite <= '0';
			regWrite <= '0';
			regDst <= '0';
			i_unsigned <= '0';
			jr <= '0';
			lui <= '0';
			ALUControl <= "0001";
			shamt <= '0';

			--bne
		ELSIF (opcode = "000101") THEN
			ALUSrc <= '0';
			beq <= '0';
			bne <= '1';
			jal <= '0';
			jump <= '0';
			memToReg <= '0';
			memWrite <= '0';
			regWrite <= '0';
			regDst <= '0';
			i_unsigned <= '0';
			jr <= '0';
			lui <= '0';
			ALUControl <= "0001";
			shamt <= '0';

			--j
		ELSIF (opcode = "000010") THEN
			ALUSrc <= '0';
			beq <= '0';
			bne <= '0';
			jal <= '0';
			jump <= '1';
			memToReg <= '0';
			memWrite <= '0';
			regWrite <= '0';
			regDst <= '0';
			i_unsigned <= '0';
			jr <= '0';
			lui <= '0';
			ALUControl <= "0000";
			shamt <= '0';
			--jal
		ELSIF (opcode = "000011") THEN
			ALUSrc <= '0';
			beq <= '0';
			bne <= '0';
			jal <= '1';
			jump <= '1';
			memToReg <= '0';
			memWrite <= '0';
			regWrite <= '1';
			regDst <= '0';
			i_unsigned <= '0';
			jr <= '0';
			lui <= '0';
			ALUControl <= "0000";
			shamt <= '0';
		END IF;
	END PROCESS;
END dataflow;