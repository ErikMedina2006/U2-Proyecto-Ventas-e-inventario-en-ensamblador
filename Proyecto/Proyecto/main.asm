INCLUDE Irvine32.inc

MaxProductos EQU 10
MaxLongitudNombre EQU 25
MaxNivelStock EQU 100
TamanoRegistro EQU 44
DesplazamientoCodigo EQU 0
DesplazamientoNombre EQU 8
DesplazamientoPrecio EQU 36
DesplazamientoStock EQU 40
MaxLongitudEntrada EQU 80      
MaxLimiteArchivo EQU 1023
MinLongitudDescripcion EQU 10
DivisorDescripcion EQU 10

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

mLeeTeclado MACRO
    push ecx
    push edx
    mov edx, OFFSET inBuf          
    mov ecx, MaxLongitudEntrada               
    call ReadString               
    pop edx
    pop ecx
ENDM

mCopiarCadena MACRO
    LOCAL ciclo_copia
ciclo_copia:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    cmp al, 0
    jne ciclo_copia
ENDM

.data
catalogo    BYTE MaxProductos*TamanoRegistro DUP(0)
tmpCat      BYTE MaxProductos*TamanoRegistro DUP(0)
numProd     DWORD 0
tmpCount    DWORD 0
ingresos    DWORD 0
numVentas   DWORD 0
dirty       DWORD 0
espInicial  DWORD ?

inBuf       BYTE MaxLongitudEntrada+1 DUP(0)
numBuf      BYTE 12 DUP(0)
tmpNum      BYTE 12 DUP(0)
tmpCode     BYTE 8 DUP(0)
tmpName     BYTE 28 DUP(0)
tmpPrecio   DWORD 0
tmpStock    DWORD 0
ventaBase   DWORD 0
ventaDesc   DWORD 0
ventaFinal  DWORD 0

fileBuf     BYTE MaxLimiteArchivo+1 DUP(0)
bytesSolic  DWORD 0
bytesLeidos DWORD 0
fHandle     DWORD 0
nombreArchivo BYTE "inventario.txt",0
txtCabecera  BYTE "INV1",0
txtBarra     BYTE "|",0

txtPeso      BYTE "$",0
txtPunto     BYTE ".",0
txtMXN       BYTE " MXN",0
sepBar       BYTE " | ",0
sepExist     BYTE " | Exist: ",0

msgBienvenida BYTE "PAPELERIA: Ventas e Inventario",0
msgMenu1     BYTE "1) Registrar producto",0
msgMenu2     BYTE "2) Mostrar inventario",0
msgMenu3     BYTE "3) Buscar por codigo",0
msgMenu4     BYTE "4) Recibir mercancia",0
msgMenu5     BYTE "5) Vender",0
msgMenu6     BYTE "6) Resumen",0
msgMenu7     BYTE "7) Guardar inventario",0
msgMenu8     BYTE "8) Cargar inventario",0
msgMenu9     BYTE "9) Ver regla de negocio",0
msgMenu0     BYTE "0) Salir",0
msgOpcion    BYTE "Opcion: ",0
msgOpInv     BYTE "Opcion invalida.",0
msgPila      BYTE "Pila desbalanceada",0
msgEntInv    BYTE "Entrada invalida: use solo digitos y respete el rango",0
msgVacio     BYTE "No hay productos registrados",0
msgLleno     BYTE "Capacidad maxima alcanzada (10 productos)",0
msgPideCod   BYTE "Codigo (ABC-123): ",0
msgCodInv    BYTE "Codigo invalido",0
msgDuplicado BYTE "Ese codigo ya existe",0
msgNoExiste  BYTE "No existe un producto con ese codigo",0
msgPideNom   BYTE "Nombre (1 a 25 caracteres): ",0
msgNomInv    BYTE "Nombre invalido (vacio, muy largo o con caracteres no permitidos)",0
msgPidePrecio BYTE "Precio en MXN (ej. 185.50): ",0
msgPrecioInv BYTE "Precio invalido",0
msgPideExist BYTE "Existencia inicial (0 a 100): ",0
msgAltaOk    BYTE "Producto registrado",0
msgEncab     BYTE "CODIGO  | NOMBRE | PRECIO | EXISTENCIA",0
msgNoHall    BYTE "Producto no encontrado",0
msgPideEntr  BYTE "Unidades recibidas (1 a 100): ",0
msgExcede    BYTE "La existencia excede las 100 unidades",0
msgRecibOk   BYTE "Mercancia recibida. Nueva existencia: ",0
msgPideCant  BYTE "Cantidad a vender (1 a 100): ",0
msgSinStock  BYTE "Existencias insuficientes. Disponibles: ",0
msgOvf       BYTE "Desbordamiento en el calculo",0
msgVentaOk   BYTE "Venta aceptada: ",0
msgBase      BYTE "Importe base: ",0
msgDesc      BYTE "Descuento 10% por cantidad (10+ unidades): -",0
msgTotal     BYTE "Total a pagar: ",0
msgResTit    BYTE "RESUMEN",0
msgResProd   BYTE "Productos registrados: ",0
msgResUni    BYTE "Unidades disponibles: ",0
msgResVal    BYTE "Valor del inventario: ",0
msgResVen    BYTE "Ventas aceptadas: ",0
msgResIng    BYTE "Ingresos de la sesion: ",0
msgGuardado  BYTE "Inventario guardado en inventario.txt",0
msgErrCrear  BYTE "No se pudo crear el archivo.",0
msgErrEscr   BYTE "No se escribieron todos los bytes.",0
msgNoArch    BYTE "El archivo inventario.txt no existe",0
msgErrLect   BYTE "Error al leer el archivo",0
msgGrande    BYTE "Archivo demasiado grande",0
msgCorrupto  BYTE "Archivo invalido o danado",0
msgCargaOk   BYTE "Inventario cargado correctamente. Productos: ",0
msgCargaDirty BYTE "Hay cambios sin guardar que se perderian. Continuar? (S/N): ",0
msgSalirDirty BYTE "Hay cambios sin guardar. Guardar antes de salir? (S/N): ",0
msgDescartar BYTE "Salir SIN guardar? (S/N): ",0
msgAdios     BYTE "Hasta luego.",0
msgSinDesc   BYTE "    Sin descuento (menos de 10 unidades).",0
msgRegla     BYTE "REGLA DEL NEGOCIO: DESCUENTO POR CANTIDAD",0
msgRegla1    BYTE "Se aplica cuando una venta lleva 10 o mas unidades de un producto",0
msgRegla2    BYTE "Descuento = 10% del importe base (precio x cantidad); la fraccion",0
msgRegla3    BYTE "de centavo se descarta. Con menos de 10 unidades no hay descuento",0
msgRegla4    BYTE "Ejemplo: 10 x $20.00 = $200.00 -> descuento $20.00 -> total $180.00",0
msgRegla5    BYTE "Ejemplo: 9 x $20.00 = $180.00 -> sin descuento -> total $180.00",0

