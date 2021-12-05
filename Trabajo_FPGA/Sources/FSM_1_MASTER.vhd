library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;
use IEEE.math_real.all


entity FSM_1_MASTER is
	generic(
		MAX_ROUND	:	positive := 99;  -- Número máximo de rondas
		COLORS		:	positive := 4	-- Número de colores de salida del juego
	);
	port(
		CLK		:	in 	std_logic; -- Entrada de RELOJ
		RST_N	:	in 	std_logic; -- Entrada de RESET a nivel bajo
		
		-- MASTER INTERFACE
		OK_BUTTON		:	in std_logic;
		UP_BUTTON		:	in std_logic;
		DOWN_BUTTON		:	in std_logic;
		RIGHT_BUTTON	:	in std_logic;
		LEFT_BUTTON		:	in std_logic;
		
		CUR_ROUND		:	out natural; -- Salida indicadora del valor de la ronda actual para mostrar en el visualizer.
		CUR_TEMP		:	out natural; -- Salida indicadora del valor actual del temporizador para mostrar al visualizer.
		SEQUENCE_VALUE	:	out natural; -- Salida de los valores de la secuencia a introducir por el jugador (HAY Q PENSAR SI IR SACANDO 1 A 1 LOS VALORES DESDE AQUÍ O SI PASAR TODO EL VECTOR A VISUALIZER)
		USER_INPUT		: 	out natural; -- Salida utlizada para indicarle al visualizer qué botón ha pulsado el jugador.
		OUT_MESSAGE		:	out natural; -- Salida indicadora del mensaje a sacar por los displays. 0: NO MESSAGE;		1: SHOW START MESSAGE;		2: SHOW END MESSAGE
		
		
		-- MASTER-SLAVE INTERFACE
		START		:	out std_logic; -- Señal de inicio del temporizador
		PARAM		:	out natural; -- Tiempo carga del temporizador
		RST_COUNT	:	out std_logic; -- Señal que indica que el temporizador deje de contar. El jugador introdujo a tiempo la secuencia.
		DONE 		:	in 	std_logic; -- Señal de fin del temporizador
		COUNT		:	in 	natural -- Valor actual de la cuenta del temporizador.
	);
end entity FSM_1_MASTER;

