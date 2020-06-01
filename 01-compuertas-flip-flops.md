# Compuertas lógicas y circuitos

Comenzamos en el nivel más bajo de la electrónica digital. En este nivel nos abstraemos de conceptos como valores de tensión, corriente, etc. Tomamos dos valores de tensión como alto y bajo, y les asignamos los valores numéricos 1 y 0 respectivamente.
A partir de esta abstracción, modelamos nuestros problemas utilizando *álgebra de Boole*.

## Compuertas lógicas básicas

La expresiones *booleanas* se representan de 3 formas distintas, una puede ser mediante símbolos de un diagrama lógico, otra puede ser mediante una expresión algebraica, y otra es mediante la tabla de verdad. La tabla de verdad nos dice, dado un estado de las variables de entrada, cuál es el resultante en las variables de salida.

### Compuerta NOT

![Compuerta NOT](01-00-compuerta-not.pdf){width=80%}

### Compuerta AND

![Compuerta AND](01-01-compuerta-and.pdf){width=80%}

### Compuerta OR

![Compuerta OR](01-02-compuerta-or.pdf){width=80%}

### Compuerta XOR

![Compuerta XOR](01-03-compuerta-xor.pdf){width=80%}

### Compuerta NAND

![Compuerta NAND](01-04-compuerta-nand.pdf){width=80%}

### Compuerta NOR

![Compuerta NOR](01-05-compuerta-nor.pdf){width=80%}

## Flip flops

Los flip flops son utilizados frecuentemente para almacenar información. El flip flop más básico es conocido como el R-S. Este circuito posee dos variables de entrada (*Set* y *Reset*), y generalmente dos de salida: $Q$ y $\overline{Q}$, que vendría ser la negación del primero. Como característica principal, la salida de flip-flops depende del estado del mismo. Por este motivo, las tablas de verdad de los flip-flops tienen, además de las variables de entrada, una variable $Q_{t}$ y otra $Q_{t+1}$

### Flip flop asincrónicos

#### Flip flop RS

Los flip flops **RS** son los más básicos, formados por 4 compuertas NAND o NOR. El nombre proviene de sus dos entradas: *R*, que proviene de *reset*, y *S*, que proviene de *set*. Mientras ambas entradas sean 0, la salida, *Q*, mantiene su valor. Si asignamos un valor alto a *R*, y a *S* lo mantenemos en 0, se le asigna el estado 0 a la salida *Q*, mientras que si asignamos 0 a *R*, y alto a *S*, el estado de *Q* pasa a ser 1.

El problema que tiene este flip flop es que si ambas salidas son altas, el comportamiento es impredecible o *indeseado*, por lo cuál se lo marca en la tabla de verdad con una X.

![Flip-flop RS](01-06-flip-flop-rs.pdf){width=80%}

#### Flip flop JK

Los flip flops **JK** poseen la misma tabla de verdad que los RS, pero cambia el comportamiento del estado inválido. A diferencia del **RS**. Si las dos entradas son inválidas, invierte el valor almacenado.

![Flip-flop JK](01-07-flip-flop-jk.pdf){width=80%}

#### Flip flop T

Estos flip flops poseen dos entradas. La primera, **T** (*toggle*) está conectada a las entradas de un JK, de forma que cuando esta entrada *T* esté en bajo, mantenga su valor, y cuando *T* esté en alto, lo altene. La segunda entrada, **E** (*enable*), habilita el alto de *T* mediante el uso de una compuerta AND. Mientras **E** esté bajo, no pueden haber cambios en el valor del flip flop.

![Flip-flop T](01-08-flip-flop-t.pdf){width=80%}

#### Flip flop D

Estos flip flops también hay dos entradas como en los **T**. La entrada **D** está conectada las entradas de un flip flop *RS*. *D* se conecta a la entrada *S* y a la entrada *R* se lo conecta negado. De esta forma, la salida del flip flop *RS* es la misma que la de la entrada *D*. La otra entrada **E**, se utiliza para habilitar el alto en las entradas *S* y *R*, de forma que mientras *E* esté en bajo, las entradas *S* y *R* estén en bajo y el valor del flip flop se mantenga.

![Flip-flop D](01-09-flip-flop-d.pdf){width=80%}

### Flip flop sincrónicos

Para evitar *condiciones de carrera* (una señal llega antes que otra), y brindar estabilidad al flip flop, se utiliza una señal de reloj que habilite los cambios de estado.