.code

leerLineaTeclado PROC USES ecx edx
    mLeeTeclado
    ret
leerLineaTeclado ENDP

convertirCadenaAEntero PROC USES esi ecx edx
    xor eax, eax
    cmp BYTE PTR [esi], 0
    je convertirCadenaAEnteroError                                     
convertirCadenaAEnteroCicloDigitos:
    movzx ecx, BYTE PTR [esi]
    cmp ecx, 0
    je convertirCadenaAEnteroExito
    sub ecx, '0'                        
    cmp ecx, 9
    ja convertirCadenaAEnteroError                                     
    imul eax, eax, 10                     
    add eax, ecx                        
    cmp eax, ebx
    ja convertirCadenaAEnteroError                                     
    inc esi
    jmp convertirCadenaAEnteroCicloDigitos
convertirCadenaAEnteroExito:
    clc
    jmp convertirCadenaAEnteroFin
convertirCadenaAEnteroError:
    xor eax, eax
    stc
convertirCadenaAEnteroFin:
    ret
convertirCadenaAEntero ENDP

convertirPrecioACentavos PROC USES ecx edx esi
    xor eax, eax                          
    xor ecx, ecx                          
convertirPrecioACentavosCicloPesos:
    movzx edx, BYTE PTR [esi]
    cmp edx, '.'
    je convertirPrecioACentavosConPunto
    cmp edx, 0
    je convertirPrecioACentavosSinPunto
    sub edx, '0'
    cmp edx, 9
    ja convertirPrecioACentavosError
    imul eax, eax, 10
    add eax, edx
    cmp eax, 9999
    ja convertirPrecioACentavosError
    inc ecx
    inc esi
    jmp convertirPrecioACentavosCicloPesos
convertirPrecioACentavosSinPunto:
    test ecx, ecx
    jz convertirPrecioACentavosError
    imul eax, eax, 100                    
    jmp convertirPrecioACentavosValidarMinimo
convertirPrecioACentavosConPunto:
    test ecx, ecx
    jz convertirPrecioACentavosError                       
    imul eax, eax, 100
    inc esi                               
    movzx edx, BYTE PTR [esi]             
    sub edx, '0'
    cmp edx, 9
    ja convertirPrecioACentavosError
    imul edx, edx, 10                     
    add eax, edx
    inc esi
    movzx edx, BYTE PTR [esi]             
    cmp edx, 0
    je convertirPrecioACentavosValidarMinimo
    sub edx, '0'
    cmp edx, 9
    ja convertirPrecioACentavosError
    add eax, edx
    inc esi
    cmp BYTE PTR [esi], 0
    jne convertirPrecioACentavosError                       
