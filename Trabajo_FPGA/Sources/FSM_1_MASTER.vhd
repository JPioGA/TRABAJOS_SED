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
		CUR_ROUND		:	out positive;
		CUR_TEMP		:	out positive;
		SEQUENCE_VALUE	:	out positive;
		USER_INPUT		: 	out positive;
		OUT_MESSAGE		:	out positive;
		
		-- MASTER-SLAVE INTERFACE
		START		:	out std_logic; -- Señal de inicio del temporizador
		PARAM		:	out unsigned(8 downto 0); -- Tiempo carga del temporizador
		RST_COUNT	:	out std_logic; -- Señal que indica que el temporizador deje de contar. El jugador introdujo a tiempo la secuencia.
		DONE 		:	in 	std_logic; -- Señal de fin del temporizador
		COUNT		:	in 	positive -- Valor actual de la cuenta del temporizador.
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
	
	signal cur_state	: STATE_T; -- Estado actual
	signal nxt_state	: STATE_T; -- Estado siguiente
	signal aux_count	: unsigned(8 downto 0); -- Señal auxiliar que llevará la cuenta según el valor introducido como parámetro
	
	variable GAME_SEQUENCE 	: positive(MAX_ROUND-1 downto 0); -- Vector que contendrá en sus elementos los valores aleatorios a adivinar por el jugador.
	variable player_input	: positive; -- Varible auxiliar para indicar el valor introducido por el jugador.
	variable cur_size		: positive; -- Varible con el tamaño actual de la secuencia
	variable i				: positive := 0; -- Variable iteradora
	
	-- Declaración de funciones
		-- GENERACIÓN DE NÚMEROS ALEATORIOS (DEL 1 AL 4)
	impure function rand_num(max : positive := COLORS) return positive is
	  variable aux_result : real;
	  variable result : positive;
	begin
		uniform(seed1, seed2, aux_result); -- Genera un valor aleatorio entre 0 y 1
		result = ((aux_result * 100) mod COLORS) + 1; -- Obtención de un valor entero entre 1 y 4
	  return result;
	end function rand_num;
		
		-- COMPROBACIÓN DEL VALOR INTRODUCIDO POR EL JUGADOR (Devuelve '1' si OK, '0' si NO OK)
	pure function check_input(player_in : positive, seq : positive) return std_logic is
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
		
		-- Transiciones de estado
		case cur_state is
			when S0_WT =>
				if OK_BUTTON = '1' then
					nxt_state = S0;
				end if;
				
			when S0 =>
				
			when S1 =>
				
			when S2 =>
				
			when S3 =>
				
			when S4 =>
				
			when S5 =>
				
			when S6 =>
				
	end process;
	
	
	output_decoder: process(cur_state) -- Esta parte es COMBINACIONAL. Solo cambia en caso de cambiar el estado
	begin
		-- Asegurar que el proceso sea combiancional
		START = '0';
		RST_COUNT = '0';
		PARAM <= to_unsigned(cur_size, PARAM'length);
		
		case cur_state is
			when S0_WT =>
				START = '0';
				RST_COUNT = '0';
				
			when S0 =>
				START = '0';
				RST_COUNT = '0';
				
			when S1 =>
				START = '0';
				RST_COUNT = '1'; -- Reseteo de la cuenta del temporizador. El jugador introdujo a tiempo la secuencia.
				
			when S2 =>
				START = '0';
				RST_COUNT = '0';
				
			when S3 =>
				START = '1'; -- Disparo del temporizador
				RST_COUNT = '0';
				
			when S4 =>
				START = '0';
				RST_COUNT = '0';
				
			when S5 =>
				START = '0';
				RST_COUNT = '0';
				
			when S6 =>
				START = '0';
				RST_COUNT = '0';
				
	end process output_decoder;
	
end architecture behavioral;



