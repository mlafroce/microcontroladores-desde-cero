-- Tipos standard
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adder is
  generic (N : integer :=32);
  port (
    a_i : in std_logic_vector(N-1 downto 0);
    b_i : in std_logic_vector(N-1 downto 0);
    sum_o : out std_logic_vector(N-1 downto 0)
  );
end adder;

architecture behaviour of adder is
begin
sum_o <= std_logic_vector(unsigned(a_i) + unsigned(b_i));
end behaviour;