## Síntesis en VHDL

No es necesario sintetizar estos componentes uno por uno para poder utilizarlos, dado que los compiladores ya detectan cuál es la configuración óptima a utilizar con un FPGA. Sin embargo, veremos cómo crear un componente con cada una de estas funciones.

### Hola VHDL

En la programación es habitual comenzar por un programa "Hola mundo" (más conocido por su traducción "Hello world!"), para probar que el entorno de desarrollo esté correctamente configurado.

Nuestro primer componente será uno que tenga 2 entradas `a_i`, `b_i`, y 6 salidas, correspondientes a cada una de las funciones lógicas, `not_a_o`, `and_o`, `or_o`, `xor_o`. `nand_o`, y `nor_o`. Este componente no posee estado, por lo que no hará uso del reloj.

El segundo componente tendrá 2 entradas, `a_i`, `b_i`, y sus salidas, `rs_o`, `jk_o`, `t_o`, y `d_o` corresponderan a las salidas los flip-flops correspondientes.

#### Compuertas lógicas

Para el primer componente, iniciamos declarando la interfaz en archivo de extensión *vhdl*:

~~~{.vhdl}
-- Tipos standard
library IEEE;
use IEEE.std_logic_1164.all;

-- declaramos la interfaz del componente "hello_logic", para
-- referirnos al componente lógico
entity hello_logic is
-- Enumeramos los puertos de entrada y salida
  port(
    -- <nombre>: [in/out] [tipo];
    -- Entradas
    a_i: in std_logic := '0';
    b_i: in std_logic := '0';
    -- Salidas
    not_a_o: out std_logic;
    and_o: out std_logic;
    or_o: out std_logic;
    xor_o: out std_logic;
    nand_o: out std_logic;
    nor_o: out std_logic
  );
end hello_logic;
~~~

Una vez declarada la interfaz, realizamos una implementación del componente. Las implementaciones se conocen bajo el nombre de *arquitectura*, y permiten al usuario seleccionar distintas implementaciones de un mismo componente, algo que puede ser útil para realizar *benchmarks*, o por si nos vemos limitados en el tipo de recursos que pueden usar los componentes.

~~~{.vhdl}
-- "behaviour" es un nombre comun para arquitecturas default
architecture behaviour of hello_logic is
begin
~~~

Este componente no depende de ningún clock, por lo que podemos escribir la lógica combinacional sin necesidad de ningún `process` (ver más adelante).

Por suerte, las funciones lógicas que queremos implementar ya forman parte del lenguaje VHDL


~~~{.vhdl}
-- salida <= entradas + funciones lógicas;
not_a_o <= not a_i;
and_o <= a_i and b_i;
or_o <= a_i or b_i;
xor_o <= a_i xor b_i;
nand_o <= a_i nand b_i;
nor_o <= a_i nor b_i;
~~~

Cerramos la implementación escribiendo `end <nombre arquitectura>`

~~~{.vhdl}
end behaviour;
~~~

#### Flip flops

Para el segundo componente, que utiliza flip flops, tendremos que agregar una entrada de *clock*. Esta nueva entrada será la que sincronizará los flip-flops, cuando tenga un flanco ascendiente del reloj, actualizo los estados de cada uno de ellos.

Agregamos la siguiente interfaz en otro archivo nuevo o en el mismo que en el anterior:


~~~{.vhdl}
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
~~~

La implementación ahora tiene dos nuevas cualidades: almacena un estado por cada flip flop, y reacciona al flanco ascendente del reloj.

Abrimos la implementación:

~~~{.vhdl}
architecture behaviour of hello_flip_flops is
~~~

Indicamos las *variables de estado*, con la palabra clave `signal`

~~~{.vhdl}
-- El estado Q de cada flip flop
signal rs_status : std_logic := '0';
signal jk_status : std_logic := '0';
signal t_status : std_logic := '0';
signal d_status : std_logic := '0';
~~~

Existen dos tipos de variables, las `variable` propiamente dichas, y las `signal`. A diferencia de la primera, las signals pueden utilizarse en más de un proceso, y además se pueden sintetizar en forma de flip-flops, caso en el que, para tomar un valor, debe esperar a la habilitación por parte del *clock*.
Por otro lado, las variables toman valor de forma automática, y sólo tienen alcance dentro del proceso donde se declaran. Son útiles para realizar cálculos aritméticos, entre otras cosas.

