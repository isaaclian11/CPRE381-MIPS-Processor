-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------
-- mux21_n_st.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Structural 2-1 n-bit mux for CPRE 381 Lab 2 P2c
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY mux21_n_st IS
  GENERIC (N : INTEGER := 1);
  PORT (
    i_A : IN std_logic_vector(N - 1 DOWNTO 0);
    i_B : IN std_logic_vector(N - 1 DOWNTO 0);
    i_S : IN std_logic;
    o_F : OUT std_logic_vector(N - 1 DOWNTO 0));

END mux21_n_st;

ARCHITECTURE structure OF mux21_n_st IS

  COMPONENT invg
    PORT (
      i_A : IN std_logic;
      o_F : OUT std_logic);
  END COMPONENT;

  COMPONENT andg2
    PORT (
      i_A : IN std_logic;
      i_B : IN std_logic;
      o_F : OUT std_logic);
  END COMPONENT;

  COMPONENT org2
    PORT (
      i_A : IN std_logic;
      i_B : IN std_logic;
      o_F : OUT std_logic);
  END COMPONENT;

  SIGNAL s_X : std_logic_vector(N - 1 DOWNTO 0);
  SIGNAL s_y : std_logic_vector(N - 1 DOWNTO 0);
  SIGNAL s_Z : std_logic_vector(N - 1 DOWNTO 0);

BEGIN

  G1 : FOR i IN 0 TO N - 1 GENERATE
    and1_i : andg2 PORT MAP(i_A(i), s_X(i), s_Y(i));
    and2_i : andg2 PORT MAP(i_S, i_B(i), s_Z(i));
    or2_i : org2 PORT MAP(s_Y(i), s_Z(i), o_F(i));
    not1_i : invg PORT MAP(i_S, s_X(i));
  END GENERATE;

END structure;