# 🖥️ U2-Proyecto-Ventas-e-inventario-en-ensamblador

Repositorio oficial que contiene el desarrollo del proyecto de ventas e inventario de una papelería correspondiente a la **Unidad 2** de la materia de Lenguajes de Interfaz.

## 📋 Datos Generales

- **Materia:** Lenguajes de Interfaz
- **Unidad:** Unidad 2
- **Alumnos:**
- Erik Vladimir Medina Pacheco
- Jennifer Scarlet Lugo Matinez
- Oscar Mario Velarde Barraza
- **Docente:** *Doc. Medina Jimenez Jose Luis*
- **Horario:** *10:00 - 11:00*

## 📂 Contenido del Repositorio

- **Proyecto/** - Código fuente principal en ensamblador del sistema de inventario y ventas.
- **inventario.txt** - Archivo de datos base para la gestión de productos[cite: 2].

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
7. Guardar[cite: 2]
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
| 12 | Búsqueda existente |
