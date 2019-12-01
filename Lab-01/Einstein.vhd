-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------


-- Einstein.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of Einstein's
-- energy/mass equation E = mc^2
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity Einstein is

  port(iCLK             : in std_logic;
  -- Input m
       iM 		            : in integer;
  -- Output E
       oE 		            : out integer);

end Einstein;

architecture structure of Einstein is

  component Multiplier
    port(iCLK           : in std_logic;
         iA             : in integer;
         iB             : in integer;
         oC             : out integer);
  end component;

  -- Constant for the value of c in Einstein's equation
  constant cA : integer := 9487;

  -- Signals to store c^2
  signal sVALUE_C2 : integer;

begin
  
  ---------------------------------------------------------------------------
  -- Level 1: Calculate c^2
  ---------------------------------------------------------------------------
  g_Mult1: Multiplier
    port MAP(iCLK             => iCLK,
             iA               => cA,
             iB               => cA,
             oC               => sVALUE_C2);

 ---------------------------------------------------------------------------
  -- Level 2: Calculate m*c^2
  ---------------------------------------------------------------------------
  g_Mult2: Multiplier
    port MAP(iCLK             => iCLK,
             iA               => sVALUE_C2,
             iB               => iM,
             oC               => oE);
  
end structure;