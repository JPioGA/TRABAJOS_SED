library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package tipos_especiales is
    -- DECLARACIÓN DE TIPOS UTILIZADOS EN LA FSM
    type SEQUENCE_T is array (3 downto 0) of std_logic_vector(3 downto 0);
    type STATE_MASTER_T is (
        S_STBY, -- S_STBY: ESPERA INICIO DE JUEGO. Hasta que no se pulse OK_BUTTON no se pasa al estado S0.
        S0,		-- S0: Estado de generación de la secuencia a adivinar por el jugador
        S1,		-- S1: ADD VALUE. Adición de un nuevo valor a la secuencia
        S1_WT,  -- S1_WT: Tiempo de espera de muestra del mensaje GO
        S2,		-- S2: Disparo de INCHECK. Máquina esclava encargada del juego
        S2_WT,  -- S2_WT: Estado de espera al final de la interacción con el jugador
        S3,     -- S3: WIN. Disparo de TIMER para mostrar el mensaje al ganar el 
        S3_WT,  -- S3_WT: Tiempo de espera de muestra del mensaje WIN
        S4,		-- S3: GAME OVER. Disparo de TIMER para mostrar el mensaje al perder el juego.
        S4_WT   -- S4_WT: Tiempo de espera de muestra del mensaje GAME OVER
    );
    
    type STATE_SLAVE_T is (
        S_STBY, -- S_STBY: ESPERA INICIO DE JUEGO.
        S1,		-- S1: Espera a un input del jugador
        S2,		-- S2: Comprobación del input
        S3,		-- S3: Input OK. Comprobación si se ha terminado la secuencia
        S4     -- S4: WIN. Todos los inputs se introdujeron correctamente
        --S5,		-- S5: Input NO OK. Comprobación si se han termiando los TRYS
        --S6		-- S6: GAME OVER. Se acabaron los intentos
    );
    
    -- DECLARACIÓN DE COMPONENTES UTILIZADOS (para ahorrar espacio y limpieza del código)
    component COMPARATOR is
        port ( CLK  : in std_logic; -- Señal de reloj
               CE   : in std_logic; -- Señal de Chip Enable
               X    : in std_logic_vector (3 downto 0); -- Entrada 1 a comparar
               Y    : in std_logic_vector (3 downto 0); -- Entrada 1 a comparar
               EQ   : out std_logic); -- Resultado de la comparación ('1' si iguales, '0' si diferentes)
    end component;
    
    
    component LFSR is             
        port (  CLK         : in std_logic;
                RST_N       : in std_logic;
                NEW_SEQ     : out std_logic;   -- Señal de salida que indica cuando se ha generado una nueva secuencia ()
                RETURN_LFSR : out SEQUENCE_T); -- Señal de reset asíncrona. OJO! Nunca reinicial el valor del registro de estados con TODO 0. Se bloquea.
    end component;
    
    
    component FSM_SLAVE_TIMER is
        port (  CLK         : in std_logic;
                RST_N       : in std_logic;
                START_TIMER : in std_logic;
                DONE_TIMER  : out std_logic);        
    end component;
    
    
    component FSM_SLAVE_INCHECK is
        port (  CLK             : in std_logic;
                RST_N           : in std_logic;
                START_INCHECK   : in std_logic;  -- Señal de inicio de la comparación
                PARAM_SEQ       : in SEQUENCE_T; -- Secuencia aleatoria a adivinar por el jugador
                BTN             : in std_logic_vector (3 downto 0); -- Entrada de botones pulsados. 
                --LED             : out std_logic_vector (3 downto 0); -- LEDS a ENCENDER según se vayan encendiendo los LEDS.
                DONE_INCHECK    : out std_logic_vector(1 downto 0);
                INTENTOS        : out natural range 0 to 10); -- "00" si NOT DONE // "01" si WIN // "10" si GAME OVER
    end component;
    
    
    component FSM_MASTER is
        port (  CLK           : in std_logic;
                RST_N         : in std_logic;
                OK_BUTTON     : in std_logic;
                OUT_MESSAGE   : out std_logic_vector(2 downto 0); -- "000" si nada // "001" si START // "010" si GO // "011" si GAME OVER // "100" si WIN
                -- Interfez entre MASTER y TIMER
                START_TIMER   : out std_logic;
                DONE_TIMER    : in std_logic;
                -- Interfaz entre MASTER y LFSR
                RAND_SEQ      : in SEQUENCE_T;
                DONE_LFSR     : in std_logic;
                -- Interfaz entre MASTER e INCHECK
                START_INCHECK : out std_logic;
                PARAM_SEQ     : out SEQUENCE_T;
                DONE_INCHECK  : in std_logic_vector(1 downto 0)); -- "00" si NOT DONE // "01" si WIN // "10" si GAME OVER
    end component;
    
end tipos_especiales;

package body tipos_especiales is
end tipos_especiales;