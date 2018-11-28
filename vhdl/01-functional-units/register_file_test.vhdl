-- Tipos standard
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; -- permite usar to_unsigned

entity register_file_test is
end register_file_test;

architecture behaviour of cpu_register_test is
  -- Señales de prueba
  signal input_t : std_logic_vector(3 downto 0) := "0000";
  signal clk_t : std_logic := '0';
  signal en_t : std_logic := '1';
  signal write_t : std_logic := '0';
  
  component cpu_register is
    generic (WIDTH: integer);
    port(
      -- Entradas
      data_i: in std_logic_vector(WIDTH - 1 downto 0);
      clk_i: in std_logic;
      en_i: in std_logic;
      write_i: in std_logic;
      -- Salidas
      data_o: out std_logic_vector(WIDTH - 1 downto 0)
    );
  end component cpu_register;

begin
  component_inst: cpu_register
    generic map(WIDTH => 4) 
    port map(
    -- Entradas
    data_i => input_t,
    en_i => en_t,
    clk_i => clk_t,
    write_i => write_t,
    -- Salidas
    data_o => open
    );

  -- Señales de prueba
  -- Creo un proceso por cada señal, esperando un tiempo fijo
  -- y alternando el valor de la señal en cada ciclo
  process -- clk_t process
  begin
  wait for 20 ns;
  clk_t <= not clk_t;
  end process;

  process -- wr_t process
  begin
  wait for 240 ns;
  write_t <= not write_t;
  end process;

  process -- input_t process
    variable count_v: integer := 15;
    begin
    wait for 80 ns;
    count_v := count_v - 1;
    if count_v = 0 then
        count_v := 15;
    end if;
    input_t <= std_logic_vector(to_unsigned(count_v, input_t'length));
  end process;

end architecture ; -- behaviour