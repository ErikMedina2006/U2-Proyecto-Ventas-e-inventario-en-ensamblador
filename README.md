# 🖥️ U2-Proyecto-Ventas-e-inventario-en-ensamblador

Repositorio oficial que contiene el desarrollo del proyecto de ventas e inventario de una papelería correspondiente a la **Unidad 2** de la materia de Lenguajes de Interfaz.

## 📋 Datos Generales

- **Materia:** Lenguajes de Interfaz
- **Unidad:** Unidad 2
- **Alumno:** Erik Vladimir Medina Pacheco
- **Docente:** *Doc. Medina Jimenez Jose Luis*
- **Horario:** *10:00 - 11:00*

## 📂 Contenido del Repositorio

- **Proyecto/** - Código fuente principal en ensamblador del sistema de inventario y ventas.
- **inventario.txt** - Archivo de datos base para la gestión de productos.

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

## 🛠️ Tecnologías y Entorno

- **Lenguaje:** Ensamblador (x86 - 32 bits)
- **Librería / Herramientas:** Irvine32 / MASM / Visual Studio
