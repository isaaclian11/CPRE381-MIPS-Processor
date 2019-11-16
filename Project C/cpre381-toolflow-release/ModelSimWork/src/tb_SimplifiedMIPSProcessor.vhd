-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_SimplifiedMIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the 381 MIPS Processor
-- that prints an ordered trace of all writes to architectural registers
-- or the data memory.

-- 02/26/2018 by H3::Design created.
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_textio.ALL; -- For logic types I/O
LIBRARY std;
USE std.env.ALL; -- For hierarchical/external signals
USE std.textio.ALL; -- For basic I/O

--Usually name your testbench similar to below for clarify tb_<name>
ENTITY tb_SimplifiedMIPSProcessor IS
  --Generic for half of the clock cycle period
  GENERIC (
    gCLK_HPER : TIME := 10 ns;
    N : INTEGER := 32);
END tb_SimplifiedMIPSProcessor;

ARCHITECTURE mixed OF tb_SimplifiedMIPSProcessor IS

  --Define the total clock period time
  CONSTANT cCLK_PER : TIME := gCLK_HPER * 2;

  --We will be making an instance of the file that we are testing
  --TODO: Provide the appropriate port declarations for your processor
  COMPONENT MIPS_processor IS
    GENERIC (N : INTEGER);
    PORT (
      iCLK : IN std_logic;
      iRST : IN std_logic;
      iInstLd : IN std_logic;
      iInstAddr : IN std_logic_vector(N - 1 DOWNTO 0);
      iInstExt : IN std_logic_vector(N - 1 DOWNTO 0);
      oALUOut : OUT std_logic_vector(N - 1 DOWNTO 0));
  END COMPONENT;

  -- Create signals for all of the inputs and outputs of the file that you are testing
  -- := '0' or := (others => '0') just make all the signals start at an initial value of zero
  SIGNAL CLK, reset : std_logic := '0';

  SIGNAL alu_out : std_logic_vector(N - 1 DOWNTO 0);

BEGIN

  -- TODO: Make an instance of the component to test and wire all signals to the corresponding
  -- input or output.
  MySimplifiedMIPSProcess : MIPS_processor
  GENERIC MAP(N => N)
  PORT MAP(
    iCLK => CLK,
    iRST => reset,
    iInstLd => '0',
    iInstAddr => "--------------------------------",
    iInstExt => "--------------------------------",
    oALUOut => alu_out);
  --You can also do the above port map in one line using the below format: http://www.ics.uci.edu/~jmoorkan/vhdlref/compinst.html
  --port map(CLK, reset, rs_sel, rt_sel, reg_we, w_addr, reg_dest, immediate, sel_imm, ALU_OP, shamt, mem_we, rs_data, rt_data, ALU_out, dmem_out);

  --This first process is to automate the clock for the test bench
  P_CLK : PROCESS
  BEGIN
    CLK <= '1';
    WAIT FOR gCLK_HPER;
    CLK <= '0';
    WAIT FOR gCLK_HPER;
  END PROCESS;

  -- This process resets the processor.
  P_RST : PROCESS
  BEGIN
    reset <= '0';
    WAIT FOR gCLK_HPER/2;
    reset <= '1';
    WAIT FOR gCLK_HPER * 2;
    reset <= '0';
    WAIT;
  END PROCESS;

  -- Dumps modifications to the state of the processor to trace file
  P_DUMP_STATE : PROCESS (CLK)
    FILE my_dump : TEXT OPEN WRITE_MODE IS "dump.out";
    VARIABLE my_line : LINE;
    VARIABLE cycle_cnt : INTEGER := 0;

    -- Setup hierarchical/external names
    -- Reference for external names: https://www.doulos.com/knowhow/vhdl_designers_guide/vhdl_2008/vhdl_200x_ease/#hierarchicalnames
    ALIAS memWr IS << SIGNAL MySimplifiedMIPSProcess.s_DMemWr : std_logic >> ;
    ALIAS memAddr IS << SIGNAL MySimplifiedMIPSProcess.s_DMemAddr : std_logic_vector(N - 1 DOWNTO 0) >> ;
    ALIAS memData IS << SIGNAL MySimplifiedMIPSProcess.s_DMemData : std_logic_vector(N - 1 DOWNTO 0) >> ;

    ALIAS regWr IS << SIGNAL MySimplifiedMIPSProcess.s_RegWr : std_logic >> ;
    ALIAS regWrAddr IS << SIGNAL MySimplifiedMIPSProcess.s_RegWrAddr : std_logic_vector(4 DOWNTO 0) >> ;
    ALIAS regWrData IS << SIGNAL MySimplifiedMIPSProcess.s_RegWrData : std_logic_vector(N - 1 DOWNTO 0) >> ;

    ALIAS halt IS << SIGNAL MySimplifiedMIPSProcess.s_Halt : std_logic >> ;
  BEGIN

    IF (rising_edge(CLK) AND (reset /= '1')) THEN

      IF (regWr) THEN
        write(my_line, STRING'("In clock cycle: "));
        write(my_line, cycle_cnt);
        writeline(my_dump, my_line);
        write(my_line, STRING'("Register Write to Reg: 0x"));
        hwrite(my_line, regWrAddr);
        write(my_line, STRING'(" Val: 0x"));
        hwrite(my_line, regWrData);
        writeline(my_dump, my_line);
      END IF;
      IF (memWr) THEN
        write(my_line, STRING'("In clock cycle: "));
        write(my_line, cycle_cnt);
        writeline(my_dump, my_line);
        write(my_line, STRING'("Memory Write to Addr: 0x"));
        hwrite(my_line, memAddr);
        write(my_line, STRING'(" Val: 0x"));
        hwrite(my_line, memData);
        writeline(my_dump, my_line);
      END IF;
      cycle_cnt := cycle_cnt + 1;

      IF (halt = '1') THEN
        write(my_line, STRING'("Execution is stopping!"));
        writeline(my_dump, my_line);
        stop(2);
      END IF;
    END IF;
  END PROCESS;

END mixed;