-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------


-- newprocessor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: processor for CPRE 381 Lab 4 P3c
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.vectorarraytype.all;

entity newprocessor is
  port(i_CLK : in std_logic; -- clock
       i_RST : in std_logic; -- reset
       i_rs : in std_logic_vector(4 downto 0);  -- read address 1
	   i_rt : in std_logic_vector(4 downto 0);  -- read address 2
	   i_rd : in std_logic_vector(4 downto 0);  -- write address
	   i_nAdd_Sub : in std_logic;
	   i_ALUSrc : in std_logic;
	   i_immediate : in std_logic_vector(15 downto 0);
	   i_RegWrite : in std_logic;
	   i_MemWrite : in std_logic;
	   i_DataSel : in std_logic;
	   i_SignCtrl : in std_logic);

end newprocessor;

architecture structural of newprocessor is

component registerfile is
  port(i_CLK : in std_logic; -- clock
       i_RST : in std_logic; -- reset
	   i_rw  : in std_logic; -- read/write toggle
       i_rs  : in std_logic_vector(4 downto 0);  -- read address 1
	   i_rt  : in std_logic_vector(4 downto 0);  -- read address 2
	   i_rd  : in std_logic_vector(4 downto 0);  -- write address
	   i_wd  : in std_logic_vector(31 downto 0);  -- write data
	   o_rd1 : out std_logic_vector(31 downto 0);  -- read data 1
	   o_rd2 : out std_logic_vector(31 downto 0)); -- read data 2

end component;

component addsub_n_st_new is
  generic(N : integer := 32);
  port(i_A : in std_logic_vector(N-1 downto 0);
       i_B : in std_logic_vector(N-1 downto 0);
       i_nAdd_Sub : in std_logic;
	   i_ALUSrc : in std_logic;
	   i_immediate : in std_logic_vector(N-1 downto 0);
	   o_Cout : out std_logic; -- carry out
       o_Sum : out std_logic_vector(N-1 downto 0)); -- sum

end component;

component mux21_n_df is
  generic(N : integer := 14);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       i_B  : in std_logic_vector(N-1 downto 0);
       i_S  : in std_logic;
       o_F  : out std_logic_vector(N-1 downto 0));

end component;

component extender is
  generic(N : integer := 8);
  port(i_A  : in std_logic_vector(N-1 downto 0); -- input vector
       i_B  : in std_logic; -- sign control bit
       o_Z  : out std_logic_vector(31 downto 0)); -- output extension

end component;

component mem is
	generic (
		DATA_WIDTH : natural := 32;
		ADDR_WIDTH : natural := 10);
	port (
		clk		: in std_logic;
		addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
		data	        : in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0));

end component;

signal s_rd1 : std_logic_vector(31 downto 0);  -- read data 1
signal s_rd2 : std_logic_vector(31 downto 0); -- read data 2
signal s_ALUOut : std_logic_vector(31 downto 0); -- ALU to mux/memory
signal s_MuxOut : std_logic_vector(31 downto 0); -- mux to register data
signal s_ExtOut : std_logic_vector(31 downto 0); -- Extender to ALU
signal s_Q : std_logic_vector(31 downto 0); -- q to mux
signal s_Cout : std_logic;

begin

dmem : mem
  generic map (ADDR_WIDTH => 12)
  port map (clk => i_CLK,
            addr => s_ALUOut(13 downto 2),
			data => s_rd2,
			we => i_MemWrite,
			q => s_Q);

ex : extender
  generic map (N => 16)
  port map (i_A => i_immediate,
            i_B => i_SignCtrl,
			o_Z => s_ExtOut);

rf : registerfile
  port map (i_CLK => i_CLK,
            i_RST => i_RST,
			i_rw => i_RegWrite,
            i_rs => i_rs,
	        i_rt => i_rt,
	        i_rd => i_rd,
	        i_wd => s_MuxOut,
	        o_rd1 => s_rd1,
	        o_rd2 => s_rd2);
			
datamux : mux21_n_df
  generic map (N => 32)
  port map (i_A => s_ALUOut,
            i_B => s_Q,
			i_S => i_DataSel,
			o_F => s_MuxOut);

alu : addsub_n_st_new
  port map (i_A => s_rd1,
            i_B => s_rd2,
			i_nAdd_Sub => i_nAdd_Sub,
            i_ALUSrc => i_ALUSrc,
			i_immediate => s_ExtOut,
			o_Cout => s_Cout,
			o_Sum => s_ALUOut);

end structural;