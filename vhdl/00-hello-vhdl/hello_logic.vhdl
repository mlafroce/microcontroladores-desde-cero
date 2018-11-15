-- Tipos standard
library IEEE;
use IEEE.std_logic_1164.all;

-- declaramos la interfaz del componente "hello_logic", para referirnos al componente lógico
entity hello_logic is
-- enumeramos los puertos de entrada y salida
  port(
    -- <nombre>: [in/out] [tipo];
    a_i: in std_logic := '0';
    b_i: in std_logic := '0';
    not_a_o: out std_logic;
    and_o: out std_logic;
    or_o: out std_logic;
    xor_o: out std_logic;
    nand_o: out std_logic;
    nor_o: out std_logic
  );
end hello_logic;

architecture behaviour of hello_logic is
begin
    -- salida <= entradas + funciones lógicas;
    not_a_o <= not a_i;
    and_o <= a_i and b_i;
    or_o <= a_i or b_i;
    xor_o <= a_i xor b_i;
    nand_o <= a_i nand b_i;
    nor_o <= a_i nor b_i;
end behaviour;