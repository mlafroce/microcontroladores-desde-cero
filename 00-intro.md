# Un poco de historia

Los mecanismos para ejecutar cálculos existen desde hace siglos. El ejemplo más conocido es la *Pascalina*, creada por Blaise Pascal, en el siglo XVII. Esta máquina se especializaba en realizar sumas y restas con números de hasta 10 dígitos (incluidos los decimales).

Dos siglos más tarde, Charles Babbage diseña la famosa *máquina diferencial*. Esta máquina permitiría calcular funciones polinómicas, que, mediante aproximaciones analíticas, puede ser utilizada para aproximar logaritmos, funciones exponenciales, etc.
Cabe destacar que fue para esta máquina diferencial que se escribe el primer *algoritmo*, que describe los pasos que debía seguir esta máquina para encontrar los números de Bernoulli. *Ada Lovelace*, quien se dice que escribió este primer algoritmo, fue además una visionaria que predijo que la computación podía ser usado para representar más cosas que solo números.

Para la segunda guerra mundial, los alemanes implementaron una máquina que encriptaba mensajes para comunicarse con los submarinos. Esta máquina fue conocida como *ENIGMA*. Si bien el procedimiento de encriptación era conocido, la desencriptación era mucho más complicada, por lo que científicos ingleses (entre ellos el famoso Alan Turing) se dedicaron a la creación de una máquina de desencriptado. El *Colossus* fue una serie de computadoras que ayudaron a romper el código de Enigma. Estaban compuestas por *válvulas de vacío*, siendo estas las primeras computadoras electrónicas programables (aunque no almacenaban un programa sino que se hacía mediante switches y cables).

Paralelo a los trabajos de Turing, el ejercito de EE.UU. trabajó en una máquina para computar tablas de trayectoria balística, llamada ENIAC.


# Computadoras modernas

## Modelo Von Neumann

![Modelo Von Neumann](00-00-modelo-von-neumann.png)

El modelo Von Neumann reconoce 5 componentes principales en una computadora

* **Unidad de entrada**: provee instrucciones y datos al sistema.

* **Unidad de memoria**: donde se van almacenando las entradas y valores intermedios del proceso.

* **Unidad aritmético-lógica**: encargada del procesamiento de los datos, conocida como **ALU**.

* **Unidad de salida**: se comunica con los dispositivos de salida para visualizar los datos procesados.

* **Unidad de control**: dirige las anteriores unidades.

Este modelo además introduce el concepto de *programa almacenado*, en el que los programas se almacenan en conjunto los datos de entrada, pudiendo ser manipulados como datos.

## Modelo de bus de sistema

![Bus de sistema](00-01-bus-de-sistema.png)

Esta modernización del modelo Von Neumann propone el uso de un *bus simple del sistema* por el cual circulan los datos (*Data Bus*), las direcciones de memoria donde se encuentran esos datos (*Address Bus*), y los datos para controlar las distintas unidades (*Control Bus*). Además, se combina la ALU con la unidad de control, pasándose a llamar CPU.

## Arquitectura Harvard

![Arquitectura Harvard](00-02-arquitectura-harvard.png)

La característica principal del modelo harvard es que utiliza distintos buses para la memoria de instrucciones y la de datos. Esto le permite usar distintas tecnologías para cada memoria, como también distinto espacio de memoria, por ejemplo, puedo tener instrucciones de 16 bits de largo y el bus de datos con un ancho de 8 bits.


# Niveles de complejidad

Como cualquier sistema complejo, una computadora puede ser vista desde un número de niveles, siendo el más alto el nivel de *usuario* y el más bajo, transistores, capacitores, etc. Cada nivel representa una abstracción. Esto nos permite independizar los distintos niveles: un usuario no necesita saber cómo está programada una aplicación para usarla, y un programador no necesita saber cómo están dispuestas las compuertas lógicas del procesador para programar.

![Niveles de complejidad](00-03-niveles-de-complejidad.png)

La estratificación permitió además que el usuario actualizara su computadora manteniendo compatibilidad de las capas superiores. El programador puede escribir código para una familia de hardware y que este se mantenga compatible con las actualizaciones.

De arriba hacia abajo los niveles son estos:

* **Nivel de usuario/aplicación**: El usuario interactúa con la computadora ejecutando programas como navegadores web, ofimática, etc.

* **Lenguaje de alto nivel**: El usuario programa instrucciones en lenguajes de alto nivel: Java, C, Python, etc. El programador utiliza instrucciones del lenguaje, pero no tiene conocimiento de su implementación en hardware. Es el compilador el que mapea instrucciones del lenguaje contra instrucciones implementadas en la máquina. Los lenguajes de alto nivel pueden ser recompilados para diversas máquinas con la intención de proveer el mismo comportamiento.

* **Lenguaje de ensamblador/máquina**: Como se menciona anteriormente, el compilador traduce código de *alto nivel* a instrucciones de máquina. Los *lenguajes de máquina* trabajan con conceptos de hardware como los registros de datos y la transferencia entre ellos. Muchas de las instrucciones se describen por el tipo de operaciones que hacen con los registros y cuáles utilizan. El conjunto de instrucciones de una máquina se conoce como **Set de instrucciones**. El código de máquina es *código binario*, y dado lo engorroso de programar en esta forma, se utiliza lo que se conoce como *lenguaje de ensamblador*, que contiene mnemónicos (como *move*, *and*, *or*, *jmp*, etc) al correspondiente número en lenguaje de máquina.

* **Nivel de control**: Es mediante señales de control que la *CPU* opera sobre los registros. La unidad de control interpreta el código de máquina y mediante lógica de circuitos transfiere datos entre registros. Hay varias formas de implementar la unidad de control, una es la implementación estática física (*Hardwire*), que posee la ventaja de ser veloz. Otra forma es implementar las instrucciones en forma de *microprograma*. Este microprograma, también conocido como *firmware* interpreta las instrucciones de lenguaje máquina y ejecuta las microinstrucciones correspondientes para llevarlas a cabo.

* **Nivel de unidad funcional**: Refiere a los registros internos de la cpu, a la *ALU*, y a la memoria principal.

* **Compuertas lógicas y transistores**

# Bibliografía

* Computer Organization and Design, 4th edition, James Murdocca, Unidad 1