convertirPrecioACentavosValidarMinimo:
    test eax, eax
    jz convertirPrecioACentavosError                       
    clc
    jmp convertirPrecioACentavosFin
convertirPrecioACentavosError:
    xor eax, eax
    stc
convertirPrecioACentavosFin:
    ret
convertirPrecioACentavos ENDP

convertirEnteroACadena PROC USES ebx ecx edx edi
    mov ebx, 10
    xor ecx, ecx                          
convertirEnteroACadenaDividir:
    xor edx, edx
    div ebx                               
    add edx, '0'                          
    push edx                              
    inc ecx
    test eax, eax
    jnz convertirEnteroACadenaDividir
    mov eax, ecx                          
convertirEnteroACadenaEscribirDigitos:
    pop edx                               
    mov [edi], dl
    inc edi
    loop convertirEnteroACadenaEscribirDigitos                          
    mov BYTE PTR [edi], 0               
    ret
convertirEnteroACadena ENDP

mostrarEntero PROC USES eax edx edi
    mov edi, OFFSET numBuf
    call convertirEnteroACadena
    mov edx, edi
    call WriteString
    ret
mostrarEntero ENDP

mostrarImporteMXN PROC USES eax ebx edx
    mov edx, OFFSET txtPeso
    call WriteString                      
    mov ebx, 100
    xor edx, edx                          
    div ebx                               
    push edx                              
    call mostrarEntero                    
    mov edx, OFFSET txtPunto
    call WriteString
    pop eax                               
    mov ebx, 10
    xor edx, edx
    div ebx                               
    add al, '0'
    call WriteChar                        
    mov al, dl
    add al, '0'
    call WriteChar
    mov edx, OFFSET txtMXN
    call WriteString
    ret
mostrarImporteMXN ENDP

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

validarFormatoCodigo PROC USES ebx ecx
    xor ebx, ebx
    mov ecx, 3
validarFormatoCodigoLetras:
    mov al, [esi+ebx]
    cmp al, 'A'
    jb validarFormatoCodigoInvalido
    cmp al, 'Z'
    ja validarFormatoCodigoInvalido
    inc ebx
    loop validarFormatoCodigoLetras
    cmp BYTE PTR [esi+3], '-'
    jne validarFormatoCodigoInvalido
    mov ebx, 4
    mov ecx, 3
validarFormatoCodigoDigitos:
    mov al, [esi+ebx]
    cmp al, '0'
    jb validarFormatoCodigoInvalido
    cmp al, '9'
    ja validarFormatoCodigoInvalido
    inc ebx
    loop validarFormatoCodigoDigitos
    cmp BYTE PTR [esi+7], 0
    jne validarFormatoCodigoInvalido                      
    mov eax, 1
    jmp validarFormatoCodigoFin
validarFormatoCodigoInvalido:
    xor eax, eax
validarFormatoCodigoFin:
    ret
validarFormatoCodigo ENDP

validarFormatoNombre PROC USES ebx
    xor ebx, ebx
    cmp BYTE PTR [esi], ' '
    jbe validarFormatoNombreInvalido                    
validarFormatoNombreCiclo:
    mov al, [esi+ebx]
    cmp al, 0
    je validarFormatoNombreValido
    cmp al, ' '
    jb validarFormatoNombreInvalido
    cmp al, '~'
    ja validarFormatoNombreInvalido
    cmp al, '|'
    je validarFormatoNombreInvalido                     
    inc ebx
    cmp ebx, MaxLongitudNombre
    jbe validarFormatoNombreCiclo
    jmp validarFormatoNombreInvalido                    
validarFormatoNombreValido:
    mov eax, 1
    jmp validarFormatoNombreFin
validarFormatoNombreInvalido:
    xor eax, eax
validarFormatoNombreFin:
    ret
validarFormatoNombre ENDP

buscarCodigoEnArreglo PROC USES ebx ecx edx
    test ecx, ecx
    jz buscarCodigoEnArregloNoEncontrado
buscarCodigoEnArregloSiguienteRegistro:
    xor ebx, ebx                          
buscarCodigoEnArregloCompararCaracter:
    mov al, [esi+ebx]
    mov dl, [edi+ebx]
    cmp al, dl
    jne buscarCodigoEnArregloAvanzarRegistro                    
    cmp al, 0
    je buscarCodigoEnArregloEncontrado                    
    inc ebx
    jmp buscarCodigoEnArregloCompararCaracter
buscarCodigoEnArregloAvanzarRegistro:
    add esi, TamanoRegistro               
    dec ecx
    jnz buscarCodigoEnArregloSiguienteRegistro
buscarCodigoEnArregloNoEncontrado:
    xor eax, eax
    jmp buscarCodigoEnArregloFin
buscarCodigoEnArregloEncontrado:
    mov eax, 1
