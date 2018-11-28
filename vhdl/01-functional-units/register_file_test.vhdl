-- Tipos standard
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; -- permite usar to_unsigned

entity register_file_test is
end register_file_test;

architecture behaviour of register_file_test is
  -- Señales de prueba
  signal clk_t : std_logic := '0';
  signal en_t : std_logic := '1';
  signal write_t : std_logic := '0';
  signal rs1_selector_t : std_logic_vector(4 downto 0) := "00000";
  signal rs2_selector_t : std_logic_vector(4 downto 0) := "00000";
  signal rdest_selector_t : std_logic_vector(4 downto 0) := "00000";
  signal rdest_t : std_logic_vector(31 downto 0) := (others => '0');

  component register_file is
  generic (
    REG_WIDTH: integer := 32;
    REG_NUM: integer := 32;
    REG_NUM_LOG: integer := 5
  );
  
  port(
    -- Utilizamos una nomenclatura similar a la de MIPS
    -- para los puertos
    -- Entradas
    clk_i: in std_logic;
    en_i: in std_logic;
    write_i: in std_logic;
    rs1_selector_i: in std_logic_vector(REG_NUM_LOG - 1 downto 0);
    rs2_selector_i: in std_logic_vector(REG_NUM_LOG - 1 downto 0);
    rdest_selector_i: in std_logic_vector(REG_NUM_LOG - 1 downto 0);
    rdest_i: in std_logic_vector(REG_WIDTH - 1 downto 0);
    -- Salidas
    rs1_o: out std_logic_vector(REG_WIDTH - 1 downto 0);
    rs2_o: out std_logic_vector(REG_WIDTH - 1 downto 0)
  );
  end component register_file;

begin
  component_inst: register_file
    port map(
    -- Entradas
    rs1_selector_i => rs1_selector_t,
    rs2_selector_i => rs2_selector_t,
    rdest_selector_i => rdest_selector_t,
    clk_i => clk_t,
    en_i => en_t,
    write_i => write_t,
    rdest_i => rdest_t,
    -- Salidas
    rs1_o => open,
    rs2_o => open
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
    variable count_v: integer := 31;
    begin
    wait for 80 ns;
    count_v := count_v - 1;
    if count_v = 0 then
        count_v := 31;
    end if;
    rs1_selector_t <= std_logic_vector(to_unsigned(count_v, rs1_selector_t'length));
  end process;

end architecture ; -- behaviour