Iniciamos la implementación de la arquitectura e indicamos que el siguiente comportamiento *reacciona* al cambio del reloj

~~~{.vhdl}
begin -- begin behaviour
process (clk_i)
~~~

Y comenzamos a declarar el comportamiento. Debido a que armar el circuito lógico es un proceso complejo, utilizaremos una contrucción del lenguaje para armar tablas de verdad: `case statements`

~~~{.vhdl}
begin
  process (clk_i)
  -- Armo este vector para usar en el `case`
  variable input_v: std_logic_vector(0 to 1);
  begin
    -- Ejecutar sólo cuando hay flanco ascendente del reloj
    if rising_edge(clk_i) then
      -- Asigno los valores a mi vector de entradas
      input_v := a_i & b_i; 
~~~

Una vez que armamos el vector, procedemos a llamar al `case`. Notar que le estamos asignando los valores a las signal `_status`, y no a la salida directo.

~~~{.vhdl}
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
~~~

Una vez declarado el case, unimos el estado de los `_status`

~~~{.vhdl}
-- Asigno las señales a salidas
rs_o <= rs_status;
jk_o <= jk_status;
t_o <= t_status;
d_o <= d_status;
~~~

Y termino el comportamiento 

~~~{.vhdl}
  end if; -- end if rising_edge
end process;
~~~

Cerramos la implementación:

~~~{.vhdl}
end behaviour;
~~~

### Probando nuestros componentes

Hay varios métodos para simular nuestros componentes y probar su correcto funcinoamiento. Uno de estos es crear un componente tipo caja negra, que contenga al componente a probar y le envíe señales de prueba.

Haremos un componente de estos para simular el comportamiento de `hello_flip_flops`

Empezamos definiendo una interfaz vacía

~~~{.vhdl}
-- declaramos una interfaz vacía "hello_flip_flops_test",
-- ya que este componente no necesita entradas ni salidas
entity hello_flip_flops_test is
end hello_flip_flops_test;
~~~

Comienzo a definir la implementación de mi componente simulador. Como este componente va a hacer uso de otro componente (el de los flip flops que quiero probar), tengo que declarar la interfaz del otro componente.

~~~{.vhdl}
architecture behaviour of hello_flip_flops_test is
  -- Declaro el componente cuidando que la interfaz sea
  -- la misma que la de la que queremos probar 
  component hello_flip_flops is
    port(
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
  end component hello_flip_flops;
~~~

Para ejecutar las pruebas voy a simular 3 señales: las dos entradas, a_i y b_i, y la señal de clock. Las declaro e inicializo.

~~~{.vhdl}
  -- Instancio señales que voy a ir variando en las pruebas
  signal a_t : std_logic := '0';
  signal b_t : std_logic := '0';
  signal clk_t : std_logic := '0';
~~~

Una vez declaradas las señales e interfaces de componentes, se procede a iniciar la arquitectura.

Comienzo instanciando el componente a probar, y uniendo mis señales de prueba a las entradas del componente.
Como no voy a utilizar las salidas, solamente las observo, no las vinculo a ninguna señal.

~~~{.vhdl}
begin
  -- Instancia del componente a probar
  -- Le asigno a las entradas mis señales de prueba
  component_inst: hello_flip_flops
    port map(
    -- Entradas
    a_i => a_t,
    b_i => b_t,
    clk_i => clk_t,
    -- Salidas
    rs_o => open,
    jk_o => open,
    t_o => open,
    d_o => open
    );
~~~

Creo un proceso por cada señal, esperando un tiempo fijo, y alternando el valor de la señal en cada ciclo. La instrucción `wait for` es una instrucción *no sintetizable* que se ejecuta secuencialmente en nuestro simulador.

~~~{.vhdl}
  -- Señales de prueba
  process -- clk_t process
  begin
  wait for 20 ns;
  clk_t <= not clk_t;
  end process;

  process -- a_t process
  begin
  wait for 40 ns;
  a_t <= not a_t;
  end process;

  process -- b_t process
  begin
  wait for 80 ns;
  b_t <= not b_t;
  end process;
~~~

Finalizo la implementación

~~~{.vhdl}
end architecture ; -- behaviour
~~~

Existen varios simuladores, algunos privados y otros de código abierto. Se hará mención de ellos en el repositorio de actividades.

## Bibliografía

* Computer science illuminated, Nell Dale, John Lewis

* The 8051 microcontroller and embedded systems using assembly and c, 2nd-ed, mazidi.

