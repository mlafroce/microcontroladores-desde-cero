-- Tipos standard
library IEEE;
use IEEE.std_logic_1164.all;

entity register_file is
  generic (REG_WIDTH: integer := 32);
  generic (REG_NUM: integer := 32);
  generic (REG_NUM_LOG: integer := 5);
  
  port(
    -- Utilizamos una nomenclatura similar a la de MIPS
    -- para los puertos
    -- Entradas
    rs1_selector_i: in std_logic_vector(REG_NUM_LOG - 1 downto 0);
    rs2_selector_i: in std_logic_vector(REG_NUM_LOG - 1 downto 0);
    rdest_selector_i: in std_logic_vector(REG_NUM_LOG - 1 downto 0);
    clk_i: in std_logic;
    en_i: in std_logic;
    write_i: in std_logic;
    rdest_i: in std_logic_vector(REG_WIDTH - 1 downto 0);
    -- Salidas
    rs1_i: out std_logic_vector(REG_WIDTH - 1 downto 0);
    rs2_i: out std_logic_vector(REG_WIDTH - 1 downto 0)
  );
end register_file;

architecture behaviour of register_file is
  signal input_s : array(0 to REG_NUM - 1) of 
    std_logic_vector(REG_WIDTH - 1 downto 0) := (others => '0');
  signal output_s : array(0 to REG_NUM - 1) of 
    std_logic_vector(REG_WIDTH - 1 downto 0) := (others => '0');
  component cpu_register is
    generic (REG_WIDTH: integer);
    port(
      -- Entradas
      data_i: in std_logic_vector(REG_WIDTH - 1 downto 0);
      clk_i: in std_logic;
      en_i: in std_logic;
      write_i: in std_logic;
      -- Salidas
      data_o: out std_logic_vector(REG_WIDTH - 1 downto 0)
    );
  end component cpu_register;
begin
  reg_g: for I in 0 to REG_NUM - 1 generate
    regXinst: cpu_register port map
         (input_s(I), clk_i, en_i, output_s(I));
  end generate reg_g;

  process (clk_i)
  begin
    -- Ejecutar sólo cuando hay flanco ascendente del reloj
    if rising_edge(clk_i) then
    end if; -- end if rising_edge
  end process;

end behaviour;