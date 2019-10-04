-------------------------------------------------------------------------
-- Aidan Sherburne
-- Iowa State University
-------------------------------------------------------------------------


-- vectorarraytype.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: File defining an array of std_logic_vectors
-- REF: https://nandland.com/vhdl/examples/example-array-type-vhdl.html
-- REF: https://stackoverflow.com/questions/48651087/use-a-type-from-a-different-package-in-vhdl
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package vectorarraytype is
  type vectorarray is array (0 to 31) of std_logic_vector(31 downto 0);
  
end package vectorarraytype;
