# Unidades funcionales

Las compuertas lógicas y flip flops se pueden agrupar en **unidades funcionales**, cuyo nombre proviene por la funcionalidad que aportan al funcionamiento de la CPU. Veremos 3 unidades funcionales básicas para cualquier microcontrolador de uso común.

## Registros

Un flip flop de tipo **D** puede almacenar un *bit* de información, un "1" o un "0". Si agrupamos *N bits* formamos una *palabra* (word) de N-bits. A ese grupo de flip flops lo llamamos **registro**. En el siguiente ejemplo armamos un registro de 4 bits.

![Registro de 4 bits](02-00-registro-4-bits.pdf)

Este registro tiene una linea de entrada para escritura (*WR*), una linea del *clock*, y otra de *enable* para habilitar la escritura o lectura del mismo. Si enable está bajo, la salida posee alta impedancia, si está alto, la salida equivale al valor almacenado en el flip flop.

### Banco de registros

Una CPU puede contar con un vector de registros, llamado *banco de registros* (*Register file*). Las primitivas arquitecturas poseían un banco de registros chico, ya que sus instrucciones estaban basadas en accesos a memoria y generalmente constaban de una lógica compleja. Este tipo de arquitecturas era conocido como **CISC** (*Complex Instruction Set Computer*).

A medida que la tecnología fue evolucionando, el costo de los módulos de memoria fue disminuyendo, y aumentar la frecuencia del clock de la CPU se hacía cada vez más difícil. Por este motivo las instrucciones complejas fueron simplificándose para poder dar lugar a mejoras como el paralelismo de instrucciones. Estas instrucciones más simples no trabajan con la memoria principal de forma directa, sino que trabajan haciendo uso intensivo de los registros, reduciendo enormemente la cantidad de ciclos de reloj por instrucción.
Debido a esto, estas arquitecturas suelen tener un banco de registros bastante más grande (por ejemplo, las arquitecturas de *SPARC* y *MIPS* de 32 bits tienen 32 *registros de uso general*, versus 8 registros en la arquitectura *X86*).
A este tipo de arquitecturas, de menor cantidad de instrucciones, se lo conoce como **RISC** (*Reduced Instruction Set Computer*)

![Registro de 4 bits](02-01-banco-registros.pdf)

#### Puertos de lectura y escritura

Un banco de registros puede contar con uno o más puertos de lectura para poder leer el contenido de uno de sus registros. La selección del registro se hace mediante un *multiplexor*.

De forma análoga se puede contar con uno o más puertos de escritura, que permitan escribir contenido en uno de sus registros.

### Implementación

#### Implementación de un registro

Simplemente creamos una entidad con un vector de flip flops. Establecemos el ancho de la palabra utilizando un parámetro `generic`, que me permite utilizar constantes que el usuario, puede ajustar al momento de instanciar el componente.

~~~{.vhdl}
entity cpu_register is
  generic (WIDTH: integer := 32);
  port(
    -- Entradas
    data_i: in std_logic_vector(WIDTH - 1 downto 0);
~~~

Agregamos también los otros puertos: el *clock* de entrada, una entrada que habilite el uso del flip flop, otra que seleccione si está en modo escritura o lectura. Así como tenemos un vector de bits de entrada, tendremos un vector de bits de salida, de la misma longitud.

~~~{.vhdl}
    clk_i: in std_logic;
    en_i: in std_logic;
    write_i: in std_logic;
    -- Salidas
    data_o: out std_logic_vector(WIDTH - 1 downto 0)
  );
end cpu_register;
~~~

La implementación de la arquitectura es sencilla: se instancia un vector de señales, que almacenaran el estado, y, para el **flanco ascendente** del reloj, si la entrada de `enable` y la de `write` están en alto, almacenamos el valor de entrada en el vector de señales. Además, en el flanco ascendiente es cuando la salida del registro cambia al valor almacenado.

~~~{.vhdl}
architecture behaviour of cpu_register is
signal data_s : std_logic_vector
    (WIDTH - 1 downto 0) := (others => '0');
