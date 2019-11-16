-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------
-- addsub_n_st_new.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Structural n-bit adder/subtractor for CPRE 381 Lab 3 P2a
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY addsub_n_st_new IS
  GENERIC (N : INTEGER := 32);
  PORT (
    i_A : IN std_logic_vector(N - 1 DOWNTO 0);
    i_B : IN std_logic_vector(N - 1 DOWNTO 0);
    i_nAdd_Sub : IN std_logic;
    i_ALUSrc : IN std_logic;
    i_immediate : IN std_logic_vector(N - 1 DOWNTO 0);
    o_Cout : OUT std_logic; -- carry out
    o_Sum : OUT std_logic_vector(N - 1 DOWNTO 0)); -- sum

END addsub_n_st_new;

ARCHITECTURE structure OF addsub_n_st_new IS

  COMPONENT addsub_n_st IS
    GENERIC (N : INTEGER := 32);
    PORT (
      i_A : IN std_logic_vector(N - 1 DOWNTO 0);
      i_B : IN std_logic_vector(N - 1 DOWNTO 0);
      i_nAdd_Sub : IN std_logic; -- carry in
      o_Cout : OUT std_logic; -- carry out
      o_Sum : OUT std_logic_vector(N - 1 DOWNTO 0)); -- sum

  END COMPONENT;

  COMPONENT mux21_n_st IS
    GENERIC (N : INTEGER := 32);
    PORT (
      i_A : IN std_logic_vector(N - 1 DOWNTO 0);
      i_B : IN std_logic_vector(N - 1 DOWNTO 0);
      i_S : IN std_logic;
      o_F : OUT std_logic_vector(N - 1 DOWNTO 0));
  END COMPONENT;

  SIGNAL s_A : std_logic_vector(N - 1 DOWNTO 0);

BEGIN

  as_st : addsub_n_st
  PORT MAP(
    i_A => i_A,
    i_B => s_A,
    i_nAdd_Sub => i_nAdd_Sub,
    o_Cout => o_Cout,
    o_Sum => o_Sum);

  mux_st : mux21_n_st
  PORT MAP(
    i_A => i_B,
    i_B => i_immediate,
    i_S => i_ALUSrc,
    o_F => s_A);

END structure;