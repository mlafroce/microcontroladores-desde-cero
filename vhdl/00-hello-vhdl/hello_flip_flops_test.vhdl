-- Tipos standard
library IEEE;
use IEEE.std_logic_1164.all;

-- declaramos una interfaz vacía "hello_flip_flops_test",
-- ya que este componente no necesita entradas ni salidas
entity hello_flip_flops_test is
end hello_flip_flops_test;

architecture behaviour of hello_flip_flops_test is
  -- Instancio señales que voy a ir variando en las pruebas
  signal a_t : std_logic := '0';
  signal b_t : std_logic := '0';
  signal clk_t : std_logic := '0';
  -- Declaro el componente cuidando que la interfaz sea
  -- la misma que la de la que queremos probar 
  component hello_flip_flops is
    port(
    -- Entradas
    a_i: in std_logic := '0';
    b_i: in std_logic := '0';
    clk_i: in std_logic;
    -- Salidas
    rs_o: out std_logic;
    jk_o: out std_logic;
    t_o: out std_logic;
    d_o: out std_logic
    );
  end component hello_flip_flops;

-- Una vez declaradas las señales e interfaces de componentes
-- se procede a iniciar la arquitectura.
begin
  -- Instancia del componente a probar
  -- Le asigno a las entradas mis señales de prueba
  component_inst: hello_flip_flops
    port map(
    -- Entradas
    a_i => a_t,
    b_i => b_t,
    clk_i => clk_t,
    -- Salidas
    rs_o => open,
    jk_o => open,
    t_o => open,
    d_o => open
    );

  -- Señales de prueba
  -- Creo un proceso por cada señal, esperando un tiempo fijo
  -- y alternando el valor de la señal en cada ciclo
  process -- clk_t process
  begin
  wait for 20 ns;
  clk_t <= not clk_t;
  end process;

  process -- a_t process
  begin
  wait for 40 ns;
  a_t <= not a_t;
  end process;

  process -- b_t process
  begin
  wait for 80 ns;
  b_t <= not b_t;
  end process;

end architecture ; -- behaviour