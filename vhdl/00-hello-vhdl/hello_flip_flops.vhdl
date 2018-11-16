-- Tipos standard
library IEEE;
use IEEE.std_logic_1164.all;

entity hello_flip_flops is
-- enumeramos los puertos de entrada y salida
  port(
    -- <nombre>: [in/out] [tipo];
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
end hello_flip_flops;

architecture behaviour of hello_flip_flops is
-- El estado Q de cada flip flop
signal rs_status : std_logic := '0';
signal jk_status : std_logic := '0';
signal t_status : std_logic := '0';
signal d_status : std_logic := '0';
begin
  process (clk_i)
  -- Armo este vector para usar en el case
  variable input_v: std_logic_vector(0 to 1);
  begin
    -- Ejecutar sólo cuando hay flanco ascendente del reloj
    if rising_edge(clk_i) then
      -- Asigno los valores a mi vector de entradas
      input_v := a_i & b_i; 
      -- En vez de calcular la lógica combinacional de las
      -- distintas tablas de verdad, utilizamos un `case`
      case input_v is
        when "00" => -- a_i = 0, b_i = 0
          -- Vamos por la implementación con compuertas NOR
          -- La siguiente linea es innecesaria
          rs_status <= rs_status;
          jk_status <= '0';
        when "01" => -- a_i = 0, b_i = 1
          -- r = 0, s = 1
          rs_status <= '1';
          -- j = 0, k = 1
          jk_status <= '1';
          -- Utilizamos b_i como puerto de enable
          d_status <= '0';
        when "10" => -- a_i = 1, b_i = 0
          -- r = 1, s = 0
          rs_status <= '0';
          -- j = 1, k = 0
          jk_status <= '0';
        when "11" => -- a_i = 1, b_i = 1
          -- En los RS (NOR), 11 es un estado no deseado
          rs_status <= 'X';
          jk_status <= not jk_status;
          d_status <= '1';
          t_status <= not t_status;
        -- En los casos especiales, como X (indeterminado), no hago nada
        when others => null;
      end case;
      -- Asigno las señales a salidas
      rs_o <= rs_status;
      jk_o <= jk_status;
      t_o <= t_status;
      d_o <= d_status;
    end if; -- end if rising_edge
  end process;

end behaviour;