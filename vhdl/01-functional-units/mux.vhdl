-- Tipos standard
library IEEE;
use IEEE.std_logic_1164.all;
use work.common.all;

entity mux is
  port(
    -- Entradas
    data_i: in mux_input_type;
    data_selector_i: in integer range 0 to MUX_NUM_INPUTS - 1;
    -- Salidas
    data_o: out std_logic_vector(MUX_INPUT_WIDTH - 1 downto 0)
  );
end mux;

architecture behaviour of mux is
begin
  data_o <= data_i(data_selector_i);
end behaviour;