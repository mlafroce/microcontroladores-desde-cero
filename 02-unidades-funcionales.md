# Unidades funcionales

Las compuertas lógicas y flip flops se pueden agrupar en **unidades funcionales**, cuyo nombre proviene por la funcionalidad que aportan al funcionamiento de la CPU. Veremos 3 unidades funcionales básicas para cualquier microcontrolador de uso común.

## Registros

Un flip flop de tipo **D** puede almacenar un *bit* de información, un "1" o un "0". Si agrupamos *N bits* formamos una *palabra* (word) de N-bits. A ese grupo de flip flops lo llamamos **registro**. En el siguiente ejemplo armamos un registro de 4 bits.

![Registro de 4 bits](02-00-registro-4-bits.pdf)

Este registro tiene una linea de entrada para escritura (*WR*), una linea del *clock*, y otra de *enable* para habilitar la escritura o lectura del mismo. Si enable está bajo, la salida posee alta impedancia, si está alto, la salida equivale al valor almacenado en el flip flop.

### Banco de registros

Una CPU puede contar con un vector de registros, llamado *banco de registros* (*Register file*). Las primitivas arquitecturas poseían un banco de registros chico, ya que sus instrucciones estaban basadas en accesos a memoria y generalmente constaban de una lógica compleja. Este tipo de arquitecturas era conocido como **CISC** (*Complex Instruction Set Computer*). A medida que la tecnología fue evolucionando, el costo de los módulos de memoria fue disminuyendo, y aumentar la frecuencia del clock de la CPU se hacía cada vez más difícil. Por este motivo las instrucciones complejas fueron simplificándose para poder dar lugar a mejoras como el paralelismo de instrucciones. Estas instrucciones más simples no trabajan con la memoria principal de forma directa, sino que trabajan haciendo uso intensivo de los registros, reduciendo enormemente la cantidad de ciclos de reloj por instrucción. Debido a esto, estas arquitecturas suelen tener un banco de registros bastante más grande (por ejemplo, las arquitecturas de *SPARC* y *MIPS* de 32 bits tienen 32 *registros de uso general*, versus 8 registros en la arquitectura *X86*). A este tipo de arquitecturas, de menor cantidad de instrucciones, se lo conoce como **RISC** (*Reduced Instruction Set Computer*)

![Registro de 4 bits](02-01-banco-registros.pdf)

#### Puertos de lectura y escritura

Un banco de registros puede contar con uno o más puertos de lectura para poder leer el contenido de uno de sus registros. La selección del registro se hace mediante un multiplexor.

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
      data_o <= data_s;
    end if; -- end if rising_edge
  end process;
end behaviour;
~~~


## Acceso a memoria principal

Otra de las unidades funcionales presentes en la CPU es la **Unidad de manejo de memoria (MMU)**. Esta unidad es bastante compleja, ya que realiza tareas como el manejo del *cache* de la memoria, o las transformaciones de direcciones de *memoria virtual* a *memoria física*. Nos centraremos en una de sus funciones más importantes, que es el acceso a la memoria principal-

## ALU