buscarCodigoEnArregloFin:
    ret
buscarCodigoEnArreglo ENDP

buscarCodigoEnCatalogo PROC
    push ecx
    mov esi, OFFSET catalogo
    mov ecx, numProd
    call buscarCodigoEnArreglo
    pop ecx
    ret
buscarCodigoEnCatalogo ENDP

pedirCodigoDeProductoExistente PROC
    push edi
    mImprimirMensaje msgPideCod
    call leerLineaTeclado
    mov esi, OFFSET inBuf
    call validarFormatoCodigo
    test eax, eax
    jnz pedirCodigoDeProductoExistenteFormatoValido
    mImprimirLinea msgCodInv
    xor eax, eax
    jmp pedirCodigoDeProductoExistenteFin
pedirCodigoDeProductoExistenteFormatoValido:
    mov edi, OFFSET inBuf
    call buscarCodigoEnCatalogo
    test eax, eax
    jnz pedirCodigoDeProductoExistenteFin
    mImprimirLinea msgNoExiste
    xor eax, eax
pedirCodigoDeProductoExistenteFin:
    pop edi
    ret
pedirCodigoDeProductoExistente ENDP

mostrarRegistroProducto PROC
    push eax
    push edx
    lea edx, [esi+DesplazamientoCodigo]
    call WriteString
    mImprimirMensaje sepBar
    lea edx, [esi+DesplazamientoNombre]
    call WriteString
    mImprimirMensaje sepBar
    mov eax, [esi+DesplazamientoPrecio]
    call mostrarImporteMXN
    mImprimirMensaje sepExist
    mov eax, [esi+DesplazamientoStock]
    call mostrarEntero
    call Crlf
    pop edx
    pop eax
    ret
mostrarRegistroProducto ENDP

mostrarInventario PROC
    push ecx
    push edx
    push esi
    cmp numProd, 0
    jne mostrarInventarioConProductos
    mImprimirLinea msgVacio
    jmp mostrarInventarioFin
mostrarInventarioConProductos:
    mImprimirLinea msgEncab
    mov esi, OFFSET catalogo        
    mov ecx, numProd
mostrarInventarioCiclo:
    call mostrarRegistroProducto
    add esi, TamanoRegistro               
    loop mostrarInventarioCiclo
mostrarInventarioFin:
    pop esi
    pop edx
    pop ecx
    ret
mostrarInventario ENDP

registrarProducto PROC
    pushad
    cmp numProd, MaxProductos
    jb registrarProductoHayLugar
    mImprimirLinea msgLleno
    jmp registrarProductoFin
registrarProductoHayLugar:
    mImprimirMensaje msgPideCod
    call leerLineaTeclado
    mov esi, OFFSET inBuf
    call validarFormatoCodigo
    test eax, eax
    jnz registrarProductoCodigoValido
    mImprimirLinea msgCodInv
    jmp registrarProductoFin
registrarProductoCodigoValido:
    mov edi, OFFSET inBuf
    call buscarCodigoEnCatalogo
    test eax, eax
    jz registrarProductoSinDuplicado
    mImprimirLinea msgDuplicado
    jmp registrarProductoFin
registrarProductoSinDuplicado:
    mov esi, OFFSET inBuf
    mov edi, OFFSET tmpCode
    mCopiarCadena                       
    mImprimirMensaje msgPideNom
    call leerLineaTeclado
    mov esi, OFFSET inBuf
    call validarFormatoNombre
    test eax, eax
    jnz registrarProductoNombreValido
    mImprimirLinea msgNomInv
    jmp registrarProductoFin
registrarProductoNombreValido:
    mov edi, OFFSET tmpName
    mCopiarCadena
    mImprimirMensaje msgPidePrecio
    call leerLineaTeclado
    mov esi, OFFSET inBuf
    call convertirPrecioACentavos
    jnc registrarProductoPrecioValido
    mImprimirLinea msgPrecioInv
    jmp registrarProductoFin
registrarProductoPrecioValido:
    mov tmpPrecio, eax
    mov edx, OFFSET msgPideExist
    mov ebx, MaxNivelStock
    xor ecx, ecx                          
    call pedirEnteroEnRango
    jc registrarProductoFin
    mov tmpStock, eax
    imul eax, numProd, TamanoRegistro   
    mov ebx, OFFSET catalogo
    add ebx, eax                          
    lea edi, [ebx+DesplazamientoCodigo]
    mov esi, OFFSET tmpCode
    mCopiarCadena
    lea edi, [ebx+DesplazamientoNombre]
    mov esi, OFFSET tmpName
    mCopiarCadena
    mov eax, tmpPrecio
    mov [ebx+DesplazamientoPrecio], eax
    mov eax, tmpStock
    mov [ebx+DesplazamientoStock], eax
    inc numProd
    mov dirty, 1
    mImprimirLinea msgAltaOk
