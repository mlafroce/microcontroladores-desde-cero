-- Tipos standard
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; -- permite usar to_unsigned
use work.common.all;

entity register_file_muxed is
  generic (
    REG_WIDTH: integer := 8;
    REG_NUM: integer := 4
  );
  
  port(
    -- Utilizamos una nomenclatura similar a la de MIPS
    -- para los puertos
    -- Entradas
    rs1_selector_i: in integer range 0 to REG_NUM;
    rs2_selector_i: in integer range 0 to REG_NUM;
    rdest_selector_i: in integer range 0 to REG_NUM;
    clk_i: in std_logic;
    en_i: in std_logic;
    write_i: in std_logic;
    rdest_i: in std_logic_vector(REG_WIDTH - 1 downto 0);
    -- Salidas
    rs1_o: out std_logic_vector(REG_WIDTH - 1 downto 0);
    rs2_o: out std_logic_vector(REG_WIDTH - 1 downto 0)
  );
end register_file_muxed;


architecture muxed of register_file_muxed is
  component cpu_register is
    generic (
      CPU_REG_WIDTH: integer := REG_WIDTH
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
  component mux is
    port(
      -- Entradas
      data_i: in mux_input_type;
      data_selector_i: in integer range 0 to MUX_NUM_INPUTS - 1;
      -- Salidas
      data_o: out std_logic_vector(MUX_INPUT_WIDTH - 1 downto 0)
    );
  end component mux;
  signal input_s : mux_input_type := (others => (others => '0'));
  signal output_s : mux_input_type := (others => (others => '0'));
  signal rs1_s: std_logic_vector(REG_WIDTH - 1 downto 0);
  signal rs2_s: std_logic_vector(REG_WIDTH - 1 downto 0);
begin
  rs1_mux: mux
    port map
      (output_s, rs1_selector_i, rs1_s);
  rs2_mux: mux
    port map
      (output_s, rs2_selector_i, rs2_s);
  --rdest_mux: mux
    --port map
      --(input_s, rdest_selector_i, rdest_i);
  reg_g: for I in 0 to REG_NUM - 1 generate
    regXinst: cpu_register
      port map
        (input_s(I), clk_i, en_i, write_i, output_s(I));
  end generate reg_g;

  process (clk_i)
  begin
    -- Ejecutar sólo cuando hay flanco ascendente del reloj
    if rising_edge(clk_i) then
      input_s(rdest_selector_i) <= rdest_i;
    end if; -- end if rising_edge
  end process;
  rs1_o <= rs1_s;
  rs2_o <= rs2_s;

end architecture;