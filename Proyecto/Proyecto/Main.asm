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

.data
catalogo    BYTE MaxProductos*TamanoRegistro DUP(0)
tmpCat       BYTE MaxProductos*TamanoRegistro DUP(0)
numProd      DWORD 0
tmpCount     DWORD 0
ingresos     DWORD 0
numVentas    DWORD 0
dirty        DWORD 0
espInicial   DWORD ?

inBuf        BYTE MaxLongitudEntrada+1 DUP(0)
numBuf       BYTE 12 DUP(0)
tmpNum       BYTE 12 DUP(0)
tmpCode      BYTE 8 DUP(0)
tmpName      BYTE 28 DUP(0)
tmpPrecio    DWORD 0
tmpStock     DWORD 0
ventaBase    DWORD 0
ventaDesc    DWORD 0
ventaFinal   DWORD 0

fileBuf      BYTE MaxLimiteArchivo+1 DUP(0)
bytesSolic   DWORD 0
bytesLeidos  DWORD 0
fHandle      DWORD 0
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
msgSinDesc   BYTE "  Sin descuento (menos de 10 unidades).",0
msgRegla     BYTE "REGLA DEL NEGOCIO: DESCUENTO POR CANTIDAD",0
msgRegla1    BYTE "Se aplica cuando una venta lleva 10 o mas unidades de un producto",0
msgRegla2    BYTE "Descuento = 10% del importe base (precio x cantidad); la fraccion",0
msgRegla3    BYTE "de centavo se descarta. Con menos de 10 unidades no hay descuento",0
msgRegla4    BYTE "Ejemplo: 10 x $20.00 = $200.00 -> descuento $20.00 -> total $180.00",0
msgRegla5    BYTE "Ejemplo: 9 x $20.00 = $180.00 -> sin descuento -> total $180.00",0

.code

leerLineaTeclado PROC
    push ecx
    push edx
    mov edx, OFFSET inBuf          
    mov ecx, MaxLongitudEntrada                    
    call ReadString               
    pop edx
    pop ecx
    ret
leerLineaTeclado ENDP

convertirCadenaAEntero PROC
    push esi
    push ecx
    push edx
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
    pop edx
    pop ecx
    pop esi
    ret
convertirCadenaAEntero ENDP

convertirPrecioACentavos PROC
    push ecx
    push edx
    push esi
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
    pop esi
    pop edx
    pop ecx
    ret
convertirPrecioACentavos ENDP

convertirEnteroACadena PROC
    push ebx
    push ecx
    push edx
    push edi
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
    pop edi
    pop edx
    pop ecx
    pop ebx
    ret
convertirEnteroACadena ENDP

mostrarEntero PROC
    push eax
    push edx
    push edi
    mov edi, OFFSET numBuf
    call convertirEnteroACadena
    mov edx, edi
    call WriteString
    pop edi
    pop edx
    pop eax
    ret
mostrarEntero ENDP

mostrarImporteMXN PROC
    push eax
    push ebx
    push edx
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
    pop edx
    pop ebx
    pop eax
    ret
mostrarImporteMXN ENDP

pedirEnteroEnRango PROC
    push esi
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
    push edx
    mov edx, OFFSET msgEntInv
    call WriteString
    call Crlf
    pop edx
    xor eax, eax
    stc
pedirEnteroEnRangoFin:
    pop esi
    ret
pedirEnteroEnRango ENDP

validarFormatoCodigo PROC
    push ebx
    push ecx
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
    pop ecx
    pop ebx
    ret
validarFormatoCodigo ENDP

validarFormatoNombre PROC
    push ebx
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
    pop ebx
    ret
validarFormatoNombre ENDP

copiarCadenaCompleta PROC
    push esi
    push edi
    push eax
copiarCadenaCompletaCiclo:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    cmp al, 0
    jne copiarCadenaCompletaCiclo
    pop eax
    pop edi
    pop esi
    ret
copiarCadenaCompleta ENDP

buscarCodigoEnArreglo PROC
    push ebx
    push ecx
    push edx
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
    pop edx
    pop ecx
    pop ebx
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
    mov edx, OFFSET msgPideCod
    call WriteString
    call leerLineaTeclado
    mov esi, OFFSET inBuf
    call validarFormatoCodigo
    test eax, eax
    jnz pedirCodigoDeProductoExistenteFormatoValido
    mov edx, OFFSET msgCodInv
    call WriteString
    call Crlf
    xor eax, eax
    jmp pedirCodigoDeProductoExistenteFin
pedirCodigoDeProductoExistenteFormatoValido:
    mov edi, OFFSET inBuf
    call buscarCodigoEnCatalogo
    test eax, eax
    jnz pedirCodigoDeProductoExistenteFin
    mov edx, OFFSET msgNoExiste
    call WriteString
    call Crlf
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
    mov edx, OFFSET sepBar
    call WriteString
    lea edx, [esi+DesplazamientoNombre]
    call WriteString
    mov edx, OFFSET sepBar
    call WriteString
    mov eax, [esi+DesplazamientoPrecio]
    call mostrarImporteMXN
    mov edx, OFFSET sepExist
    call WriteString
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
    mov edx, OFFSET msgVacio
    call WriteString
    call Crlf
    jmp mostrarInventarioFin