registrarProductoFin:
    popad
    ret
registrarProducto ENDP

buscarProducto PROC
    pushad
    call pedirCodigoDeProductoExistente
    test eax, eax
    jz buscarProductoFin
    mImprimirLinea msgEncab
    call mostrarRegistroProducto          
buscarProductoFin:
    popad
    ret
buscarProducto ENDP

recibirMercancia PROC
    pushad
    call pedirCodigoDeProductoExistente
    test eax, eax
    jz recibirMercanciaFin
    mov edx, OFFSET msgPideEntr
    mov ebx, MaxNivelStock
    mov ecx, 1
    call pedirEnteroEnRango
    jc recibirMercanciaFin
    add eax, [esi+DesplazamientoStock]      
    cmp eax, MaxNivelStock
    jbe recibirMercanciaAceptada
    mImprimirLinea msgExcede      
    jmp recibirMercanciaFin
recibirMercanciaAceptada:
    mov [esi+DesplazamientoStock], eax
    mov dirty, 1
    mImprimirMensaje msgRecibOk
    call mostrarEntero
    call Crlf
recibirMercanciaFin:
    popad
    ret
recibirMercancia ENDP

venderProducto PROC
    pushad
    call pedirCodigoDeProductoExistente
    test eax, eax
    jz venderProductoFin
    mov edx, OFFSET msgPideCant
    mov ebx, MaxNivelStock
    mov ecx, 1
    call pedirEnteroEnRango
    jc venderProductoFin
    mov ebx, eax                          
    cmp ebx, [esi+DesplazamientoStock]
    jbe venderProductoExistenciaSuficiente
    mImprimirMensaje msgSinStock
    mov eax, [esi+DesplazamientoStock]
    call mostrarEntero
    call Crlf
    jmp venderProductoFin
venderProductoExistenciaSuficiente:
    mov eax, [esi+DesplazamientoPrecio]
    mul ebx                               
    jc venderProductoDesbordamiento                           
    mov ventaBase, eax
    mov ventaDesc, 0
    cmp ebx, MinLongitudDescripcion             
    jb venderProductoSinDescuento
    xor edx, edx
    mov ecx, DivisorDescripcion
    div ecx                               
    mov ventaDesc, eax
venderProductoSinDescuento:
    mov eax, ventaBase
    sub eax, ventaDesc                    
    mov ventaFinal, eax
    mov ecx, ingresos
    add ecx, eax                          
    jc venderProductoDesbordamiento                           
    mov ingresos, ecx
    sub [esi+DesplazamientoStock], ebx
    inc numVentas
    mov dirty, 1
    mImprimirMensaje msgVentaOk
    lea edx, [esi+DesplazamientoNombre]
    call WriteString
    call Crlf
    mImprimirMensaje msgBase
    mov eax, ventaBase
    call mostrarImporteMXN
    call Crlf
    cmp ventaDesc, 0
    je venderProductoMostrarSinDescuento
    mImprimirMensaje msgDesc
    mov eax, ventaDesc
    call mostrarImporteMXN
    call Crlf
    jmp venderProductoMostrarTotal
venderProductoMostrarSinDescuento:
    mImprimirLinea msgSinDesc    
venderProductoMostrarTotal:
    mImprimirMensaje msgTotal
    mov eax, ventaFinal
    call mostrarImporteMXN
    call Crlf
    jmp venderProductoFin
venderProductoDesbordamiento:
    mImprimirLinea msgOvf
venderProductoFin:
    popad
    ret
venderProducto ENDP

mostrarResumen PROC
    pushad
    xor ebx, ebx                          
    xor edi, edi                          
    mov esi, OFFSET catalogo
    mov ecx, numProd
    test ecx, ecx
    jz mostrarResumenMostrar
mostrarResumenCiclo:
    mov eax, [esi+DesplazamientoStock]
    add ebx, eax
    mov edx, 0                            ; CORRECCIÓN: Limpiar edx antes de mul
    mul DWORD PTR [esi+DesplazamientoPrecio]  
    cmp edx, 0                            ; CORRECCIÓN: Verificar desbordamiento de 64 bits en la multiplicación
    jne mostrarResumenDesbordamiento
    add edi, eax
    jc mostrarResumenDesbordamiento
    add esi, TamanoRegistro
    dec ecx
    jnz mostrarResumenCiclo
mostrarResumenMostrar:
    mImprimirLinea msgResTit
    mImprimirMensaje msgResProd
    mov eax, numProd
    call mostrarEntero
    call Crlf
    mImprimirMensaje msgResUni
    mov eax, ebx
    call mostrarEntero
    call Crlf
    mImprimirMensaje msgResVal
    mov eax, edi
    call mostrarImporteMXN
    call Crlf
    mImprimirMensaje msgResVen
    mov eax, numVentas
    call mostrarEntero
    call Crlf
    mImprimirMensaje msgResIng
    mov eax, ingresos
    call mostrarImporteMXN
    call Crlf
    jmp mostrarResumenFin
