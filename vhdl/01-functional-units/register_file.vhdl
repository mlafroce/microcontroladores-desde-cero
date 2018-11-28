-- Tipos standard
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; -- permite usar to_unsigned

entity register_file is
  generic (
    REG_WIDTH: integer := 32;
    REG_NUM: integer := 32;
    REG_NUM_LOG: integer := 5
  );
  
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
    rs1_o: out std_logic_vector(REG_WIDTH - 1 downto 0);
    rs2_o: out std_logic_vector(REG_WIDTH - 1 downto 0)
  );
end register_file;

architecture behaviour of register_file is
  type reg_mux_type is array(0 to REG_NUM - 1) of 
    std_logic_vector(REG_WIDTH - 1 downto 0);
  signal input_s : reg_mux_type := (others => (others => '0'));
  signal output_s : reg_mux_type := (others => (others => '0'));
  component cpu_register is
    generic (
      CPU_REG_WIDTH: integer := 32
    );
    port(
      -- Entradas
      data_i: in std_logic_vector(CPU_REG_WIDTH - 1 downto 0);
      clk_i: in std_logic;
      en_i: in std_logic;
      write_i: in std_logic;
      -- Salidas
      data_o: out std_logic_vector(CPU_REG_WIDTH - 1 downto 0)
    );
  end component cpu_register;
begin
  reg_g: for I in 0 to REG_NUM - 1 generate
    regXinst: cpu_register
     port map
         (input_s(I), clk_i, en_i, write_i, output_s(I));
  end generate reg_g;

  process (clk_i)
  begin
    -- Ejecutar sólo cuando hay flanco ascendente del reloj
    if rising_edge(clk_i) then
      input_s(to_integer(unsigned(rdest_i))) <= rdest_i;
      rs1_o <= output_s(to_integer(unsigned(rs1_selector_i)));
      rs2_o <= output_s(to_integer(unsigned(rs2_selector_i)));
    end if; -- end if rising_edge
  end process;

end behaviour;