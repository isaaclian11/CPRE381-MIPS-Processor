-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------
-- addsub_n_st.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Structural n-bit adder/subtractor for CPRE 381 Lab 2 P4b
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY addsub_n_st IS
  GENERIC (N : INTEGER := 1);
  PORT (
    i_A : IN std_logic_vector(N - 1 DOWNTO 0);
    i_B : IN std_logic_vector(N - 1 DOWNTO 0);
    i_nAdd_Sub : IN std_logic; -- carry in
    o_Cout : OUT std_logic; -- carry out
    o_Sum : OUT std_logic_vector(N - 1 DOWNTO 0)); -- sum

END addsub_n_st;

ARCHITECTURE structure OF addsub_n_st IS

  COMPONENT fulladder_n_st IS
    GENERIC (N : INTEGER := 1);
    PORT (
      i_A : IN std_logic_vector(N - 1 DOWNTO 0);
      i_B : IN std_logic_vector(N - 1 DOWNTO 0);
      i_Cin : IN std_logic; -- carry in
      o_Cout : OUT std_logic; -- carry out
      o_Sum : OUT std_logic_vector(N - 1 DOWNTO 0)); -- sum
  END COMPONENT;

  COMPONENT mux21_n_st IS
    GENERIC (N : INTEGER := 1);
    PORT (
      i_A : IN std_logic_vector(N - 1 DOWNTO 0);
      i_B : IN std_logic_vector(N - 1 DOWNTO 0);
      i_S : IN std_logic;
      o_F : OUT std_logic_vector(N - 1 DOWNTO 0));
  END COMPONENT;

  COMPONENT ones_complementer IS
    GENERIC (N : INTEGER := 1);
    PORT (
      i_A : IN std_logic_vector(N - 1 DOWNTO 0);
      o_F : OUT std_logic_vector(N - 1 DOWNTO 0));
  END COMPONENT;

  SIGNAL s_A : std_logic_vector(N - 1 DOWNTO 0); -- output from inverter, input to mux in b
  SIGNAL s_B : std_logic_vector(N - 1 DOWNTO 0); -- output from mux, input to adder in b

BEGIN

  fa_st : fulladder_n_st
  PORT MAP(
    i_A => i_A,
    i_B => s_B,
    i_Cin => i_nAdd_Sub,
    o_Cout => o_Cout,
    o_Sum => o_Sum);

  mux_st : mux21_n_st
  PORT MAP(
    i_A => i_B,
    i_B => s_A,
    i_S => i_nAdd_Sub,
    o_F => s_B);

  oc_st : ones_complementer
  PORT MAP(
    i_A => i_B,
    o_F => s_A);

END structure;