mostrarResumenDesbordamiento:
    mImprimirLinea msgOvf
mostrarResumenFin:
    popad
    ret
mostrarResumen ENDP

guardarInventarioEnArchivo PROC USES ebx ecx edx esi edi
    mov edi, OFFSET fileBuf           
    mov edx, OFFSET txtCabecera
    call agregarCadenaABuffer
    mov edx, OFFSET txtBarra
    call agregarCadenaABuffer
    mov esi, OFFSET catalogo
    mov ecx, numProd
    test ecx, ecx
    jz guardarInventarioEnArchivoEscribir
guardarInventarioEnArchivoCicloProductos:
    lea edx, [esi+DesplazamientoCodigo]
    call agregarCadenaABuffer
    mov edx, OFFSET txtBarra
    call agregarCadenaABuffer
    lea edx, [esi+DesplazamientoNombre]
    call agregarCadenaABuffer
    mov edx, OFFSET txtBarra
    call agregarCadenaABuffer
    mov eax, [esi+DesplazamientoPrecio]
    call agregarEnteroABuffer
    mov edx, OFFSET txtBarra
    call agregarCadenaABuffer
    mov eax, [esi+DesplazamientoStock]
    call agregarEnteroABuffer
    mov edx, OFFSET txtBarra
    call agregarCadenaABuffer
    add esi, TamanoRegistro
    dec ecx
    jnz guardarInventarioEnArchivoCicloProductos
guardarInventarioEnArchivoEscribir:
    sub edi, OFFSET fileBuf           
    mov bytesSolic, edi
    mov edx, OFFSET nombreArchivo
    call CreateOutputFile                 
    cmp eax, INVALID_HANDLE_VALUE
    jne guardarInventarioEnArchivoAbierto
    mImprimirLinea msgErrCrear
    xor eax, eax
    jmp guardarInventarioEnArchivoFin
guardarInventarioEnArchivoAbierto:
    mov fHandle, eax
    mov edx, OFFSET fileBuf
    mov ecx, bytesSolic
    call WriteToFile                      
    mov ebx, eax
    mov eax, fHandle
    call CloseFile
    cmp ebx, bytesSolic                   
    je guardarInventarioEnArchivoExito
    mImprimirLinea msgErrEscr
    xor eax, eax
    jmp guardarInventarioEnArchivoFin
guardarInventarioEnArchivoExito:
    mov dirty, 0
    mImprimirLinea msgGuardado
    mov eax, 1
guardarInventarioEnArchivoFin:
    ret
guardarInventarioEnArchivo ENDP

agregarCadenaABuffer PROC
    push eax
    push edx
agregarCadenaABufferCiclo:
    mov al, [edx]
    cmp al, 0
    je agregarCadenaABufferFin
    mov [edi], al
    inc edx
    inc edi
    jmp agregarCadenaABufferCiclo
agregarCadenaABufferFin:
    pop edx
    pop eax
    ret
agregarCadenaABuffer ENDP

agregarEnteroABuffer PROC
    push eax
    call convertirEnteroACadena           
    add edi, eax
    pop eax
    ret
agregarEnteroABuffer ENDP

copiarCampoHastaDelimitador PROC USES ebx
    xor ebx, ebx                          
copiarCampoHastaDelimitadorCiclo:
    mov al, [esi]
    cmp al, 10                          
    je copiarCampoHastaDelimitadorOmitir
    cmp al, 13                          
    je copiarCampoHastaDelimitadorOmitir
    cmp al, dl
    je copiarCampoHastaDelimitadorDelimitadorEncontrado
    cmp al, 0
    je copiarCampoHastaDelimitadorError
    cmp ebx, ecx
    jae copiarCampoHastaDelimitadorError                        
    mov [edi+ebx], al
    inc ebx
    inc esi
    jmp copiarCampoHastaDelimitadorCiclo
copiarCampoHastaDelimitadorOmitir:
    inc esi
    jmp copiarCampoHastaDelimitadorCiclo
copiarCampoHastaDelimitadorDelimitadorEncontrado:
    mov BYTE PTR [edi+ebx], 0
    inc esi                       
    mov eax, 1
    jmp copiarCampoHastaDelimitadorFin
copiarCampoHastaDelimitadorError:
    xor eax, eax
copiarCampoHastaDelimitadorFin:
    ret
copiarCampoHastaDelimitador ENDP

