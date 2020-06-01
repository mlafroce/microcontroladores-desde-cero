# Unidades funcionales

Las compuertas lógicas y flip flops se pueden agrupar en **unidades funcionales**, cuyo nombre proviene por la funcionalidad que aportan al funcionamiento de la CPU. Veremos 3 unidades funcionales básicas para cualquier microcontrolador de uso común.

## Banco de registros

Un registro es un conjunto de espacios de almacenamiento de acceso rápido para la cpu. Almacenan diversos datos: direcciones de memoria, instrucciones, variables, etc. La gran mayoría de las CPUs utilizan varios registros, independientemente de si están basados en una arquitectura *Load-Store* (Es decir, si trabajan con la memoria de forma directa o deben pasar por los registros antes.)

En la jerarquía de memoria de una computadora, los registros suelen estar en el tope, ya que son los más eficientes, pero por su costo, los más escasos.

### Implementación en VHDL

Una implementación sencilla en VHDL podría ser

~~~{.vhdl}
entity single_register is
  generic (N: integer := 32);
  port (
    reg_i : in std_logic_vector(N-1 downto 0); -- entrada
    reg_o : out std_logic_vector(N-1 downto 0) := (others => '0');
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
~~~

## Acceso a memoria principal

Otra de las unidades funcionales presentes en la CPU es la **Unidad de manejo de memoria (MMU)**. Esta unidad es bastante compleja, ya que realiza tareas como el manejo del *cache* de la memoria, o las transformaciones de direcciones de *memoria virtual* a *memoria física*. Más adelante nos centraremos en una de sus funciones más importantes, que es el acceso a la memoria principal-

### Memoria Cache

En una computadora, acceder a la memoria principal es una operación "costosa". La frecuencia del reloj de la CPU no es la misma que la de la memoria principal, ni están cercanos físicamente, por lo que se debe realizar una serie de pasos que puede tardar decenas, incluso cientos de veces más para adquirir un dato en comparación a adquirirlo desde un registro.

Para mitigar este efecto las CPUs contienen una memoria intermedia llamada **memoria cache**. La memoria cache es de un acceso más rápido que el acceso a la memoria RAM.

La *memoria cache* suele estar separada en niveles, los niveles más bajos son de acceso casi inmediato, pero chicos en tamaño. Los niveles superiores poseen un acceso más lento pero mayor tamaño de almacenamiento.


### Memoria virtual

En los sistemas operativos, un procesador no corre una sola tarea, sino que varias. Un proceso llamado *scheduler* se encarga de administrar el tiempo de ejecución de cada tarea, otorgándole tiempos muy chicos de ejecución a cada uno (*slices*).

En los sistemas medianamente modernos, cada tarea desconoce la existencia del resto, y opera sobre la memoria como si fuera el único proceso existente. Es la MMU la que **se encarga de administrar la memoria física**, "real" del sistema, otorgando a cada proceso direcciones "virtuales" de memoria y mapeando estas direcciones "falsas" a las de la memoria física.

La memoria virtual suele administrarse en "páginas", si se requieren más páginas que lo que puede almacenar la memoria física, se suele hacer uso de la **memoria de intercambio en el almacenamiento** (discos rígidos por ejemplo). El MMU también suele encargarse del manejo de páginas de memoria.


## ALU

La *ALU* es la **Unidad aritmetico-lógica** de una CPU. Se podría decir que es el corazón de la misma, ya que es la que se encarga de **operaciones aritméticas** (como sumas, restas, operaciones booleanas, deslizamientos, etc) y **operaciones lógicas** (como comparaciones entre operandos).


## Prototipando una CPU

Vamos a diseñar la CPU más básica de todas, una CPU sin instruccines, que solo avance el *Program counter*.

