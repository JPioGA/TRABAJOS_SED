----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.tipos_esp.ALL;

entity FSM_1_SLAVE_INCHECK is
    generic(
        MAX_ROUND   : natural := 99;
        COLORS      : natural := 4
    );
    port (
        CLK                     : in STD_LOGIC;
        RST_N                   : in STD_LOGIC;
        START_INCHECK           : in std_logic;
        PARAM_INCHECK_size      : in natural; -- SIZE. Tamaño de la secuencia actual
        PARAM_INCHECK_seq       : in natural_vector; -- SEQ. Secuencia actual
        DONE_INCHECK            : out natural; -- 0: none; 1: NO OK; 2: name
        UP_BUTTON               : in std_logic;
        DOWN_BUTTON             : in std_logic;
        RIGHT_BUTTON            : in std_logic;
        LEFT_BUTTON             : in std_logic;
        LED_VALUE               : out natural --LED a encender
    );
end FSM_1_SLAVE_INCHECK;


architecture Behavioral of FSM_1_SLAVE_INCHECK is	
	type STATE_T is (
	    S3_WT,  -- S3_WT: Estado de STANDBY. Cuando la máquian de estados no está en uso.
		S3_0,	-- S3_0: ESPERA al INPUT. Hasta que no se pulse un botón no se comprueba si es correcto o no.
		S3_1,   -- S3_1: LED 1 ON
		S3_2,   -- S3_2: LED 2 ON
		S3_3,	-- S3_3: LED 3 ON
		S3_4,   -- S3_4: LED 4 ON
		S3_5,   -- S3_5: COMPROBACIÓN del INPUT
		S3_6,	-- S3_6: INPUTS OK: El jugador ha introducido todos los valores correctamente.
		S3_7	-- S3_7: GAME OVER. El jugador ha perdido por fin del tiempo o por error en el input. Se muestra animación de fin de juego
	);
    signal cur_state    : STATE_T;    -- Estado actual
	signal nxt_state	: STATE_T;    -- Estado siguiente
begin
    state_register: process(CLK, RST_N)
	begin
		if RST_N = '0' then -- Si entra un reset, mandar a reposo la máquina de estados
			cur_state <= S3_WT;
		elsif rising_edge(CLK) then
			cur_state <= nxt_state;
		end if;
	end process state_register;
    
    
    nxt_state_decoder: process(cur_state, UP_BUTTON, DOWN_BUTTON, RIGHT_BUTTON, LEFT_BUTTON)
        variable button_pushed : natural := 0; -- Variable auxiliar de comprobación de botón pulsado
        variable i : natural := 0;    -- Elemento iterador
    begin
        nxt_state <= cur_state;
        
        case cur_state is
            when S3_WT =>
                if START_INCHECK = '1' then
                    nxt_state <= S3_0; --Comienzo de la comprobación
                end if;
                
            when S3_0 =>
                if UP_BUTTON = '1' then -- Ponerlo como rising_edge
                    button_pushed := 1;
                    nxt_state <= S3_1;
                elsif DOWN_BUTTON = '1' then
                    button_pushed := 2;
                    nxt_state <= S3_2;
                elsif RIGHT_BUTTON = '1' then
                    button_pushed := 3;
                    nxt_state <= S3_3;
                elsif LEFT_BUTTON  = '1' then
                    button_pushed := 4;
                    nxt_state <= S3_4;
                end if;
                
            when S3_1 =>
                wait for 250 ms; -- Tiempo de encendido del LED elegido por el jugador
                nxt_state <= S3_5;
                
            when S3_2 =>
                wait for 250 ms;
                nxt_state <= S3_5;
                
            when S3_3 =>
                wait for 250 ms;
                nxt_state <= S3_5;
                
            when S3_4 =>
                wait for 250 ms;
                nxt_state <= S3_5;
                
            when S3_5 =>
                if (button_pushed = PARAM_INCHECK_seq(i)) AND (i < (PARAM_INCHECK_size - 1)) then -- Pulsación correcta
                    i := i + 1;
                    nxt_state <= S3_0;
                elsif (button_pushed = PARAM_INCHECK_seq(i)) AND (i = (PARAM_INCHECK_size - 1)) then -- Pulsación correcta y fin de comprobación
                    nxt_state <= S3_7;
                else -- Pulsación incorrecta
                    nxt_state <= S3_6;
                end if;
                
            when S3_6 =>
                -- Reinicio de las variables auxiliasres
                i := 0;
                button_pushed := 0;
                nxt_state <= S3_WT;
                
            when S3_7 =>
                -- Reinicio de las variables auxiliasres
                i := 0;
                button_pushed := 0;
                nxt_state <= S3_WT;
                
            when others =>
                i := 0;
                button_pushed := 0;
                nxt_state <= S3_WT; -- En caso de erro, mandar a reposo la máquina de estado
        end case;
    end process nxt_state_decoder;
    
    
    output_decoder: process(cur_state)
    begin
        LED_VALUE    <= 0;
        DONE_INCHECK <= 0;
        case cur_state is
            when S3_WT =>
                LED_VALUE    <= 0;
                DONE_INCHECK <= 0;
            when S3_0 =>
                LED_VALUE    <= 0;
                DONE_INCHECK <= 0;
            when S3_1 =>
                LED_VALUE    <= 1;
                DONE_INCHECK <= 0;
            when S3_2 =>
                LED_VALUE    <= 2;
                DONE_INCHECK <= 0;
            when S3_3 =>
                LED_VALUE    <= 3;
                DONE_INCHECK <= 0;
            when S3_4 =>
                LED_VALUE    <= 4;
                DONE_INCHECK <= 0;
            when S3_5 =>
                LED_VALUE    <= 0;
                DONE_INCHECK <= 0;
            when S3_6 =>
                LED_VALUE    <= 0;
                DONE_INCHECK <= 1; -- Se ha cometido un error.
            when S3_7 =>
                LED_VALUE    <= 0;
                DONE_INCHECK <= 2; -- Comprobación completa OK
            when others =>
                LED_VALUE    <= 0;
                DONE_INCHECK <= 0;
        end case;
    end process output_decoder;
end Behavioral;

