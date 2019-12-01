LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY tb_control_logic IS
END tb_control_logic;

ARCHITECTURE behavior OF tb_control_logic IS

	COMPONENT control_logic IS
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
			pc_plus : OUT std_logic;
			lui : OUT std_logic;
			shamt : OUT std_logic
		);
	END COMPONENT;

	SIGNAL s_opcode, s_func : std_logic_vector(5 DOWNTO 0);
	SIGNAL s_regDst, s_jump, s_jr, s_beq, s_bne, s_memToReg,
	s_memWrite, s_ALUSrc, s_regWrite,
	s_iunsigned, s_pcplus, s_lui, s_shamt : std_logic;
	SIGNAL s_ALUControl : std_logic_vector(3 DOWNTO 0);

BEGIN

	logic : control_logic
	PORT MAP(
		opcode => s_opcode,
		func => s_func,
		regDst => s_regDst,
		jump => s_jump,
		jr => s_jr,
		beq => s_beq,
		bne => s_bne,
		memToReg => s_memToReg,
		ALUControl => s_ALUControl,
		memWrite => s_memWrite,
		ALUSrc => s_ALUSrc,
		regWrite => s_regWrite,
		i_unsigned => s_iunsigned,
		pc_plus => s_pcplus,
		lui => s_lui,
		shamt => s_shamt
	);

	PROCESS
	BEGIN
		--addi
		s_opcode <= "001000";
		s_func <= "000000";
		WAIT FOR 100 ns;

		--add
		s_opcode <= "000000";
		s_func <= "100000";
		WAIT FOR 100 ns;

		--addiu
		s_opcode <= "001001";
		s_func <= "000000";
		WAIT FOR 100 ns;

		--addu
		s_opcode <= "000000";
		s_func <= "100001";
		WAIT FOR 100 ns;

		--and
		s_opcode <= "000000";
		s_func <= "100100";
		WAIT FOR 100 ns;

		--andi
		s_opcode <= "001100";
		s_func <= "000000";
		WAIT FOR 100 ns;

		--lui
		s_opcode <= "001111";
		s_func <= "000000";
		WAIT FOR 100 ns;

		--lw
		s_opcode <= "100011";
		s_func <= "000000";
		WAIT FOR 100 ns;

		--nor
		s_opcode <= "000000";
		s_func <= "100111";
		WAIT FOR 100 ns;

		--xor
		s_opcode <= "000000";
		s_func <= "100110";
		WAIT FOR 100 ns;

		--xori
		s_opcode <= "001110";
		s_func <= "000000";
		WAIT FOR 100 ns;

		--or
		s_opcode <= "000000";
		s_func <= "100101";
		WAIT FOR 100 ns;

		--ori
		s_opcode <= "001101";
		s_func <= "000000";
		WAIT FOR 100 ns;

		--slt
		s_opcode <= "000000";
		s_func <= "101010";
		WAIT FOR 100 ns;

		--slti
		s_opcode <= "001010";
		s_func <= "000000";
		WAIT FOR 100 ns;

		--sltu
		s_opcode <= "000000";
		s_func <= "101011";
		WAIT FOR 100 ns;

		--sll
		s_opcode <= "000000";
		s_func <= "000000";
		WAIT FOR 100 ns;

		--srl
		s_opcode <= "000000";
		s_func <= "000010";
		WAIT FOR 100 ns;

		--sra
		s_opcode <= "000000";
		s_func <= "000011";
		WAIT FOR 100 ns;

		--sllv
		s_opcode <= "000000";
		s_func <= "000100";
		WAIT FOR 100 ns;

		s_opcode <= "001000";
		s_func <= "000000";
		WAIT FOR 100 ns;

		--srlv
		s_opcode <= "000000";
		s_func <= "000110";
		WAIT FOR 100 ns;

		--srav
		s_opcode <= "000000";
		s_func <= "000111";
		WAIT FOR 100 ns;

		--sw
		s_opcode <= "101011";
		s_func <= "000000";
		WAIT FOR 100 ns;

		--sub
		s_opcode <= "000000";
		s_func <= "100010";
		WAIT FOR 100 ns;

		--subu
		s_opcode <= "000000";
		s_func <= "100011";
		WAIT FOR 100 ns;

		--beq
		s_opcode <= "000100";
		s_func <= "000000";
		WAIT FOR 100 ns;

		--bne
		s_opcode <= "000101";
		s_func <= "000000";
		WAIT FOR 100 ns;

		--j
		s_opcode <= "000010";
		s_func <= "000000";
		WAIT FOR 100 ns;

		--jal
		s_opcode <= "000011";
		s_func <= "000000";
		WAIT FOR 100 ns;

		--jr
		s_opcode <= "000000";
		s_func <= "001000";
		WAIT FOR 100 ns;
	END PROCESS;
END behavior;