library IEEE;
use IEEE.std_logic_1164.all;

entity tb_control_logic is
end tb_control_logic;

architecture behavior of tb_control_logic is

component control_logic is
port (
	opcode	:	in std_logic_vector(5 downto 0);
	func	:	in std_logic_vector(5 downto 0);
	regDst	:	out std_logic;
	jump	:	out std_logic;
	jr		:	out std_logic;
	beq		:	out std_logic;
	bne		:	out std_logic;
	memToReg:	out std_logic;
	ALUControl	:	out std_logic_vector(3 downto 0);
	memWrite	:	out std_logic;
	ALUSrc		:	out std_logic;
	regWrite	:	out std_logic;
	i_unsigned	:	out std_logic;
	pc_plus		:	out std_logic;
	lui			:	out std_logic;
	shamt		:	out std_logic
);
end component;

signal s_opcode, s_func	: std_logic_vector(5 downto 0);
signal s_regDst, s_jump, s_jr, s_beq, s_bne, s_memToReg, 
		s_memWrite, s_ALUSrc, s_regWrite, 
		s_iunsigned, s_pcplus, s_lui, s_shamt : std_logic;
signal s_ALUControl : std_logic_vector(3 downto 0);

begin

logic: control_logic
port map (
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

process 
begin
	--addi
	s_opcode <= "001000";
	s_func <= "000000";
	wait for 100 ns;
	
	--add
	s_opcode <= "000000";
	s_func <= "100000";
	wait for 100 ns;
	
	--addiu
	s_opcode <= "001001";
	s_func <= "000000";
	wait for 100 ns;
	
	--addu
	s_opcode <= "000000";
	s_func <= "100001";
	wait for 100 ns;
	
	--and
	s_opcode <= "000000";
	s_func <= "100100";
	wait for 100 ns;
	
	--andi
	s_opcode <= "001100";
	s_func <= "000000";
	wait for 100 ns;
	
	--lui
	s_opcode <= "001111";
	s_func <= "000000";
	wait for 100 ns;
	
	--lw
	s_opcode <= "100011";
	s_func <= "000000";
	wait for 100 ns;
	
	--nor
	s_opcode <= "000000";
	s_func <= "100111";
	wait for 100 ns;
	
	--xor
	s_opcode <= "000000";
	s_func <= "100110";
	wait for 100 ns;
	
	--xori
	s_opcode <= "001110";
	s_func <= "000000";
	wait for 100 ns;
	
	--or
	s_opcode <= "000000";
	s_func <= "100101";
	wait for 100 ns;
	
	--ori
	s_opcode <= "001101";
	s_func <= "000000";
	wait for 100 ns;
	
	--slt
	s_opcode <= "000000";
	s_func <= "101010";
	wait for 100 ns;
	
	--slti
	s_opcode <= "001010";
	s_func <= "000000";
	wait for 100 ns;
	
	--sltu
	s_opcode <= "000000";
	s_func <= "101011";
	wait for 100 ns;
	
	--sll
	s_opcode <= "000000";
	s_func <= "000000";
	wait for 100 ns;
	
	--srl
	s_opcode <= "000000";
	s_func <= "000010";
	wait for 100 ns;
	
	--sra
	s_opcode <= "000000";
	s_func <= "000011";
	wait for 100 ns;
	
	--sllv
	s_opcode <= "000000";
	s_func <= "000100";
	wait for 100 ns;
	
	s_opcode <= "001000";
	s_func <= "000000";
	wait for 100 ns;
	
	--srlv
	s_opcode <= "000000";
	s_func <= "000110";
	wait for 100 ns;
	
	--srav
	s_opcode <= "000000";
	s_func <= "000111";
	wait for 100 ns;
	
	--sw
	s_opcode <= "101011";
	s_func <= "000000";
	wait for 100 ns;
	
	--sub
	s_opcode <= "000000";
	s_func <= "100010";
	wait for 100 ns;
	
	--subu
	s_opcode <= "000000";
	s_func <= "100011";
	wait for 100 ns;
	
	--beq
	s_opcode <= "000100";
	s_func <= "000000";
	wait for 100 ns;
	
	--bne
	s_opcode <= "000101";
	s_func <= "000000";
	wait for 100 ns;
	
	--j
	s_opcode <= "000010";
	s_func <= "000000";
	wait for 100 ns;
	
	--jal
	s_opcode <= "000011";
	s_func <= "000000";
	wait for 100 ns;
	
	--jr
	s_opcode <= "000000";
	s_func <= "001000";
	wait for 100 ns;
	
	
end process;
end behavior;