architecture behavioral of MASTER_FSM is -- FSM que controla la transición de estados
	-- Declaración de tipos, señales y variables utilizadas
	type STATE_T is (
		S0_WT,	-- S0_WT: ESPERA INICIO DE JUEGO. Hasta que no se pulse OK_BUTTON no se pasa al estado S0.
		S0,		-- S0: START GAME. Se muestra una animación que indica el inicio del juego.
		S1,		-- S1: ADD VALUE. Adición de un nuevo valor a la secuencia
		S2,		-- S2: SHOW SEQUENCE. Muestra por los LEDS la secuencia que tendrá que introducir el jugador
		S3,		-- S3: START TEMP. Disparo del temporizador tras mostrar la secuencia.
		S4,		-- S4: WAIT PLAYER INPUT. Espera a que el jugador pulse un botón
		S5,		-- S5: CHECK PLAYER INPUT. Comprobación del que el botón pulsado coincide con el elemento de la secuencia.
		S6		-- S6: END GAME. Fin del juego. Puede ocurrir por 2 casos: ERROR DEL JUGADOR o FIN DEL TIEMPO
	);
	subtype BUTTON_T is integer range 1 to 4; -- 1: UP_BUTTON	2: DOWN_BUTTON	3: RIGHT_BUTTON	4: LEFT_BUTTON	  (El subtipo está hecho para ahorrar recursos en la síntesis)
	
	signal cur_state	: STATE_T;				-- Estado actual
	signal nxt_state	: STATE_T;				-- Estado siguiente
	signal aux_count	: unsigned(8 downto 0); -- Señal auxiliar que llevará la cuenta según el valor introducido como parámetro
	
	variable game_sequence 		: BUTTON_T(0 to MAX_ROUND-1);	-- Vector que contendrá en sus elementos los valores aleatorios a adivinar por el jugador.
	variable player_input		: BUTTON_T;						-- Variable auxiliar para indicar el valor introducido por el jugador.
	variable flag_button_pushed : std_logic := '0';				-- Variable auxiliar para indicar que se pulsó un botón.
	variable cur_size			: natural;						-- Variable con el tamaño actual de la secuencia
	variable i					: natural := 0;					-- Variable iteradora
	
	-- Declaración de funciones
		-- GENERACIÓN DE NÚMEROS ALEATORIOS (DEL 1 AL 4)
	impure function rand_num(max : positive := COLORS) return BUTTON_T is
	  variable aux_result : real;
	  variable result : BUTTON_T;
	begin
		uniform(seed1, seed2, aux_result); -- Genera un valor aleatorio entre 0 y 1
		result = ((aux_result * 100) mod COLORS) + 1; -- Obtención de un valor entero entre 1 y 4
	  return result;
	end function rand_num;
		
		-- COMPROBACIÓN DEL VALOR INTRODUCIDO POR EL JUGADOR (Devuelve '1' si OK, '0' si NO OK)
	pure function check_input(player_in : BUTTON_T, seq : BUTTON_T) return std_logic is
	begin
		if player_in = seq then
			return '1';
		else 
			return '0';
		end if;
	end function check_input;


	
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
	nxt_state_decoder: process(cur_state, DONE, COUNT, OK_BUTTON, UP_BUTTON, DOWN_BUTTON, RIGHT_BUTTON, LEFT_BUTTON) -- Proceso COMBINACIONAL: Solo introducir las entradas.
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
				cur_size := 0;
				flag_button_pushed := '0';
				
				
			when S0 =>
				-- MANDAR SEÑALES DE MENSAJE START GAME
				OUT_MESSAGE <= 1; -- Mensaje de start
				wait for 5000 ms; 
				OUT_MESSAGE <= 0; -- No sacar nada por los displays
				nxt_state <= S1;
				
				
			when S1 =>
				-- Adición de un nuevo elemento a la secuencia
				cur_size := cur_size + 1;
				game_sequence(cur_size-1) := rand_num();
				i := 0;
				nxt_state <= S2;
				
				
			when S2 =>
				-- ENVIO DE MENSAJES DE SALIDA DE LA SECUENCIA
				for i in 0 to (cur_size-1) loop
					SEQUENCE_VALUE <= game_sequence(i); -- LED que encender (valores posibles: 1 2 3 4 (UP DOWN RIGHT LEFT))
					wait for 2000 ms;
				end loop;
				nxt_state <= S3; -- Tras recorrer el vector, pasar al siguiente estado.
				i := 0; --Reinicio del iterador
				
				-- Otra implementación por si el loop no es sintetizable
