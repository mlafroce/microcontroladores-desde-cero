# Compuertas lógicas y circuitos

Comenzamos en el nivel más bajo de la electrónica digital. En este nivel nos abstraemos de conceptos como valores de tensión, corriente, etc. Tomamos dos valores de tensión como alto y bajo, y les asignamos los valores numéricos 1 y 0 respectivamente.
A partir de esta abstracción, modelamos nuestros problemas utilizando *álgebra de Boole*.

## Compuertas lógicas básicas

La expresiones *booleanas* se representan de 3 formas distintas, una puede ser mediante símbolos de un diagrama lógico, otra puede ser mediante una expresión algebraica, y otra es mediante la tabla de verdad. La tabla de verdad nos dice, dado un estado de las variables de entrada, cuál es el resultante en las variables de salida.

### Compuerta AND

![Compuerta AND](01-00-compuerta-and.png)

### Compuerta OR

![Compuerta OR](01-01-compuerta-or.png)

### Compuerta NOT

![Compuerta NOT](01-02-compuerta-not.png)

### Compuerta XOR

![Compuerta XOR](01-03-compuerta-xor.png)

### Compuerta NAND

![Compuerta NAND](01-04-compuerta-nand.png)

### Compuerta NOR

![Compuerta NOR](01-05-compuerta-nor.png)

## Flip flops

Los flip flops son utilizados frecuentemente para almacenar información. El flip flop más básico es conocido como el R-S. Este circuito posee dos variables de entrada (*Set* y *Reset*), y generalmente dos de salida: $Q$ y $\overline{Q}$, que vendría ser la negación del primero. Como característica principal, la salida de flip-flops depende del estado del mismo. Por este motivo, las tablas de verdad de los flip-flops tienen, además de las variables de entrada, una variable $Q_{t}$ y otra $Q_{t+1}$

### Flip flop asincrónicos

#### Flip flop RS

![Flip-flop RS](01-06-flip-flop-rs.png)

#### Flip flop JK

![Flip-flop JK](01-07-flip-flop-jk.png)

#### Flip flop T

![Flip-flop T](01-08-flip-flop-t.png)

#### Flip flop D

![Flip-flop D](01-08-flip-flop-d.png)

### Flip flop sincrónicos

Para evitar *condiciones de carrera* (una señal llega antes que otra), y brindar estabilidad al flip flop, se utiliza una señal de reloj que habilite los cambios de estado.

# Bibliografía

* Computer science illuminated, Nell Dale, John Lewis

* The 8051 microcontroller and embedded systems using assembly and c-2nd-ed by mazidi.