begin
  process (clk_i)
  begin
    -- Ejecutar sólo cuando hay flanco ascendente del reloj
    if rising_edge(clk_i) then
      if en_i = '1' then
        if write_i = '1' then
          data_s <= data_i;
        end if; -- end if write_i
      end if; -- end if en_i
    end if; -- end if rising_edge
  end process;
  data_o <= data_s;
end behaviour;
~~~

#### ¿Cuándo le asigno valor a la salida?

En la implementación anterior escribimos:

~~~{.vhdl}
  process (clk_i)
  ...
  end process;
  data_o <= data_s;
~~~

Lo que se puede interpretar como "cuando ocurre un cambio en la entrada `clk_i`, ejecutar [...]. Además, de forma concurrente asignar el valor de `data_s` a la salida `data_o`"

Esto no es un detalle menor, dado que, cuando lo sintetizamos, el reporte nos indica que se utilizaron los siguientes componentes: 

    Total logic elements  33
      Total combinational functions 1
      Dedicated logic registers 32
      Total registers 32

Esto tiene sentido ya que nuestro registro es de 32 bits y se sintetiza con 32 flip flops.

Sin embargo, si nuestro código hubiera sido el siguiente

~~~{.vhdl}
  process (clk_i)
    if rising_edge(clk_i) then
      if write_i = '1' then
        data_s <= data_i;
      end if; -- end if write_i
      data_o <= data_s;
    end if; -- end if rising_edge
  end process;
~~~

La escritura de la señal de salida ocurre únicamente cuando hay flanco ascendente del reloj. Esto es un inconveniente para el sintetizador, ya que, al no tener definido qué hacer en el resto de los estados del reloj, utiliza un *latch* para mantener el estado de la salida.

Ahora, cada bit del registro está implementado por un flip flop y un latch, lo que duplica la cantidad de unidades lógicas utilizadas, además de meter un delay innecesario a la escritura del flip flop.

    Total logic elements  65
      Total combinational functions 1
      Dedicated logic registers 64
      Total registers 64

### Implementación del banco de registros

De forma muy similar vamos a implementar un banco de registros que utilice el componente anterior. Nuestro banco de registros tendrá lo siguiente:

* `NUM_REG` registros, cada uno de ancho `WIDTH`

* Dos *puertos de salida* de ancho `WIDTH`, para poder usar como operandos en instrucciones aritmético lógica.

* Un *puerto de entrada* de ancho `WIDTH`, para almacenar los resultados de las operaciones previamente nombradas

* Entrada de reloj

* 3 selectores de ancho log2(`WIDTH`), de forma de poder seleccionar los puertos de salida y entrada previamente nombrados.

* Puerto que habilite la escritura en las entradas

Empezamos importando las bibliotecas estándar

~~~{.vhdl}
-- Tipos standard
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; -- permite usar to_unsigned
~~~

Declaramos los parámetros genéricos:

* `REG_WIDTH`: El ancho de los registros.

* `REG_NUM`: La cantidad de registros en el banco.

* `REG_NUM_LOG`: La cantidad de bits necesarios para identificar cada registro, estos se calculan como $\lceil \log_2{N} \rceil$.

~~~{.vhdl}
entity register_file is
  generic (
    REG_WIDTH: integer := 32;
    REG_NUM: integer := 32;
    REG_NUM_LOG: integer := 5
  );
~~~

Declaramos los puertos, elegimos sus nombres basados en la nomenclatura de *MIPS*.

En MIPS, y la mayoría de los procesadores *RISC*, las instrucciones utilizan, a lo sumo, dos registros como operandos y un tercero como destino del resultado. Para poder usar este modelo, declaramos los siguientes puertos:

* `clk_i`: Reloj de entrada, que va a estar conectado a todos los registros que lo componen.

* `write_i`: Habilita la escritura. Las operaciones que hacen uso del registro de destino tienen que habilitar la escritura del mismo mediante este puerto.

