-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------
-- registerfile.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: update registerfile for CPRE 381 Lab 4 P3c
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE work.vectorarraytype.ALL;

ENTITY registerfile IS
  PORT (
    i_CLK : IN std_logic; -- clock
    i_RST : IN std_logic; -- reset
    i_rw : IN std_logic; -- register write
    i_rs : IN std_logic_vector(4 DOWNTO 0); -- read address 1
    i_rt : IN std_logic_vector(4 DOWNTO 0); -- read address 2
    i_rd : IN std_logic_vector(4 DOWNTO 0); -- write address
    i_wd : IN std_logic_vector(31 DOWNTO 0); -- write data
    o_rd1 : OUT std_logic_vector(31 DOWNTO 0); -- read data 1
    o_rd2 : OUT std_logic_vector(31 DOWNTO 0)); -- read data 2

END registerfile;

ARCHITECTURE structural OF registerfile IS

  COMPONENT dff_n IS
    GENERIC (N : INTEGER := 32);
    PORT (
      i_CLK : IN std_logic;
      i_RST : IN std_logic;
      i_WE : IN std_logic;
      i_D : IN std_logic_vector(N - 1 DOWNTO 0);
      o_Q : OUT std_logic_vector(N - 1 DOWNTO 0));
  END COMPONENT;

  COMPONENT mux_321_df IS
    PORT (
      i_MuxData : vectorarray;
      i_MuxSel : IN std_logic_vector(4 DOWNTO 0);
      o_MuxOut : OUT std_logic_vector(31 DOWNTO 0));
  END COMPONENT;

  COMPONENT decoder_532_df IS
    PORT (
      i_DecIn : IN std_logic_vector(4 DOWNTO 0);
      o_DecOut : OUT std_logic_vector(31 DOWNTO 0));
  END COMPONENT;

  SIGNAL s_WBits : std_logic_vector(31 DOWNTO 0); -- stores write enable status
  SIGNAL s_Write : std_logic_vector(31 DOWNTO 0); -- Fixed write enables
  SIGNAL s_RegData : vectorarray; -- array of vectors holding our data
BEGIN

  dec1 : decoder_532_df
  PORT MAP(
    i_DecIn => i_rd,
    o_DecOut => s_WBits); -- store bits to write to in s_A

  s_RegData(0) <= x"00000000";
  G1 : FOR i IN 1 TO 31 GENERATE
  BEGIN
    s_Write(i) <= s_WBits(i) AND i_rw;
    dff_i : dff_n
    GENERIC MAP(N => 32)
    PORT MAP(
      i_CLK => i_CLK,
      i_RST => i_RST,
      i_WE => s_Write(i),
      i_D => i_wd,
      o_Q => s_RegData(i));
  END GENERATE;

  mux1 : mux_321_df
  PORT MAP(
    i_MuxData => s_RegData,
    i_MuxSel => i_rs,
    o_MuxOut => o_rd1);

  mux2 : mux_321_df
  PORT MAP(
    i_MuxData => s_RegData,
    i_MuxSel => i_rt,
    o_MuxOut => o_rd2);

END structural;