mostrarInventarioConProductos:
    mov edx, OFFSET msgEncab
    call WriteString
    call Crlf
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
    mov edx, OFFSET msgLleno
    call WriteString
    call Crlf
    jmp registrarProductoFin
registrarProductoHayLugar:
    mov edx, OFFSET msgPideCod
    call WriteString
    call leerLineaTeclado
    mov esi, OFFSET inBuf
    call validarFormatoCodigo
    test eax, eax
    jnz registrarProductoCodigoValido
    mov edx, OFFSET msgCodInv
    call WriteString
    call Crlf
    jmp registrarProductoFin
registrarProductoCodigoValido:
    mov edi, OFFSET inBuf
    call buscarCodigoEnCatalogo
    test eax, eax
    jz registrarProductoSinDuplicado
    mov edx, OFFSET msgDuplicado
    call WriteString
    call Crlf
    jmp registrarProductoFin
registrarProductoSinDuplicado:
    mov esi, OFFSET inBuf
    mov edi, OFFSET tmpCode
    call copiarCadenaCompleta              
    mov edx, OFFSET msgPideNom
    call WriteString
    call leerLineaTeclado
    mov esi, OFFSET inBuf
    call validarFormatoNombre
    test eax, eax
    jnz registrarProductoNombreValido
    mov edx, OFFSET msgNomInv
    call WriteString
    call Crlf
    jmp registrarProductoFin
registrarProductoNombreValido:
    mov edi, OFFSET tmpName
    call copiarCadenaCompleta
    mov edx, OFFSET msgPidePrecio
    call WriteString
    call leerLineaTeclado
    mov esi, OFFSET inBuf
    call convertirPrecioACentavos
    jnc registrarProductoPrecioValido
    mov edx, OFFSET msgPrecioInv
    call WriteString
    call Crlf
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
    call copiarCadenaCompleta
    lea edi, [ebx+DesplazamientoNombre]
    mov esi, OFFSET tmpName
    call copiarCadenaCompleta
    mov eax, tmpPrecio
    mov [ebx+DesplazamientoPrecio], eax
    mov eax, tmpStock
    mov [ebx+DesplazamientoStock], eax
    inc numProd
    mov dirty, 1
    mov edx, OFFSET msgAltaOk
    call WriteString
    call Crlf
registrarProductoFin:
    popad
    ret
registrarProducto ENDP

buscarProducto PROC
    pushad
    call pedirCodigoDeProductoExistente
    test eax, eax
    jz buscarProductoFin
    mov edx, OFFSET msgEncab
    call WriteString
    call Crlf
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
    mov edx, OFFSET msgExcede     
    call WriteString
    call Crlf
    jmp recibirMercanciaFin
recibirMercanciaAceptada:
    mov [esi+DesplazamientoStock], eax
    mov dirty, 1
    mov edx, OFFSET msgRecibOk
    call WriteString
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
    mov edx, OFFSET msgSinStock
    call WriteString
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
    mov edx, OFFSET msgVentaOk
    call WriteString
    lea edx, [esi+DesplazamientoNombre]
    call WriteString
    call Crlf
    mov edx, OFFSET msgBase
    call WriteString
    mov eax, ventaBase
    call mostrarImporteMXN
    call Crlf
    cmp ventaDesc, 0
    je venderProductoMostrarSinDescuento
    mov edx, OFFSET msgDesc
    call WriteString
    mov eax, ventaDesc
    call mostrarImporteMXN
    call Crlf
    jmp venderProductoMostrarTotal
venderProductoMostrarSinDescuento:
    mov edx, OFFSET msgSinDesc    
    call WriteString
    call Crlf
venderProductoMostrarTotal:
    mov edx, OFFSET msgTotal
    call WriteString
    mov eax, ventaFinal
    call mostrarImporteMXN
    call Crlf
    jmp venderProductoFin
venderProductoDesbordamiento:
    mov edx, OFFSET msgOvf
    call WriteString
    call Crlf
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
    mul DWORD PTR [esi+DesplazamientoPrecio]  
    jc mostrarResumenDesbordamiento
    add edi, eax
    jc mostrarResumenDesbordamiento
    add esi, TamanoRegistro
    dec ecx
    jnz mostrarResumenCiclo
mostrarResumenMostrar:
    mov edx, OFFSET msgResTit
    call WriteString
    call Crlf
    mov edx, OFFSET msgResProd
    call WriteString
    mov eax, numProd
    call mostrarEntero
    call Crlf
    mov edx, OFFSET msgResUni
    call WriteString
    mov eax, ebx
    call mostrarEntero
    call Crlf
    mov edx, OFFSET msgResVal
    call WriteString
    mov eax, edi
    call mostrarImporteMXN
    call Crlf
    mov edx, OFFSET msgResVen
    call WriteString
    mov eax, numVentas
    call mostrarEntero
    call Crlf
    mov edx, OFFSET msgResIng
    call WriteString
    mov eax, ingresos
    call mostrarImporteMXN
    call Crlf
    jmp mostrarResumenFin
