-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------
-- fulladder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Full Adder for CPRE 381 Lab 2 P3b
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY fulladder IS
  PORT (
    i_A : IN std_logic;
    i_B : IN std_logic;
    i_Cin : IN std_logic; -- carry in
    o_Cout : OUT std_logic; -- carry out
    o_Sum : OUT std_logic); -- sum

END fulladder;

ARCHITECTURE structure OF fulladder IS

  COMPONENT xorg2
    PORT (
      i_A : IN std_logic;
      i_B : IN std_logic;
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

  SIGNAL s_X : std_logic; -- xor
  SIGNAL s_y : std_logic; -- and1
  SIGNAL s_Z : std_logic; -- and2

BEGIN

  or1 : org2 PORT MAP(
    i_A => s_Y,
    i_B => s_Z,
    o_F => o_Cout);

  xor1 : xorg2 PORT MAP(
    i_A => i_A,
    i_B => i_B,
    o_F => s_X);

  xor2 : xorg2 PORT MAP(
    i_A => s_X,
    i_B => i_Cin,
    o_F => o_Sum);

  and1 : andg2 PORT MAP(
    i_A => i_A,
    i_B => i_B,
    o_F => s_Y);

  and2 : andg2 PORT MAP(
    i_A => s_X,
    i_B => i_Cin,
    o_F => s_Z);

END structure;