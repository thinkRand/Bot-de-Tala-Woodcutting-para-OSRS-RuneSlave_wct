# Bot de Tala (Woodcutting) para OSRS - RuneSlave_wct

Este proyecto es un bot automatizado para el entrenamiento de la habilidad de Tala (Woodcutting) en Old School RuneScape (OSRS), desarrollado originalmente en AutoHotkey (AHK). El script fue diseñado para ser modular y robusto, interactuando con el cliente del juego (principalmente RuneLite) para cortar árboles de forma cíclica y gestionar el inventario.

# Nota: Debido a que creé este script hace años y no recuerdo como funciona exactamente use IA para crear este readme.md, asi que puede haber imprecisiones.

## Descargo de responsabilidad

**El uso de bots en OSRS viola los términos de servicio del juego y puede resultar en la suspensión permanente de tu cuenta.** Este proyecto se comparte únicamente con fines educativos y de archivo. Úsalo bajo tu propio riesgo. El autor original y yo no nos hacemos responsables de cualquier sanción que puedas recibir.

## Requisitos y configuración inicial

Antes de ejecutar el script, debes asegurarte de que tu configuración cumpla con las condiciones para las que fue diseñado. Según el archivo `Condiciones para ejecutar el script.txt`:

1.  **Sistema Operativo:** Probado originalmente en Windows 7.
2.  **Cliente del juego:** Diseñado para **RuneLite**. Es posible que no funcione correctamente en el cliente oficial o en OSBuddy.
3.  **Modo de pantalla en RuneLite:** Debe estar en **"Fixed Mode"** (modo fijo).
4.  **Plugin de RuneLite:** El plugin **"Mouse Tooltips" debe estar desactivado**. De lo contrario, los tooltips podrían interferir con la detección de colores.
5.  **Permisos:** El script está configurado para ejecutarse como Administrador (`RusAs.ahk`), lo cual es necesario para ciertas operaciones en AHK.
6.  **Idioma del README:** El script y sus comentarios están mayoritariamente en español, pero la lógica principal es independiente del idioma.

## Archivos principales del proyecto

El proyecto se organiza en varios archivos AHK. El núcleo del bot es `WoodCuting.v0.ahk`.

*   **`WoodCuting.v0.ahk`**: El script principal que inicia y controla el ciclo de tala.
*   **`Nucleo/`**: Carpeta que contiene las bibliotecas y clases fundamentales.
    *   **`NuevoEntorno.ahk`**: Se encarga de identificar y seleccionar la ventana activa del juego (RuneLite).
    *   **`NuevaInterfaceCliente.ahk`**: Define las clases para representar la interfaz del juego (`_InterfaceGlobalContenedora`, `_MenuBarraOpciones`, `_Inventory`). Es la capa de abstracción para interactuar con el cliente.
    *   **`Monitor.ahk`**: Define la clase `_Monitor` y `_Indicador`. Un monitor vigila puntos específicos de la pantalla (indicadores) para detectar cambios de color.
    *   **`NuevaDeteccion.ahk`**: Contiene funciones auxiliares para buscar colores en áreas de la pantalla.
    *   **`Puntero.ahk`**: Funciones para mover el ratón de forma "humana" (con retardos aleatorios) y hacer clic en áreas específicas.
    *   **`GestionTiempo.ahk`**: Funciones para pausas aleatorias (`pausaMin`, `pausaMedia`, etc.) que simulan el tiempo de reacción humano.
    *   **`MarcaDeTiempo.ahk`**: Una función simple para comprobar si el script ha expirado (una forma rudimentaria de licencia).
    *   **`RS_Datos.ahk`**: Contiene datos de colores conocidos del juego (rocas, árboles, etc.) que podrían usarse para identificación.