convertirLineaARegistro PROC
    push ebx
    push ecx
    push edx
    push edi
    mov ebx, edi                    
    lea edi, [ebx+DesplazamientoCodigo]
    mov ecx, 7
    mov dl, '|'
    call copiarCampoHastaDelimitador
    test eax, eax
    jz convertirLineaARegistroInvalida
    push esi
    lea esi, [ebx+DesplazamientoCodigo]
    call validarFormatoCodigo
    pop esi
    test eax, eax
    jz convertirLineaARegistroInvalida
    lea edi, [ebx+DesplazamientoNombre]
    mov ecx, MaxLongitudNombre
    mov dl, '|'
    call copiarCampoHastaDelimitador
    test eax, eax
    jz convertirLineaARegistroInvalida
    push esi
    lea esi, [ebx+DesplazamientoNombre]
    call validarFormatoNombre
    pop esi
    test eax, eax
    jz convertirLineaARegistroInvalida
    mov edi, OFFSET tmpNum          
    mov ecx, 6
    mov dl, '|'
    call copiarCampoHastaDelimitador
    test eax, eax
    jz convertirLineaARegistroInvalida
    push esi
    push ebx
    mov esi, OFFSET tmpNum
    mov ebx, 999999
    call convertirCadenaAEntero
    pop ebx
    pop esi
    jc convertirLineaARegistroInvalida
    test eax, eax
    jz convertirLineaARegistroInvalida
    mov [ebx+DesplazamientoPrecio], eax
    mov edi, OFFSET tmpNum          
    mov ecx, 3
    mov dl, '|'
    call copiarCampoHastaDelimitador
    test eax, eax
    jz convertirLineaARegistroInvalida
    push esi
    push ebx
    mov esi, OFFSET tmpNum
    mov ebx, MaxNivelStock
    call convertirCadenaAEntero
    pop ebx
    pop esi
    jc convertirLineaARegistroInvalida
    mov [ebx+DesplazamientoStock], eax
    mov eax, 1
    jmp convertirLineaARegistroFin
convertirLineaARegistroInvalida:
    xor eax, eax
convertirLineaARegistroFin:
    pop edi
    pop edx
    pop ecx
    pop ebx
    ret
convertirLineaARegistro ENDP

confirmarConSiONo PROC
    call WriteString
    call leerLineaTeclado
    xor eax, eax
    mov al, inBuf
    cmp al, 'S'
    je confirmarConSiONoAfirmativo
    cmp al, 's'
    je confirmarConSiONoAfirmativo
    xor eax, eax
    ret
confirmarConSiONoAfirmativo:
    mov eax, 1
    ret
confirmarConSiONo ENDP

cargarInventarioDesdeArchivo PROC
    pushad
    cmp dirty, 0
    je cargarInventarioDesdeArchivoAbrir
    mov edx, OFFSET msgCargaDirty
    call confirmarConSiONo
    test eax, eax
    jz cargarInventarioDesdeArchivoFin
cargarInventarioDesdeArchivoAbrir:
    mov edx, OFFSET nombreArchivo
    call OpenInputFile              
    cmp eax, INVALID_HANDLE_VALUE
    jne cargarInventarioDesdeArchivoLeer
    mImprimirLinea msgNoArch
    jmp cargarInventarioDesdeArchivoFin
cargarInventarioDesdeArchivoLeer:
    mov fHandle, eax
    mov edx, OFFSET fileBuf
    mov ecx, MaxLimiteArchivo               
    call ReadFromFile                     
    jc cargarInventarioDesdeArchivoErrorLectura
    mov bytesLeidos, eax
    mov eax, fHandle
    call CloseFile
    mov eax, bytesLeidos
    test eax, eax
    jz cargarInventarioDesdeArchivoCorrupto                     
    cmp eax, MaxLimiteArchivo
    jae cargarInventarioDesdeArchivoMuyGrande                   
    mov BYTE PTR fileBuf[eax], 0  
    cld
    mov edi, OFFSET tmpCat
    mov ecx, MaxProductos*TamanoRegistro
    xor al, al
    rep stosb
    mov tmpCount, 0
    mov esi, OFFSET fileBuf
    mov edi, OFFSET txtCabecera
    mov ecx, 4
cargarInventarioDesdeArchivoComparaCabecera:
    mov al, [esi]
    cmp al, [edi]
    jne cargarInventarioDesdeArchivoCorrupto
    inc esi
    inc edi
    loop cargarInventarioDesdeArchivoComparaCabecera
    cmp BYTE PTR [esi], '|'
    jne cargarInventarioDesdeArchivoCorrupto
    inc esi
    mov edi, OFFSET tmpCat          
