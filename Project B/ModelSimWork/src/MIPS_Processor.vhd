-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

entity MIPS_Processor is
  generic(N : integer := 32);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal v0             : std_logic_vector(N-1 downto 0); -- TODO: should be assigned to the output of register 2, used to implement the halt SYSCALL
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. This case happens when the syscall instruction is observed and the V0 register is at 0x0000000A. This signal is active high and should only be asserted after the last register and memory writes before the syscall are guaranteed to be completed.

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;
	
  component registerfile is
	port(i_CLK : in std_logic; -- clock
       i_RST : in std_logic; -- reset
	   i_rw  : in std_logic; -- register write
       i_rs  : in std_logic_vector(4 downto 0);  -- read address 1
	   i_rt  : in std_logic_vector(4 downto 0);  -- read address 2
	   i_rd  : in std_logic_vector(4 downto 0);  -- write address
	   i_wd  : in std_logic_vector(31 downto 0);  -- write data
	   o_rd1 : out std_logic_vector(31 downto 0);  -- read data 1
	   o_rd2 : out std_logic_vector(31 downto 0)); -- read data 2
	end component;
	
  component mux21_n_st
	generic(N : integer);
	port(i_A  : in std_logic_vector(N-1 downto 0);
       i_B  : in std_logic_vector(N-1 downto 0);
       i_S  : in std_logic;
       o_F  : out std_logic_vector(N-1 downto 0));
	end component;
	
  component extender
	generic(N : integer);
	port(i_A  : in std_logic_vector(N-1 downto 0); -- input vector
       i_B  : in std_logic; -- sign control bit
       o_Z  : out std_logic_vector(31 downto 0)); -- output extension
	end component;
	
  component control_logic
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
	end component;
	
  component reg
	generic (N : integer);                  -- Size of the register
	port (D      : in  std_logic_vector(N-1 downto 0);  -- Data input
        Q      : out std_logic_vector(N-1 downto 0);  -- Data output
        WE     : in  std_logic;                  -- Write enableenable
        reset  : in  std_logic;                  -- The clock signal
        clock  : in  std_logic);                 -- The reset signal
	end component;
	
  component ALU32
	port(i_A  : in std_logic_vector(N-1 downto 0);
       i_B  : in std_logic_vector(N-1 downto 0);
	   i_sel  : in std_logic_vector(3 downto 0); -- operation select
	   i_unsigned  : in std_logic; -- determines if math is signed/unsigned
	   i_shiftamount : in std_logic_vector(4 downto 0); --shift amount
	   o_Cout  : out std_logic; -- carry out
       o_result  : out std_logic_vector(N-1 downto 0); -- result F
	   o_overflow : out std_logic;
	   o_Zero : out std_logic);

	end component;
	
  -- Control flow signals 
  signal s_ALUSrc, s_iUnsigned, s_shamt, s_memToReg, s_regDst, s_pcPlus, s_jump, s_bne, s_beq, s_jal, s_jr, s_lui : std_logic;
  
  -- Other signals
  signal s_mux2, s_mux3, s_mux4, s_shiftedSignExtend, s_iMux8, s_iPC, s_oExtend, s_oRs, i_mux3, s_mux5, s_pcPlusFour, s_iMux6, s_mux7 : std_logic_vector(N-1 downto 0);
  signal s_Cout, s_overflow, s_zero, s_branch : std_logic;
  signal s_ALUControl : std_logic_vector(3 downto 0);
  signal s_mux0, s_shiftAmount : std_logic_vector(4 downto 0);
  
