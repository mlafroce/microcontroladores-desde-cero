-- Tipos standard
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity proto_cpu is
  generic (N: integer := 32); -- Me permite asignar una longitud configurable
  port (
    reg_o : out std_logic_vector(N-1 downto 0) := (others => '0'); -- salida
    write_enable_i : in std_logic;
    clk_i : in std_logic
  );
end proto_cpu;

architecture behaviour of proto_cpu is

component single_register is
  generic (N: integer); -- Me permite asignar una longitud configurable
  port (
    reg_i : in std_logic_vector(N-1 downto 0); -- entrada
    reg_o : out std_logic_vector(N-1 downto 0); -- salida
    write_enable_i : in std_logic;
    clk_i : in std_logic
  );
end component single_register;

component adder is
  generic (N : integer);
  port (
    a_i : in std_logic_vector(N-1 downto 0);
    b_i : in std_logic_vector(N-1 downto 0);
    sum_o : out std_logic_vector(N-1 downto 0)
  );
end component;

signal program_counter_i_s : std_logic_vector(N-1 downto 0);
signal program_counter_o_s : std_logic_vector(N-1 downto 0);

begin

program_counter: single_register
generic map(N => N)
port map(
  clk_i => clk_i,
  write_enable_i=> '1',
  reg_i => program_counter_i_s,
  reg_o => program_counter_o_s
  );

adder_instance: adder
generic map(N => N)
port map(
  a_i => program_counter_o_s,
  b_i => std_logic_vector(to_unsigned(4, N)),
  sum_o => program_counter_i_s
);

reg_o <= program_counter_o_s;

end behaviour;