*   **Archivos de soporte y configuración:**
    *   **`NuevaGestionArea.ahk`**: Permite al usuario definir áreas de la pantalla (como la zona de un árbol) mediante teclas de acceso rápido.
    *   **`Alarma.ahk`**: Un sistema de alarma simple que se activa en caso de errores o detenciones inesperadas.
    *   **`Graficos.ahk`**: Una utilidad para dibujar rectángulos en la pantalla, útil para depurar la posición de las interfaces.
    *   **`Problemas actuales.txt` / `Cosas por hacer.txt`**: Notas personales sobre bugs conocidos y mejoras planeadas.
    *   **`Gdip.ahk`**: Librería externa estándar de AHK para manejo de gráficos (no se usa activamente en el ciclo principal, pero está incluida).

## Cómo usar el script (Flujo de trabajo)

El bot está diseñado para funcionar con una intervención mínima del usuario después de la configuración inicial. Sigue estos pasos:

### 1. Definir las áreas de los árboles

Antes de empezar, debes decirle al bot dónde están los árboles que quieres talar.

1.  Abre RuneLite en modo fijo y coloca la cámara lo más arriba posible (mirando hacia abajo) para que la base de los árboles sea visible.
2.  Ejecuta el script `WoodCuting.v0.ahk`.
3.  Con la ventana de RuneLite activa, presiona la tecla de acceso rápido **`^a` (Ctrl + A)** para iniciar el modo de definición de áreas.
4.  El script te pedirá que definas un área. Haz clic en la esquina superior izquierda de la zona donde está **un solo árbol**. Luego, haz clic en la esquina inferior derecha de esa misma zona. El área debe ser lo más ajustada posible al árbol para evitar falsas detecciones.
5.  Aparecerá un mensaje indicando que el "Área 1" ha sido creada.
6.  Repite los pasos 3-5 para cada árbol que quieras incluir en el ciclo. El bot los tratará como una lista circular.

### 2. Inicializar los árboles (Configuración de colores)

Una vez definidas las áreas, el bot necesita saber cómo se ve un árbol cuando está en pie y cuando está cortado.

1.  Con las áreas ya definidas, presiona la tecla de acceso rápido **`^i` (Ctrl + I)** para iniciar el script.
2.  Automáticamente, para cada área que definiste, aparecerá un cuadro de diálogo preguntando: **"¿El árbol [número] está en pie en este momento?"**
    *   Haz clic en **"Sí"** si el árbol en esa área está visible y listo para cortar. El script capturará el color actual (activo) y lo guardará.
    *   Haz clic en **"No"** si el árbol en esa área ya está cortado (solo se ve el tocón o el suelo). El script capturará el color actual (inactivo) y lo guardará.
3.  Este proceso asigna a cada árbol sus dos colores característicos: el "activo" (el que tiene cuando está en pie) y el "inactivo" (el que tiene cuando está cortado).

### 3. Iniciar el bot

Una vez que todos los árboles han sido inicializados, el bot comenzará automáticamente su ciclo de trabajo.

1.  El bot activará la ventana de RuneLite si no lo está.
2.  Se asegurará de que la pestaña de Inventario esté abierta.
3.  Elegirá un árbol al azar para empezar.
4.  Moverá el ratón sobre el área de ese árbol y hará clic para comenzar a talar.
5.  Entrará en un bucle donde:
    *   **Vigila el inventario:** Si el inventario se llena, activa el modo "BotarItems".
    *   **Vigila el árbol actual:** Usando el monitor de píxeles en el punto indicador del árbol, comprueba constantemente si el árbol sigue en pie.
    *   **Busca el siguiente árbol:** Si el árbol actual se corta, busca inmediatamente el siguiente árbol en pie más cercano (en el orden de la lista circular que creaste).
    *   **Mueve el ratón y hace clic:** Cuando encuentra un nuevo árbol objetivo, mueve el ratón sobre él y hace clic para empezar a talarlo.

### 4. Gestión del inventario

Cuando el inventario está lleno, el script entra en un sub-modo:

1.  Mantiene presionada la tecla **Shift**.
2.  Recorre todas las celdas del inventario (de la 1 a la 28).
3.  Por cada celda **no bloqueada** (por defecto, la celda 29 no existe, pero en el código se usa `CELDAS_BLOQUEADAS` como concepto), hace clic para "botar" el objeto (simulando el método de Shift + Click para soltar objetos rápidamente).
4.  Al llegar a la última celda, suelta la tecla Shift.
5.  Vuelve a comprobar si el inventario está vacío. Si lo está, desactiva el modo "BotarItems" y busca un nuevo árbol para empezar de nuevo.

