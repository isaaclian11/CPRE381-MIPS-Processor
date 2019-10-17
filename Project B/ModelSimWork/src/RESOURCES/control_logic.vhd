library IEEE;
use IEEE.std_logic_1164.all;

entity control_logic is
port(
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
	jal		:	out std_logic;
	lui			:	out std_logic;
	shamt		:	out std_logic
);
end control_logic;

architecture dataflow of control_logic is

begin

process(opcode, func)
begin
	--R Instructions
	if(opcode = "000000") then
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
		case func is
			--add 
			when "100000" =>
				ALUControl <= "0000";
			--addu
			when "100001" =>
				ALUControl <= "0000";
				i_unsigned <= '1';
			--and
			when "100100" =>
				ALUControl <= "0011";
			--nor
			when "100111" =>
				ALUControl <= "0111";
			--xor
			when "100110" =>
				ALUControl <= "0101";
			--or 
			when "100101" =>
				ALUControl <= "0100";
			--slt
			when "101010" =>
				ALUControl <= "0010";
			--sltu
			when "101011" =>
				ALUControl <= "0010";
				i_unsigned <= '1';
			--sll
			when "000000" =>
				ALUControl <= "1011";
				shamt <= '1';
			--srl 
			when "000010" =>
				ALUControl <= "1010";
				shamt <= '1';
			--sra
			when "000011" =>
				ALUControl <= "1000";
				shamt <= '1';
			--sllv
			when "000100" =>
				ALUControl <= "1011";
			--srlv
			when "000110" =>
				ALUControl <= "1010";
			--srav
			when "000111" =>
				ALUControl <= "1000";
			--sub
			when "100010" =>
				ALUControl <= "0001";
			--subu
			when "100011" =>
				ALUControl <= "0001";
				i_unsigned <= '1';
			--jr 
			when "001000" =>
				ALUControl <= "0000";
				jr	<= '1';
				regWrite <= '0';
			when others =>
		end case;
		
	--addi
	elsif(opcode = "001000") then
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
	elsif(opcode = "001001") then
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
	elsif(opcode = "001100") then 
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
	elsif(opcode = "001111")then 
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
	elsif(opcode = "100011") then
		ALUSrc <= '1';
		beq <= '0'; 
		bne <= '0';
		jal <= '0';
		jump <= '0';
		memToReg <= '1';
		memWrite <= '0';
		regWrite <= '1';
		regDst <= '1';
		i_unsigned <= '0';
		jr <= '0';
		lui <= '0';
		ALUControl <= "0000";
		shamt <= '0';
		
	--xori
	elsif(opcode = "001110") then
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
	elsif(opcode = "001101") then
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
	elsif(opcode = "001010") then
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
	elsif(opcode = "001011") then
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
	elsif(opcode = "101011") then 
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
	elsif(opcode = "000100") then
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
	elsif(opcode = "000101") then
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
	elsif(opcode = "000010") then
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
	elsif(opcode = "000011") then
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
end if;
end process;
end dataflow;
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				