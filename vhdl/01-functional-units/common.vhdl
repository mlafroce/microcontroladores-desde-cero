library IEEE;
use IEEE.std_logic_1164.all;

package common is

-- Types
  type mux_input_type is array(0 to 3) of std_logic_vector(7 downto 0);
-- Constantes
  constant MUX_INPUT_WIDTH : integer := 8;
  constant MUX_NUM_INPUTS : integer := 4;

end common;
