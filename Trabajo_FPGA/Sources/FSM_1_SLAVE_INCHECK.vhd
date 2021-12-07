----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity FSM_1_SLAVE_INCHECK is
    port (
        CLK             : in STD_LOGIC;
        RST_N           : in STD_LOGIC;
        START_INCHECK   : in std_logic;
        PARAM_INCHECK   : in natural;
        DONE_INCHECK    : out natural; -- 0: none; 1: NO OK; 2: name
        UP_BUTTON       : in std_logic;
        DOWN_BUTTON     : in std_logic;
        RIGHT_BUTTON    : in std_logic;
        LEFT_BUTTON     : in std_logic;
        LED_VALUE       : out natural --LED a encender
    );
end FSM_1_SLAVE_INCHECK;


architecture Behavioral of FSM_1_SLAVE_INCHECK is
    -- COMPROBACIÓN DEL VALOR INTRODUCIDO POR EL JUGADOR (Devuelve '1' si OK, '0' si NO OK)
	pure function check_input(player_in : natural; seq : natural) return std_logic is
	begin
		if player_in = seq then return '1';
		else return '0';
		end if;
	end function check_input;

begin


end Behavioral;








--Espera a introducir un valor por los botones (utilizar un flag que indique que se ha introducido un valor)
				-- LECTURA Y ACTIVACIÓN DEL FLAG. TAMBIÉN MANDAR MENSAJES DE LOS LEDS PULSADOS AL VISUALIZER
				if DONE = '1' then
					nxt_state <= S6; -- GAME OVER: fin del tiempo del temporizador
				elsif (flag_button_pushed = '1') then
					flag_button_pushed = '0'; -- Reinicio el flag
					nxt_state <= S5; -- Se introfujo un valor
				end if;
				


if (check_input(player_in, game_sequence(i)) = '1') and (i < cur_size-1) then
					i := i + 1;
					nxt_state <= S4; -- Se introdujo el valor correcto. Aún no ha terminado la secuencia
				elsif (check_input(player_in, game_sequence(i)) = '1') and (i = cur_size-1) then
					i := 0; --OJO! Esto también se hace en S1. No se si afecta
					nxt_state <= S1; -- Se introdujo el valor correcto. Ha terminado la secuencia. Comienza nueva ronda
				elsif (check_input(player_in, game_sequence(i)) = '0') then
					nxt_state <= S6; -- GAME OVER: Error del jugador.
				end if;