### 5. Detener el script

Puedes detener el script de las siguientes maneras:

*   Presiona la tecla **`Espacio`**. Esto activará la función `detener()`, que detendrá el ciclo de forma controlada al final de su iteración actual. (En tu código, la tecla Espacio está comentada con `~Space`, lo que significaría que no intercepta la tecla, pero `Space::` sí).
*   Presiona la tecla **`Esc`** para salir del script por completo (`ExitApp`).
*   El script también se detendrá automáticamente si la ventana de RuneLite pierde el foco o se cierra.

## Cómo funciona internamente (La magia detrás)

Tu script tiene una arquitectura muy interesante. Se basa en tres pilares:

1.  **Abstracción de la Interfaz (`NuevaInterfaceCliente.ahk`)**:
    *   El juego se modela como un conjunto de objetos: `InterfaceGlobal` (la ventana del canvas de RuneLite), `BarraOpciones` y `Inventory`.
    *   Cada objeto conoce su posición relativa y sus componentes. Por ejemplo, `BarraOpciones` sabe que su opción 4 (Inventory) tiene un área específica y un color de fondo y activo.
    *   Esta capa separa la lógica del bot (qué hacer) de la implementación de bajo nivel (cómo obtener el color de un píxel).

2.  **Detección por Indicadores y Monitor (`Monitor.ahk`, `_Arbol`)**:
    *   La idea genial aquí es **no** analizar toda el área del árbol cada vez.
    *   Cuando defines un área, el script calcula su punto central.
    *   Al inicializar el árbol (cuando respondes "Sí/No" a la pregunta), el script asigna el color de ese punto central al árbol como su "colorActivo" o "colorInactivo".
    *   La clase `_Monitor` vigila constantemente ese punto (el "indicador") y puede decirte su color actual de forma muy rápida.
    *   La función `arbol.estaCortado()` simplemente compara el color actual del indicador con el colorActivo e inactivo que conoce. Si coincide con el activo, el árbol está en pie. Si coincide con el inactivo, está cortado. Si no coincide con ninguno, el bot se detiene porque asume que la cámara se movió o hubo un error.

3.  **Máquina de Estados simple en `WoodCuting.v0.ahk`**:
    *   El flujo principal se basa en un bucle que evalúa el estado actual.
    *   Los estados principales son: `cortandoArbol` (si está o no talando), `botarItems` (si hay que vaciar el inventario) y `arbolObjetivoExiste` (si hay un árbol válido al que ir).
    *   Las transiciones entre estos estados están gobernadas por la información que proviene de los monitores (inventario lleno, árbol cortado, etc.).

## Problemas conocidos y mejoras planeadas (según tus notas)

El archivo `Problemas actuales.txt` lista varios bugs que tenías identificados:

*   **A veces se para después de la última leña:** Posiblemente un error en la lógica de transición entre el estado de cortado y la búsqueda del siguiente árbol.
*   **Se para al subir de nivel:** El mensaje de subida de nivel probablemente desplaza o cambia algún elemento de la interfaz que el bot está monitorizando.
*   **No detecta desconexiones:** El bot seguiría intentando hacer clic en una ventana congelada o desconectada.
*   **Análisis del inventario asume que está abierto:** Si el inventario se cierra (por ejemplo, al abrir el mapa o los skills), la detección de celdas llenas dará resultados erróneos.
*   **Criterio de árboles:** Querías cambiar la selección aleatoria por la del árbol más cercano para optimizar la ruta.

## Conclusión

Este proyecto es un excelente ejemplo de un bot modular para un juego. Demuestra un profundo conocimiento de AutoHotkey, así como un enfoque de diseño de software (separación de capas, uso de clases y monitores) para resolver un problema complejo como la automatización de tareas en un entorno gráfico dinámico.