cargarInventarioDesdeArchivoCicloLineas:
    mov al, [esi]
    cmp al, 0
    je cargarInventarioDesdeArchivoFinLineas
    cmp al, 13
    je cargarInventarioDesdeArchivoOmitirCRLF
    cmp al, 10
    je cargarInventarioDesdeArchivoOmitirCRLF

    cmp tmpCount, MaxProductos
    jae cargarInventarioDesdeArchivoCorrupto      
    call convertirLineaARegistro                    
    test eax, eax
    jz cargarInventarioDesdeArchivoCorrupto
    push esi
    push edi
    mov esi, OFFSET tmpCat          
    mov ecx, tmpCount
    call buscarCodigoEnArreglo                      
    pop edi
    pop esi
    test eax, eax
    jnz cargarInventarioDesdeArchivoCorrupto
    inc tmpCount
    add edi, TamanoRegistro
    jmp cargarInventarioDesdeArchivoCicloLineas

cargarInventarioDesdeArchivoOmitirCRLF:
    inc esi
    jmp cargarInventarioDesdeArchivoCicloLineas

cargarInventarioDesdeArchivoFinLineas:
    cld
    mov esi, OFFSET tmpCat
    mov edi, OFFSET catalogo
    mov ecx, MaxProductos*TamanoRegistro
    rep movsb
    mov eax, tmpCount
    mov numProd, eax
    mov dirty, 0
    mImprimirMensaje msgCargaOk
    mov eax, numProd
    call mostrarEntero
    call Crlf
    jmp cargarInventarioDesdeArchivoFin
cargarInventarioDesdeArchivoErrorLectura:
    mov eax, fHandle
    call CloseFile
    mImprimirLinea msgErrLect
    jmp cargarInventarioDesdeArchivoFin
cargarInventarioDesdeArchivoMuyGrande:
    mImprimirLinea msgGrande
    jmp cargarInventarioDesdeArchivoFin
cargarInventarioDesdeArchivoCorrupto:
    mImprimirLinea msgCorrupto
cargarInventarioDesdeArchivoFin:
    popad
    ret
cargarInventarioDesdeArchivo ENDP

mostrarReglaDescuento PROC
    mImprimirLinea msgRegla
    mImprimirLinea msgRegla1
    mImprimirLinea msgRegla2
    mImprimirLinea msgRegla3
    mImprimirLinea msgRegla4
    mImprimirLinea msgRegla5
    ret
mostrarReglaDescuento ENDP

mostrarMenu PROC
    call Crlf
    mImprimirLinea msgMenu1
    mImprimirLinea msgMenu2
    mImprimirLinea msgMenu3
    mImprimirLinea msgMenu4
    mImprimirLinea msgMenu5
    mImprimirLinea msgMenu6
    mImprimirLinea msgMenu7
    mImprimirLinea msgMenu8
    mImprimirLinea msgMenu9
    mImprimirLinea msgMenu0
    ret
mostrarMenu ENDP

main PROC
    mov espInicial, esp
    mImprimirLinea msgBienvenida
menuPrincipal:
    call mostrarMenu
    mImprimirMensaje msgOpcion
    call leerLineaTeclado
    mov esi, OFFSET inBuf
    mov ebx, 9
    call convertirCadenaAEntero
    jc opcionInvalida
    cmp eax, 1
    jne revisarOpcion2
    call registrarProducto
    jmp verificarPila
revisarOpcion2:
    cmp eax, 2
    jne revisarOpcion3
    call mostrarInventario
    jmp verificarPila
revisarOpcion3:
    cmp eax, 3
    jne revisarOpcion4
    call buscarProducto
    jmp verificarPila
revisarOpcion4:
    cmp eax, 4
    jne revisarOpcion5
    call recibirMercancia
    jmp verificarPila
revisarOpcion5:
    cmp eax, 5
    jne revisarOpcion6
    call venderProducto
    jmp verificarPila
revisarOpcion6:
    cmp eax, 6
    jne revisarOpcion7
    call mostrarResumen
    jmp verificarPila
revisarOpcion7:
    cmp eax, 7
    jne revisarOpcion8
    call guardarInventarioEnArchivo
    jmp verificarPila
revisarOpcion8:
    cmp eax, 8
    jne revisarOpcion9
    call cargarInventarioDesdeArchivo
    jmp verificarPila
revisarOpcion9:
    cmp eax, 9
    jne revisarOpcion0
    call mostrarReglaDescuento
    jmp verificarPila
revisarOpcion0:
    test eax, eax
    jnz opcionInvalida                     
    cmp dirty, 0
    je salirConfirmado
    mov edx, OFFSET msgSalirDirty
    call confirmarConSiONo
    test eax, eax
    jz salirSinGuardar
    call guardarInventarioEnArchivo
    test eax, eax
    jz verificarPila                        
    jmp salirConfirmado
salirSinGuardar:
    mov edx, OFFSET msgDescartar
    call confirmarConSiONo
    test eax, eax
    jz verificarPila                        
salirConfirmado:
    mImprimirLinea msgAdios
    exit
opcionInvalida:
    mImprimirLinea msgOpInv
verificarPila:
    cmp esp, espInicial           
    je menuPrincipal
    mImprimirLinea msgPila
    exit
main ENDP
END main