--				SEQUENCE_VALUE <= game_sequence(i); -- LED que encender (valores posibles: 1 2 3 4 (UP DOWN RIGHT LEFT))
--				wait for 2000 ms;
--				if i < (cur_size) then -- Si aún no se ha recorrido todo el vector
--					i := i + 1; -- Paso al siguiente elemento de la secuencia
--				else -- Si se ha recorrido todo el vector, se pasa al siguiente estado.
--					nxt_state <= S3;
--					i := 0; --Reinicio del iterador
--				end if;
				
				
			when S3 =>
				-- DISPARO DEL TEMPORIZADOR
				--PARAM <= cur_size; --Se pone aquí o en el output decoder??
				START <= '1';
				nxt_state <= S4; -- Tras disparar el temporizador paso al siguiente
				
				
			when S4 =>
				--Espera a introducir un valor por los botones (utilizar un flag que indique que se ha introducido un valor)
				-- LECTURA Y ACTIVACIÓN DEL FLAG. TAMBIÉN MANDAR MENSAJES DE LOS LEDS PULSADOS AL VISUALIZER
				if DONE = '1' then
					nxt_state <= S6; -- GAME OVER: fin del tiempo del temporizador
				elsif (flag_button_pushed = '1') then
					flag_button_pushed = '0'; -- Reinicio el flag
					nxt_state <= S5; -- Se introfujo un valor
				end if;
				
				
			when S5 =>
				if (check_input(player_in, game_sequence(i)) = '1') and (i < cur_size-1) then
					i := i + 1;
					nxt_state <= S4; -- Se introdujo el valor correcto. Aún no ha terminado la secuencia
				elsif (check_input(player_in, game_sequence(i)) = '1') and (i = cur_size-1) then
					i := 0; --OJO! Esto también se hace en S1. No se si afecta
					nxt_state <= S1; -- Se introdujo el valor correcto. Ha terminado la secuencia. Comienza nueva ronda
				elsif (check_input(player_in, game_sequence(i)) = '0') then
					nxt_state <= S6; -- GAME OVER: Error del jugador.
				end if;
				
				
			when S6 =>
				-- MANDAR SEÑALES DE MENSAJE GAME OVER
				OUT_MESSAGE <= 2; -- Mensaje de end
				wait for 5000 ms; 
				OUT_MESSAGE <= 0; -- No sacar nada por los displays
				nxt_state <= S0_WT; -- Vuelta a la espera de una nueva partida.
				
				
			when others =>
				nxt_state <= S0_WT; -- En caso de fallo, volver al estado de espera.
				
				
		end case;
				
	end process;
	
	
	output_decoder: process(cur_state) -- Esta parte es COMBINACIONAL. Solo cambia en caso de cambiar el estado
	begin
		-- Asegurar que el proceso sea combiancional
		START <= '0';
		PARAM <= cur_size;
		RST_COUNT <= '0';
		CUR_ROUND <= 0;
		CUR_TEMP <= 0;
		SEQUENCE_VALUE	<= 0;
		USER_INPUT <= 0;
		OUT_MESSAGE <= 0;
		
		case cur_state is
			when S0_WT =>
				-- SLAVE INTERFACE
				START		<= '0';
				PARAM 		<= 0;
				RST_COUNT	<= '0';
				-- VISUALIZER INTERFACE
				CUR_ROUND	<= 0;
				
			when S0 =>
				-- SLAVE INTERFACE
				START 		<= '0';
				PARAM 		<= 0;
				RST_COUNT 	<= '0';
				-- VISUALIZER INTERFACE
				CUR_ROUND	<= cur_size;
				
			when S1 =>
				-- SLAVE INTERFACE
				START 		<= '0';
				PARAM 		<= 0;
				RST_COUNT 	<= '1'; 		-- Reseteo de la cuenta del temporizador. El jugador introdujo a tiempo la secuencia.
				-- VISUALIZER INTERFACE
				CUR_ROUND	<= cur_size;
				
			when S2 =>
				-- SLAVE INTERFACE
				START 		<= '0';
				PARAM 		<= 0;
				RST_COUNT 	<= '0';
				-- VISUALIZER INTERFACE
				CUR_ROUND	<= cur_size;
				
			when S3 =>
				-- SLAVE INTERFACE
				START 		<= '1'; 		-- Disparo del temporizador
				PARAM 		<= cur_size;	-- Carga del valor del temporizador
				RST_COUNT 	<= '0';
				-- VISUALIZER INTERFACE
				CUR_ROUND	<= cur_size;
				
			when S4 =>
				-- SLAVE INTERFACE
				START 		<= '0';
				PARAM 		<= 0;
				RST_COUNT 	<= '0';ç
				-- VISUALIZER INTERFACE
				CUR_ROUND	<= cur_size;
				
			when S5 =>
				-- SLAVE INTERFACE
				START 		<= '0';
				PARAM 		<= 0;
				RST_COUNT 	<= '0';
				-- VISUALIZER INTERFACE
				CUR_ROUND	<= cur_size;
				
			when S6 =>
				-- SLAVE INTERFACE
				START 		<= '0';
				PARAM 		<= 0;
				RST_COUNT 	<= '0';
				-- VISUALIZER INTERFACE
				CUR_ROUND	<= 0;
				
		end case;
	end process output_decoder;
	
end architecture behavioral;