begin

  i_mux3 <= "000000000000000000000000000" & s_Inst(10 downto 6);

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  IMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
			 
  mux0: mux21_n_st
	generic map(N => 5)
	port map(
		i_A => s_Inst(20 downto 16),
		i_B => s_Inst(15 downto 11),
		i_S => s_regDst,
		o_F => s_mux0
	);
  
  mux1: mux21_n_st
	generic map (N => 5)
	port map(
		i_A => s_mux0,
		i_B => "11111",
		i_S => s_jal,
		o_F => s_RegWrAddr
	);
	
  regFile: registerfile
	port map(
		i_CLK => iCLK,
		i_RST => iRST,
		i_rw  => s_RegWr,
		i_rs  => s_Inst(25 downto 21),
		i_rt  => s_Inst(20 downto 16),
		i_rd  => s_RegWrAddr,
		i_wd  => s_RegWrData,
		o_rd1 => s_oRs,
		o_rd2 => s_DMemData
	);
	
  signExtend: extender
	generic map(N => 16)
	port map (
		i_A => s_Inst(15 downto 0),
		i_B => '0',
		o_Z => s_oExtend
	);
	
  control: control_logic
	port map(
		opcode	=> s_Inst(31 downto 26),
		func	=> s_Inst(5 downto 0),
		regDst	=> s_regDst,
		jump	=> s_jump,
		jr		=> s_jr,
		beq		=> s_beq,
		bne		=> s_bne,
		memToReg=> s_memToReg,
		ALUControl	=> s_ALUControl,
		memWrite	=> s_DMemWr,
		ALUSrc		=> s_ALUSrc,
		regWrite	=> s_RegWr,
		i_unsigned	=> s_iUnsigned,
		jal		=> s_jal,
		lui			=> s_lui,
		shamt		=> s_shamt
		);
	
  mux2: mux21_n_st
	generic map (N => N)
	port map(
		i_A => s_DMemData,
		i_B => s_oExtend,
		i_S => s_ALUSrc,
		o_F => s_mux2
	);
  
  mux3: mux21_n_st
	generic map (N => N)
	port map(
		i_A => i_mux3,
		i_B => s_DMemData,
		i_S => s_shamt,
		o_F => s_mux3
	);
	
  ALU: ALU32
	port map(
	   i_A  => s_oRs,
       i_B  => s_mux2,
	   i_sel  => s_ALUControl,
	   i_unsigned  => s_iUnsigned,
	   i_shiftamount => s_shiftAmount,
	   o_Cout  => s_Cout,
       o_result  => s_DMemAddr,
	   o_overflow => s_overflow,
	   o_Zero => s_zero
	);
	
	
  DMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);
			 
  mux4: mux21_n_st
	generic map (N => N)
	port map(
		i_A => s_DMemAddr,
		i_B => s_DMemOut,
		i_S => s_memToReg,
		o_F => s_mux4
	);
	
  mux5: mux21_n_st
	generic map (N => N)
	port map(
		i_A => s_mux4,
		i_B => s_pcPlusFour,
		i_S => s_jal,
		o_F => s_mux5
	);

  mux6: mux21_n_st
	generic map (N => N)
	port map(
		i_A => s_mux4,
		i_B => s_iMux6,
		i_S => s_lui,
		o_F => s_RegWrData
	);
	
	
  mux7: mux21_n_st
	generic map (N => N)
	port map(
		i_A => s_pcPlusFour,
		i_B => s_shiftedSignExtend,
		i_S => s_branch,
		o_F => s_mux7
	);
	
  mux8: mux21_n_st
	generic map (N => N)
	port map(
		i_A => s_mux7,
		i_B => s_iMux8,
		i_S => s_jump,
		o_F => s_iPC
	);
	
  pc: reg
	generic map(N => N)             
	port map(D => s_iPC,
        Q => s_NextInstAddr,
        WE => '1',
        reset => iRST,
        clock  => iCLK);              
	
  ExitReg: reg
	generic map(N => N)
	port map(D=>s_RegWrData,
			WE=>'1',
			clock=>iCLK,
			reset=>'0',
			Q=>v0);
	
  --Since the output of mux3 is 32 bits, we need this condition to handle the shift amount
  s_shiftAmount <= "11111" when s_mux3 > x"001F" else s_mux3(4 downto 0);
  
  oALUOut <= s_DMemAddr;
  
  --PC+4
  s_pcPlusFour <= std_logic_vector(to_unsigned(to_integer(unsigned( s_NextInstAddr )) + 4, 32));
  
  --Branch
  s_branch <= (s_zero and s_beq) or ((not s_zero) and s_bne);
  
  --Sign extend shifted left by 2
  s_shiftedSignExtend <= s_oExtend(29 downto 0) & "00";
	
  --PC+4[31..28] & s_Inst(26 downto 0) shifted left by 2
  s_iMux8 <= s_pcPlusFour(31 downto 28) & s_Inst(25 downto 0) & "00";
  
  --i_B for mux6
  s_iMux6 <= "0000000000000000" & s_Inst(15 downto 0);
  
  s_Halt <='1' when (s_Inst(31 downto 26) = "000000") and (s_Inst(5 downto 0) = "001100") and (v0 = "00000000000000000000000000001010") else '0';


end structure;
