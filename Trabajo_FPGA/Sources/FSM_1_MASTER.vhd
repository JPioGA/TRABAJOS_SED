----------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;


entity FSM_1_MASTER is
    generic(
        MAX_ROUND   : natural := 99;
        COLORS      : natural := 4
    );
    Port (
        -- General MASTER interface
        CLK         : in std_logic;
        RST_N       : in std_logic;
        OK_BUTTON   : in std_logic;
        ROUND       : out natural;
        OUT_MESSAGE : out natural;
        
        -- MASTER-SLAVE SHOWSEQ interface
        START_SHOWSEQ           : out std_logic;
        PARAM_SHOWSEQ_sequence  : out natural(0 to MAX_ROUND-1);
        PARAM_SHOWSEQ_size      : out natural;
        DONE_SHOWSEQ            : in std_logic;
        
        -- MASTER-SLAVE INCHECK interface
        START_INCHECK : out std_logic;
        PARAM_INCHECK : out natural;
        DONE_INCHECK  : in natural; -- 0: none; 1: NO OK; 2: OK
        
        -- MASTER-SLAVE TIMER interface
        START_TIMER : out std_logic;
        PARAM_TIMER : out natural;
        RST_COUNT   : out std_logic;
        DONE_TIMER  : in std_logic
    );
end FSM_1_MASTER;


architecture Behavioral of FSM_1_MASTER is
    -- Declaración de tipos y señales utilizadas
	type STATE_T is (
		S0_WT,	-- S0_WT: ESPERA INICIO DE JUEGO. Hasta que no se pulse OK_BUTTON no se pasa al estado S0.
		S0,		-- S0: START GAME. Se muestra una animación que indica el inicio del juego.
		S1,		-- S1: ADD VALUE. Adición de un nuevo valor a la secuencia
		S2,		-- S2: SHOW SEQUENCE. Activación de la FSM SLAVE SHOWSEQ. Muestra por los LEDS la secuencia que tendrá que introducir el jugador.
		S3,		-- S3: START INCHECK Y TIMER. Disparo del temporizador tras mostrar la secuencia, Y activación de la comprobación de los inputs del jugador.
		S4,		-- S4: INPUTS OK: El jugador ha introducido todos los valores correctamente.
		S5		-- S5: GAME OVER. El jugador ha perdido por fin del tiempo o por error en el input. Se muestra animación de fin de juego
	);
	subtype BUTTON_T is integer range 1 to 4; -- 1: UP_BUTTON	2: DOWN_BUTTON	3: RIGHT_BUTTON	4: LEFT_BUTTON	  (El subtipo está hecho para ahorrar recursos en la síntesis)
	
	signal cur_state	 : STATE_T;				-- Estado actual
	signal nxt_state	 : STATE_T;				-- Estado siguiente
	signal game_sequence : BUTTON_T(0 to MAX_ROUND-1);	-- Vector que contendrá en sus elementos los valores aleatorios a adivinar por el jugador.
	signal size          : natural := 0;
	
	-- Declaración de funciones
		-- GENERACIÓN DE NÚMEROS ALEATORIOS (DEL 1 AL 4)
	impure function rand_num(max : positive := COLORS) return BUTTON_T is
	  variable aux_result : real;
	  variable result     : BUTTON_T;
	begin
		uniform(seed1, seed2, aux_result); -- Genera un valor aleatorio entre 0 y 1
		result = ((aux_result * 100) mod COLORS); -- Obtención de un valor entero entre 1 y 4
	  return result + 1;
	end function rand_num;
	
	