* `rs1_selector_i`, `rs2_selector_i`, `rdest_selector_i`: Entrada numérica, que nos permiten elegir cuáles registros utilizar como operandos (`rs1` y `rs2`), y cuál utilizar como destino (`rdest`).. Instintivamente nuestro primer paso sería instanciar un componente multiplexor, sin embargo, *VHDL* nos ofrece formas de realizar un multiplexado con herramientas del lenguaje.

Primero vamos a necesitar 
* `rdest_i`: Vector de ancho `REG_WIDTH` que, mediante un multiplexor, se conecta al registro indicado por `rdest_selector_i`. Este es un puerto de entrada ya que lo que quiero es usarlo para almacenar el resultado de ciertas operaciones aritmético lógicas, o destino en una lectura de la memoria principal.

* `rs1_o`, `rs2_o`: Vector similar al anterior, que se conecta a los registros indicados por `rs1_selector_i` y `rs2_selector_i` respectivamente. Estos puertos son de salida ya que se se usan como operandos de operaciones aritmético lógicas, para direccionar un acceso de memoria, o como fuente en una escritura a la memoria principal.

~~~{.vhdl}
  port(
    -- Entradas
    clk_i: in std_logic;
    en_i: in std_logic;
    write_i: in std_logic;
    rs1_selector_i: in integer range 0 to REG_NUM;
    rs2_selector_i: in integer range 0 to REG_NUM;
    rdest_selector_i: in integer range 0 to REG_NUM;
    rdest_i: in std_logic_vector(REG_WIDTH - 1 downto 0);
    -- Salidas
    rs1_o: out std_logic_vector(REG_WIDTH - 1 downto 0);
    rs2_o: out std_logic_vector(REG_WIDTH - 1 downto 0)
  );
end register_file;
~~~

Ahora procedemos a implementar la arquitectura. Instintivamente nuestro primer paso sería instanciar un componente multiplexor, sin embargo, *VHDL* nos ofrece formas de realizar un multiplexado con herramientas del lenguaje.

Primero vamos a necesitar una matriz de señales de `Número de registros` por `Ancho de registro`. Vamos a usar una matriz para la entrada de datos y otra para la salidas.

Para esto *VHDL* nos exige declarar un tipo de dato propio, un array de vectores.

~~~{.vhdl}
architecture combinational of register_file is
  type reg_mux_type is array(0 to REG_NUM - 1) of 
    std_logic_vector(REG_WIDTH - 1 downto 0);
  signal input_s : reg_mux_type := (others => (others => '0'));
  signal output_s : reg_mux_type := (others => (others => '0'));
~~~

Instanciamos los registros previamente diseñados

~~~{.vhdl}
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
~~~

Luego instanciamos los *N* registros. Para esto utilizamos el comando `generate`. Este comando  se utiliza para sintetizar un arreglo de componentes, utilizando una variable para iterar sobre un rango.

En el siguiente fragmento instanciamos *N* componentes `cpu_register`, y a cada uno de ellos le asignamos una fila de la matriz de entradas y de salidas a las correspondientes entradas y salidas del componente.

~~~{.vhdl}
begin -- begin architecture combinational
  reg_g: for I in 0 to REG_NUM - 1 generate
    regXinst: cpu_register
      port map
        (input_s(I), clk_i, en_i, write_i, output_s(I));
  end generate reg_g;
~~~

Finalmente, asignamos a los puertos de nuestros componentes una fila de nuestras matrices de señales. Utilizamos las matrices de entrada y de salida según corresponda al tipo de puerto.

~~~{.vhdl}
  rs1_o <= output_s(rs1_selector_i);
  rs2_o <= output_s(rs2_selector_i);
  input_s(rdest_selector_i) <= rdest_i;

end combinational;
~~~

#### Otras implementaciones

También es posible implementar el banco de registros creando un componente multiplexor, instanciándolo y vinculando las señales correspondientes. Sin embargo, esto le agrega una complejidad innecesaria al componente. Se encuentra una implementación disponible en el repositorio del libro.

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
