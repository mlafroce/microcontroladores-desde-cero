-- Tipos standard
library IEEE;
use IEEE.std_logic_1164.all;

-- declaramos una interfaz vacía "hello_logic_test",
-- ya que este componente no necesita entradas ni salidas
entity hello_logic_test is
end hello_logic_test;

architecture behaviour of hello_logic_test is
  -- Instancio señales que voy a ir variando en las pruebas
  signal a_t : std_logic := '0';
  signal b_t : std_logic := '0';
  -- Declaro el componente cuidando que la interfaz sea
  -- la misma que la de la que queremos probar 
  component hello_logic is
    port(
    a_i: in std_logic := '0';
    b_i: in std_logic := '0';
    not_a_o: out std_logic;
    and_o: out std_logic;
    or_o: out std_logic;
    xor_o: out std_logic;
    nand_o: out std_logic;
    nor_o: out std_logic
    );
  end component hello_logic;

-- Una vez declaradas las señales e interfaces de componentes
-- se procede a iniciar la arquitectura.
begin
  -- Instancia del componente a probar
  -- Le asigno a las entradas mis señales de prueba
  component_inst: hello_logic
    port map(
    a_i => a_t,
    b_i => b_t,
    not_a_o => open,
    and_o => open,
    or_o => open,
    xor_o => open,
    nand_o => open,
    nor_o => open
    );

  -- Senales de prueba
  -- Creo un proceso por cada señal, esperando un tiempo fijo
  -- y alternando el valor de la señal en cada ciclo
  process -- a_i process
  begin
  wait for 40 ns;
  a_t <= not a_t;
  end process;

  process -- b_i process
  begin
  wait for 80 ns;
  b_t <= not b_t;
  end process;

end architecture ; -- behaviour