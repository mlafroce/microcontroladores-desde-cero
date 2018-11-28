-- Tipos standard
library IEEE;
use IEEE.std_logic_1164.all;

entity cpu_register is
  -- Establecemos el ancho de la palabra
  -- `generic` me permite utilizar constantes que el usuario
  -- puede ajustar al momento de instanciar el componente.
  -- Se le puede asignar un valor default (en este caso, 32)
  generic (CPU_REG_WIDTH: integer := 32);
  port(
    -- Entradas
    data_i: in std_logic_vector(CPU_REG_WIDTH - 1 downto 0);
    clk_i: in std_logic;
    en_i: in std_logic;
    write_i: in std_logic;
    -- Salidas
    data_o: out std_logic_vector(CPU_REG_WIDTH - 1 downto 0)
  );
end cpu_register;

architecture behaviour of cpu_register is
signal data_s : std_logic_vector
    (CPU_REG_WIDTH - 1 downto 0) := (others => '0');
begin
  process (clk_i)
  begin
    -- Ejecutar sólo cuando hay flanco ascendente del reloj
    if rising_edge(clk_i) then
      if en_i = '1' then
        if write_i = '1' then
          data_s <= data_i;
        end if; -- end if write_i
      end if; -- end if en_i
      data_o <= data_s;
    end if; -- end if rising_edge
  end process;

end behaviour;