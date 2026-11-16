# 🖥️ U2-Proyecto-Ventas-e-inventario-en-ensamblador

Repositorio oficial que contiene el desarrollo del proyecto de ventas e inventario de una papelería correspondiente a la **Unidad 2** de la materia de Lenguajes de Interfaz.

## 📋 Datos Generales

- **Materia:** Lenguajes de Interfaz
- **Unidad:** Unidad 2 y 3
- **Alumnos:**
- Erik Vladimir Medina Pacheco
- Jennifer Scarlet Lugo Matinez
- Oscar Mario Velarde Barraza
- **Docente:** *Dr. Medina Jimenez Jose Luis*
- **Horario:** *10:00 - 11:00*

## 📂 Contenido del Repositorio

- **Proyecto/** - Código fuente principal en ensamblador del sistema de inventario y ventas.
- **inventario.txt** - Archivo de datos base para la gestión de productos.

---

## 📄 Informe del Proyecto

### 1. Negocio Elegido
El proyecto consiste en una aplicación de consola desarrollada en **Ensamblador x86 (32 bits)** utilizando la biblioteca **Irvine32**, diseñada para la gestión automatizada de una **papelería**. 

El sistema administra un catálogo con una capacidad máxima de **10 productos** (como lápices, cuadernos, bolígrafos, gomas, pegamento, entre otros). Cada registro se compone de los siguientes campos y validaciones:
- **Código único:** Formato estricto alfanumérico de tipo `ABC-123`.
- **Nombre del producto:** Longitud de 1 a 25 caracteres.
- **Precio unitario:** Rango válido desde `$0.01` hasta `$9999.99` MXN.
- **Existencia:** Control de inventario con un rango de 0 a 100 unidades.

**Menú Principal de Opciones:**
1. Registrar
2. Mostrar inventario
3. Buscar por código
4. Recibir mercancía
5. Vender
6. Resumen
7. Guardar
8. Cargar
9. Ver regla de negocio
0. Salir

### 2. Regla Adicional: Descuento por Cantidad
Para optimizar las dinámicas de venta al mayoreo, el sistema incorpora una regla de negocio automatizada enfocada en el volumen de compra por producto:
- **Cuándo se aplica:** Se activa de forma automática durante una operación de venta de un solo tipo de producto, siempre y cuando la cantidad solicitada sea de **10 unidades o más**.
- **Cálculo matemático:** $\text{Descuento} = \frac{\text{Importe Base}}{10} \quad (10\%)$. Se realiza mediante división entera en bajo nivel, por lo que cualquier fracción de centavo resultante se descarta automáticamente.
- **Importe Final e Ingresos:** $\text{Importe Final} = \text{Importe Base} - \text{Descuento}$. El total descontado se refleja en el ticket de venta y los ingresos totales de la sesión suman únicamente este importe final.

---

## 🧪 Casos de Prueba

| # | Prueba | Entrada | Resultado esperado | Resultado obtenido |
|---|---|---|---|---|
| 1 | Menú: opción inválida | x, 10, vacío | "Opcion invalida." y regresa al menú | Exitosa |
| 2 | Inventario sin cargar | opción 2 | "No hay productos registrados." | Exitosa |
| 3 | Cargar archivo válido | opción 8 | Carga correcta, 5 productos | Exitosa |
| 4 | Resumen inicial | opción 6 | Productos 5, unidades 180, valor $1952.00 MXN, ventas 0, ingresos $0.00 MXN | Exitosa |
| 5 | Alta válida | HOJ-001, Hojas blancas 500, 185.50, 20 | "Producto registrado." (6 productos) | Exitosa |
| 6 | Alta duplicada | LAP-001 | Rechazado: el código ya existe; sin cambios | Exitosa |
| 7 | Código incorrecto | lap-001, AB-123, ABC123, vacío | Código inválido; sin cambios | Exitosa |
| 8 | Nombre inválido | vacío, 26 caracteres, nombre con barra vertical | Nombre inválido; sin cambios | Exitosa |
| 9 | Precio inválido | $50, 1,000, 10.999, 0, 0.00, 10000, .50, 185, vacío | Precio inválido en todos; sin cambios | Exitosa |
| 10 | Precio con centavos menores a 10 | CLI-010, Clips jumbo, 12.05, existencia 0 | Se registra y se muestra como $12.05 MXN (7 productos) | Exitosa |
| 11 | Existencia inválida | 101, abc, -5, vacío | Entrada inválida; sin cambios | Exitosa |
| 12 | Búsqueda existente | opción 3, LAP-001 | Muestra Lapiz HB #2, $4.50 MXN, existencia 50 | Exitosa |
| 13 | Búsqueda inexistente | ZZZ-999 | "No existe un producto con ese codigo." | Exitosa |
| 14 | Recibir mercancía válida | GOM-002, 20 | Nueva existencia 32 | Exitosa |
| 15 | Recibir mercancía excesiva | GOM-002, 90 (32 + 90 = 122) | Rechazado: excedería 100; existencia sigue en 32 | Exitosa |
| 16 | Recibir cantidad inválida | GOM-002, 0 / abc / 101 | Entrada inválida; existencia sin cambios | Exitosa |
| 17 | Venta sin descuento | LAP-001, 5 | Base $22.50 MXN, sin descuento, total $22.50 MXN; existencia 45 | Exitosa |
| 18 | Venta con descuento (regla aplica) | BOL-010, 10 | Base $60.00, descuento $6.00, total $54.00 MXN; existencia 70 | Exitosa |
| 19 | Venta con 9 unidades (regla no aplica) | CUA-001, 9 | Base $292.50, sin descuento, total $292.50 MXN; existencia 21 | Exitosa |
| 20 | Venta rechazada por existencias | PEG-005, 9 (hay 8) | Rechazado: existencias insuficientes, disponibles 8; sin cambios | Exitosa |
| 21 | Venta con cantidad inválida | 0, abc, vacío | Entrada inválida; sin cambios | Exitosa |
| 22 | Resumen tras las operaciones | opción 6 | Productos 7, unidades 196, valor $5357.00 MXN, ventas 3, ingresos $369.00 MXN | Exitosa |
| 23 | Regla adicional | opción 9 | Muestra cuándo aplica y dos ejemplos | Exitosa |
| 24 | Cargar con cambios sin guardar | opción 8 | Pregunta de confirmación; con N no cambia nada | Exitosa |
| 25 | Guardar | opción 7 | "Inventario guardado"; el archivo tiene 7 productos | Exitosa |
| 26 | Salir con cambios sin guardar | modificar y elegir 0 | Pregunta si guardar; con S guarda; con N pide confirmar descarte | Exitosa |
| 27 | Recuperar en nueva ejecución | cerrar, abrir, opciones 8 y 6 | 7 productos; unidades 196; valor $5357.00; ingresos $0.00 (son de la sesión) | Exitosa |
| 28 | Archivo ausente | renombrar inventario.txt, opción 8 | "El archivo inventario.txt no existe"; catálogo actual intacto | Exitosa |
| 29 | Cabecera incorrecta | pruebas/inv_cabecera_mala.txt | "Archivo inválido o dañado"; catálogo intacto | Exitosa |
| 30 | Código duplicado en archivo | pruebas/inv_codigo_duplicado.txt | Archivo inválido; catálogo intacto | Exitosa |
| 31 | Precio inválido en archivo | pruebas/inv_precio_invalido.txt | Archivo inválido; catálogo intacto | Exitosa |
| 32 | Existencia fuera de rango en archivo | pruebas/inv_existencia_fuera_rango.txt | Archivo inválido; catálogo intacto | Exitosa |
| 33 | Archivo truncado | pruebas/inv_truncado.txt | Archivo inválido; catálogo intacto | Exitosa |
| 34 | Capacidad máxima | registrar hasta llegar a 10 y probar un 11.º | "Capacidad maxima alcanzada" | Exitosa |
| 35 | Pila equilibrada | usar cualquier opción | Nunca aparece "ERROR: pila desbalanceada" | Exitosa |

# Proyecto: Versión de la Unidad 3.

Esta sección documenta las optimizaciones, refactorizaciones y mejoras implementadas en la **Unidad 3** respecto a la versión anterior (Unidad 2): incorporación de macros, uso de la directiva `USES`, reutilización avanzada de procedimientos y robustecimiento en la carga de archivos.

---

## 1. Tabla de Antes y Después

| Parte del Programa | Problema Detectado | Cambio Implementado | Beneficio Principal |
| :--- | :--- | :--- | :--- |
| **Mensajes en pantalla** | La secuencia `mov edx, OFFSET`, `call WriteString` y `call Crlf` se repetía en 64 puntos del código. | Creación de las macros `mImprimirMensaje` y `mImprimirLinea` (preservando `EDX` con `push`/`pop`). | Reducción de 108 líneas de código redundantes; centralización del formato de salida. |
| **Registros en procedimientos** | 11 procedimientos gestionaban manualmente el respaldo y restauración con `push` y `pop` (58 líneas). | Implementación sistemática de la directiva **`PROC USES`**. | El ensamblador genera automáticamente el código de pila seguro, eliminando riesgos de desbalanceo. |
| **Copia de cadenas** | El procedimiento `copiarCadenaCompleta` ocupaba 16 líneas gestionando registros para llamadas cortas repetidas 4 veces. | Creación de la macro `mCopiarCadena` con la etiqueta local `LOCAL ciclo_copia`. | Se elimina la sobrecarga de `call`, `ret` y manipulación manual de pila (ahorro de 6 líneas). |
| **Lectura de teclado** | `leerLineaTeclado` mezclaba tareas de gestión de registros directamente con la lógica de entrada. | Creación de la macro `mLeeTeclado` combinada con `USES ecx edx` en el procedimiento. | Mayor modularidad y separación de responsabilidades en la lectura de consola. |
| **Carga desde archivo** | `convertirLineaARegistro` leía un campo extra inválido y los archivos con saltos de línea manuales (`CR/LF`) solían rechazarse. | Supresión de lecturas sobrantes e inclusión de filtros lógicos en `copiarCampoHastaDelimitador` para omitir caracteres 13 y 10. | El sistema procesa de forma tolerante archivos de texto editados externamente. |

---

## 2. Fragmentos Representativos

### 2.1 Procedimiento Reutilizado: `pedirEnteroEnRango`
Recibe el mensaje en `EDX`, el límite máximo en `EBX` y el mínimo en `ECX`. Devuelve el valor numérico en `EAX` y reporta errores mediante la bandera de acarreo (`CF`).

```assembly
pedirEnteroEnRango PROC USES esi
    call WriteString
    call leerLineaTeclado
    mov esi, OFFSET inBuf
    call convertirCadenaAEntero
    jc pedirEnteroEnRangoError
    cmp eax, ecx
    jb pedirEnteroEnRangoError
    clc
    jmp pedirEnteroEnRangoFin
pedirEnteroEnRangoError:
    mImprimirLinea msgEntInv
    xor eax, eax
    stc
pedirEnteroEnRangoFin:
    ret
pedirEnteroEnRango ENDP
```

**Puntos clave de uso en `Main.asm`:**
* **`registrarProducto`:** Validación de existencia inicial (0 a 100).
* **`recibirMercancia`:** Unidades recibidas (1 a 100).
* **`venderProducto`:** Cantidad de salida a comercializar (1 a 100).

---

### 2.2 Macros de Salida: `mImprimirMensaje` y `mImprimirLinea`
```assembly
mImprimirMensaje MACRO mensaje
    push edx
    mov edx, OFFSET mensaje
    call WriteString
    pop edx
ENDM

mImprimirLinea MACRO mensaje
    mImprimirMensaje mensaje
    call Crlf
ENDM
```

* **`mImprimirLinea`** reduce bloques repetitivos de 3 instrucciones a una sola línea limpia.
* La macro **`mCopiarCadena`** utiliza etiquetas locales (`LOCAL`) para permitir expansiones seguras múltiples dentro de procedimientos complejos como `registrarProducto`.

---

### 2.3 Procedimiento con Directiva `USES`: `convertirEnteroACadena`
```assembly
convertirEnteroACadena PROC USES ebx ecx edx edi
    mov ebx, 10
    ; --- cuerpo de conversión ---
    mov BYTE PTR [edi], 0
    ret
convertirEnteroACadena ENDP
```

Gracias a `USES`, el ensamblador gestiona de forma automática los registros salvaguardados al entrar y salir de la rutina, reduciendo verbosidad y errores humanos.

---

## 3. Comparación de Líneas de Código Fuente

| Bloque Analizado | Versión Anterior | Versión Actual (Unidad 3) | Diferencia Neta |
| :--- | :---: | :---: | :---: |
| Mensajes sin salto de línea (20 usos) | 40 | 20 | -20 |
| Mensajes con salto de línea (44 usos) | 132 | 44 | -88 |
| Bloques `push`/`pop` manuales en 11 procedimientos | 58 | 0 | -58 |
| Transición de rutina de copia a macro | 16 | 10 | -6 |
| Declaración de macros nuevas[cite: 6, 7] | 0 | 10 | +10 |
| Gestión de teclado (`mLeeTeclado`) | 10 | 13 | +3 |
| Robustez del cargador y manejo de `CR/LF` | - | - | aprox. +4 |
| **Impacto Total Estimado** | — | — | **Aprox. -155 líneas** |

---

## 4. Resumen de la Tabla de Pruebas Clave

| No. | Módulo / Operación | Entrada de Prueba | Resultado Esperado |
| :---: | :--- | :--- | :--- |
| **1** | Inventario vacío | Opción `2` | `"No hay productos registrados"` |
| **2** | Registro válido | Opción `1`: `LAP-001`, `Lapiz`, `12.50`, `50` | `"Producto registrado"` |
| **4** | Mostrar inventario | Opción `2` | Despliegue correcto de filas tabuladas con precios e existencias |
| **18** | Venta sin descuento | Opción `5`: `LAP-001`, `5` unidades | Importe base correcto ($62.50 MXN) y balance de stock actualizado |
| **19** | Venta con descuento (10+ uds) | Opción `5`: `LAP-001`, `10` unidades | Aplicación automática del 10% de bonificación por volumen |
| **24** | Resumen de sesión | Opción `6` | Conteo de productos, unidades totales, valor global e ingresos acumulados |
| **25** | Guardar en archivo | Opción `7` | Generación exitosa de `inventario.txt` |
| **26** | Carga de inventario | Opción `8` (tras reinicio) | Restauración íntegra de la estructura desde disco (`Productos: 2`) |

> **Formato interno en disco (`inventario.txt`):**
> `INV1|LAP-001|Lapiz|1250|55|CUA-002|Cuaderno|4500|21|`

## 🛠️ Tecnologías y Entorno

- **Lenguaje:** Ensamblador (x86 - 32 bits)
- **Librería / Herramientas:** Irvine32 / MASM / Visual Studio
