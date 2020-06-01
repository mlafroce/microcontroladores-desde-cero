-- Tipos standard
library IEEE;
use IEEE.std_logic_1164.all;

entity single_register is
  generic (N: integer := 32); -- Me permite asignar una longitud configurable
  port (
    reg_i : in std_logic_vector(N-1 downto 0); -- entrada
    reg_o : out std_logic_vector(N-1 downto 0) := (others => '0'); -- salida
    write_enable_i : in std_logic;
    clk_i : in std_logic
  );
end single_register;

architecture behaviour of single_register is

begin
clk_process : process(clk_i) is
  begin
    if rising_edge(clk_i) then -- si hay flanco ascendente
      if write_enable_i = '1' then
        reg_o <= reg_i;
      end if;
    end if; -- if rising_edge
  end process clk_process;
end behaviour;