begin
    -- Actualización de los estados
	state_register: process(CLK, RST_N)
	begin
		if RST_N = '0' then -- Si entra un reset, mandar a reposo la máquina de estados
			cur_state <= S0_WT;
		elsif rising_edge(CLK) then
			cur_state <= nxt_state;
		end if;
	end process;
	
	
	-- Control de transición entre estados
	nxt_state_decoder: process(cur_state, OK_BUTTON, DONE_SHOWSEQ, DONE_INCHECK, DONE_TIMER) -- Proceso COMBINACIONAL: Solo introducir las entradas.
	variable i     : natural := 0;
	begin
		-- Asegurar que el proceso sea combinacional
		nxt_state <= cur_state;
		
		-- Transiciones de estado y cambio de variables internas para el funcionamiento del juego
		case cur_state is
			when S0_WT =>
				if OK_BUTTON = '1' then
					nxt_state <= S0;
				end if;
				-- Reinicio todas las variables internas para una nueva partida
				i		 := 0;
				size <= 0;
				
				
			when S0 =>
				-- MANDAR SEÑALES DE MENSAJE START GAME
				OUT_MESSAGE <= 1; -- Mensaje de start
				wait for 5000 ms; 
				OUT_MESSAGE <= 0; -- No sacar nada por los displays
				nxt_state <= S1;
				
				
			when S1 =>
				-- Adición de un nuevo elemento a la secuencia
				size <= size + 1;
				game_sequence(size-1) <= rand_num();
				i := 0;
				nxt_state <= S2;
				
				
			when S2 =>
				if DONE_SHOWSEQ = '1' then -- Tras terminar de mostrar la secuencia, paso al siguiente estado
				   nxt_state <= S3; 
				end if;
				
			when S3 =>
				wait for 1000 ms;
				nxt_state <= S4;
				
				
			when S4 =>
				
				
			when S5 =>
				
				
			when others =>
				nxt_state <= S0_WT; -- En caso de fallo, volver al estado de espera.	
		end case;	
	end process;
	
	
	--Salidas de cada estad
	output_decoder: process(cur_state) -- Esta parte es COMBINACIONAL. Solo cambia en caso de cambiar el estado
	begin
		-- Asegurar que el proceso sea combiancional
		-- General MASTER interface
		ROUND                   <= 0;
		OUT_MESSAGE             <= 0;
		-- MASTER-SLAVE SHOWSEQ interface
		START_SHOWSEQ           <= '0';
        PARAM_SHOWSEQ_sequence  <= 0;
        PARAM_SHOWSEQ_size      <= 0;
        -- MASTER-SLAVE INCHECK interface
        START_INCHECK           <= '0';
        PARAM_INCHECK           <= 0;
        -- MASTER-SLAVE TIMER interface
        START_TIMER             <= '0';
        PARAM_TIMER             <= 0;
        RST_COUNT               <= '0';
		
		case cur_state is
			when S0_WT =>
				-- General MASTER interface
                ROUND                   <= 0;
                OUT_MESSAGE             <= 0;
                -- MASTER-SLAVE SHOWSEQ interface
                START_SHOWSEQ           <= '0';
                PARAM_SHOWSEQ_sequence  <= 0;
                PARAM_SHOWSEQ_size      <= 0;
                -- MASTER-SLAVE INCHECK interface
                START_INCHECK           <= '0';
                PARAM_INCHECK           <= 0;
                -- MASTER-SLAVE TIMER interface
                START_TIMER             <= '0';
                PARAM_TIMER             <= 0;
                RST_COUNT               <= '0';
				
			when S0 =>
				-- General MASTER interface
                ROUND                   <= 0;
                OUT_MESSAGE             <= 0;
                -- MASTER-SLAVE SHOWSEQ interface
                START_SHOWSEQ           <= '0';
                PARAM_SHOWSEQ_sequence  <= 0;
                PARAM_SHOWSEQ_size      <= 0;
                -- MASTER-SLAVE INCHECK interface
                START_INCHECK           <= '0';
                PARAM_INCHECK           <= 0;
                -- MASTER-SLAVE TIMER interface
                START_TIMER             <= '0';
                PARAM_TIMER             <= 0;
                RST_COUNT               <= '0';
				
			when S1 =>
				-- General MASTER interface
                ROUND                   <= 0;
                OUT_MESSAGE             <= 0;
                -- MASTER-SLAVE SHOWSEQ interface
                START_SHOWSEQ           <= '0';
                PARAM_SHOWSEQ_sequence  <= 0;
                PARAM_SHOWSEQ_size      <= 0;
                -- MASTER-SLAVE INCHECK interface
                START_INCHECK           <= '0';
                PARAM_INCHECK           <= 0;
                -- MASTER-SLAVE TIMER interface
                START_TIMER             <= '0';
                PARAM_TIMER             <= 0;
                RST_COUNT               <= '0';
				
			when S2 =>
				-- General MASTER interface
                ROUND                   <= 0;
                OUT_MESSAGE             <= 0;
                -- MASTER-SLAVE SHOWSEQ interface
                START_SHOWSEQ           <= '0';
                PARAM_SHOWSEQ_sequence  <= 0;
                PARAM_SHOWSEQ_size      <= 0;
                -- MASTER-SLAVE INCHECK interface
                START_INCHECK           <= '0';
                PARAM_INCHECK           <= 0;
                -- MASTER-SLAVE TIMER interface
                START_TIMER             <= '0';
                PARAM_TIMER             <= 0;
                RST_COUNT               <= '0';
				
			when S3 =>
				-- General MASTER interface
                ROUND                   <= 0;
                OUT_MESSAGE             <= 0;
                -- MASTER-SLAVE SHOWSEQ interface
                START_SHOWSEQ           <= '0';
                PARAM_SHOWSEQ_sequence  <= 0;
                PARAM_SHOWSEQ_size      <= 0;
                -- MASTER-SLAVE INCHECK interface
                START_INCHECK           <= '0';
                PARAM_INCHECK           <= 0;
                -- MASTER-SLAVE TIMER interface
                START_TIMER             <= '0';
                PARAM_TIMER             <= 0;
                RST_COUNT               <= '0';
				
			when S4 =>
				-- General MASTER interface
                ROUND                   <= 0;
                OUT_MESSAGE             <= 0;
                -- MASTER-SLAVE SHOWSEQ interface
                START_SHOWSEQ           <= '0';
                PARAM_SHOWSEQ_sequence  <= 0;
                PARAM_SHOWSEQ_size      <= 0;
                -- MASTER-SLAVE INCHECK interface
                START_INCHECK           <= '0';
                PARAM_INCHECK           <= 0;
                -- MASTER-SLAVE TIMER interface
                START_TIMER             <= '0';
                PARAM_TIMER             <= 0;
                RST_COUNT               <= '0';
				
			when S5 =>
				-- General MASTER interface
                ROUND                   <= 0;
                OUT_MESSAGE             <= 0;
                -- MASTER-SLAVE SHOWSEQ interface
                START_SHOWSEQ           <= '0';
                PARAM_SHOWSEQ_sequence  <= 0;
                PARAM_SHOWSEQ_size      <= 0;
                -- MASTER-SLAVE INCHECK interface
                START_INCHECK           <= '0';
                PARAM_INCHECK           <= 0;
                -- MASTER-SLAVE TIMER interface
                START_TIMER             <= '0';
                PARAM_TIMER             <= 0;
                RST_COUNT               <= '0';
				
			when others =>
				-- General MASTER interface
                ROUND                   <= 0;
                OUT_MESSAGE             <= 0;
                -- MASTER-SLAVE SHOWSEQ interface
                START_SHOWSEQ           <= '0';
                PARAM_SHOWSEQ_sequence  <= 0;
                PARAM_SHOWSEQ_size      <= 0;
                -- MASTER-SLAVE INCHECK interface
                START_INCHECK           <= '0';
                PARAM_INCHECK           <= 0;
                -- MASTER-SLAVE TIMER interface
                START_TIMER             <= '0';
                PARAM_TIMER             <= 0;
                RST_COUNT               <= '0';
		end case;
	end process output_decoder;

end Behavioral;