mostrarResumenDesbordamiento:
    mov edx, OFFSET msgOvf
    call WriteString
    call Crlf
mostrarResumenFin:
    popad
    ret
mostrarResumen ENDP

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

guardarInventarioEnArchivo PROC
    push ebx
    push ecx
    push edx
    push esi
    push edi
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
    mov edx, OFFSET msgErrCrear
    call WriteString
    call Crlf
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
    mov edx, OFFSET msgErrEscr
    call WriteString
    call Crlf
    xor eax, eax
    jmp guardarInventarioEnArchivoFin
guardarInventarioEnArchivoExito:
    mov dirty, 0
    mov edx, OFFSET msgGuardado
    call WriteString
    call Crlf
    mov eax, 1
guardarInventarioEnArchivoFin:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
guardarInventarioEnArchivo ENDP

copiarCampoHastaDelimitador PROC
    push ebx
    xor ebx, ebx                    
copiarCampoHastaDelimitadorCiclo:
    mov al, [esi]
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
copiarCampoHastaDelimitadorDelimitadorEncontrado:
    mov BYTE PTR [edi+ebx], 0
    inc esi                         
    mov eax, 1
    jmp copiarCampoHastaDelimitadorFin
copiarCampoHastaDelimitadorError:
    xor eax, eax
copiarCampoHastaDelimitadorFin:
    pop ebx
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
    mov dl, '|'
    call copiarCampoHastaDelimitador
    test eax, eax
    jz convertirLineaARegistroInvalida
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
    mov edx, OFFSET msgNoArch
    call WriteString
    call Crlf
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
    cmp BYTE PTR [esi], 0
    je cargarInventarioDesdeArchivoFinLineas
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
cargarInventarioDesdeArchivoFinLineas:
    mov eax, esi
    sub eax, OFFSET fileBuf
    cmp eax, bytesLeidos            
    jne cargarInventarioDesdeArchivoCorrupto
    cld
    mov esi, OFFSET tmpCat
    mov edi, OFFSET catalogo
    mov ecx, MaxProductos*TamanoRegistro
    rep movsb
    mov eax, tmpCount
    mov numProd, eax
    mov dirty, 0
    mov edx, OFFSET msgCargaOk
    call WriteString
    mov eax, numProd
    call mostrarEntero
    call Crlf
    jmp cargarInventarioDesdeArchivoFin
cargarInventarioDesdeArchivoErrorLectura:
    mov eax, fHandle
    call CloseFile
    mov edx, OFFSET msgErrLect
    call WriteString
    call Crlf
    jmp cargarInventarioDesdeArchivoFin
cargarInventarioDesdeArchivoMuyGrande:
    mov edx, OFFSET msgGrande
    call WriteString
    call Crlf
    jmp cargarInventarioDesdeArchivoFin
cargarInventarioDesdeArchivoCorrupto:
    mov edx, OFFSET msgCorrupto
    call WriteString
    call Crlf
cargarInventarioDesdeArchivoFin:
    popad
    ret
cargarInventarioDesdeArchivo ENDP

mostrarReglaDescuento PROC
    push edx
    mov edx, OFFSET msgRegla
    call WriteString
    call Crlf
    mov edx, OFFSET msgRegla1
    call WriteString
    call Crlf
    mov edx, OFFSET msgRegla2
    call WriteString
    call Crlf
    mov edx, OFFSET msgRegla3
    call WriteString
    call Crlf
    mov edx, OFFSET msgRegla4
    call WriteString
    call Crlf
    mov edx, OFFSET msgRegla5
    call WriteString
    call Crlf
    pop edx
    ret
mostrarReglaDescuento ENDP

mostrarMenu PROC
    call Crlf
    mov edx, OFFSET msgMenu1
    call WriteString
    call Crlf
    mov edx, OFFSET msgMenu2
    call WriteString
    call Crlf
    mov edx, OFFSET msgMenu3
    call WriteString
    call Crlf
    mov edx, OFFSET msgMenu4
    call WriteString
    call Crlf
    mov edx, OFFSET msgMenu5
    call WriteString
    call Crlf
    mov edx, OFFSET msgMenu6
    call WriteString
    call Crlf
    mov edx, OFFSET msgMenu7
    call WriteString
    call Crlf
    mov edx, OFFSET msgMenu8
    call WriteString
    call Crlf
    mov edx, OFFSET msgMenu9
    call WriteString
    call Crlf
    mov edx, OFFSET msgMenu0
    call WriteString
    call Crlf
    ret
mostrarMenu ENDP

main PROC
    mov espInicial, esp
    mov edx, OFFSET msgBienvenida
    call WriteString
    call Crlf
menuPrincipal:
    call mostrarMenu
    mov edx, OFFSET msgOpcion
    call WriteString
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
    mov edx, OFFSET msgAdios
    call WriteString
    call Crlf
    exit
opcionInvalida:
    mov edx, OFFSET msgOpInv
    call WriteString
    call Crlf
verificarPila:
    cmp esp, espInicial           
    je menuPrincipal
    mov edx, OFFSET msgPila
    call WriteString
    call Crlf
    exit
main ENDP
END main