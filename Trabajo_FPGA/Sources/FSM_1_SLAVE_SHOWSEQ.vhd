----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity FSM_1_SLAVE_SHOWSEQ is
    generic(
        MAX_ROUND   : natural := 99;
        COLORS      : natural := 4
    );
    port (
        CLK                     : in STD_LOGIC;
        RST_N                   : in STD_LOGIC;
        START_SHOWSEQ           : in std_logic;
        PARAM_SHOWSEQ_sequence  : in natural(0 to MAX_ROUND-1);
        PARAM_SHOWSEQ_size      : in natural;
        DONE_SHOWSEQ            : out std_logic;
        LED_VALUE               : out natural --LED a encender
    );
end FSM_1_SLAVE_SHOWSEQ;


architecture Behavioral of FSM_1_SLAVE_SHOWSEQ is
    type STATE_T is (
	    S2_WT,  -- S2_WT: Estado de STANDBY. Cuando la máquian de estados no está en uso.
		S2_0,	-- S2_0: COMPROBACIÓN de valor de la secuancia a encender.
		S2_1,   -- S2_1: LED 1 ON
		S2_2,   -- S2_2: LED 2 ON
		S2_3,	-- S2_3: LED 3 ON
		S2_4,   -- S2_4: LED 4 ON
		S2_5,   -- S2_5: COMPROBACIÓN si se ha completado la secuencai
		S2_6	-- S2_6: END SHOW SEQUENCE.
	);
	signal cur_state    : STATE_T;    -- Estado actual
	signal nxt_state	: STATE_T;    -- Estado siguiente
begin
    state_register: process(CLK, RST_N)
	begin
		if RST_N = '0' then -- Si entra un reset, mandar a reposo la máquina de estados
			cur_state <= S2_WT;
		elsif rising_edge(CLK) then
			cur_state <= nxt_state;
		end if;
	end process state_register;
    
    nxt_state_decoder: process(cur_state)
        variable button_pushed : natural := 0; -- Variable auxiliar de comprobación de botón pulsado
        variable i : natural := 0;    -- Elemento iterador
    begin
        nxt_state <= cur_state;
        
        case cur_state is
            when S2_WT =>
                if START_SHOWSEQ = '1' then
                    nxt_state <= S2_0; --Comienzo de la comprobación
                end if;
                
            when S2_0 =>
                if PARAM_SHOWSEQ_sequence(i) = 1 then
                    nxt_state <= S2_1;
                elsif PARAM_SHOWSEQ_sequence(i) = 2 then
                    nxt_state <= S2_2;
                elsif PARAM_SHOWSEQ_sequence(i) = 3 then
                    nxt_state <= S2_3;
                elsif PARAM_SHOWSEQ_sequence(i) = 4 then
                    nxt_state <= S2_4;
                end if;
                
            when S2_1 =>
                wait for 250 ms; -- Tiempo de encendido del LED elegido por el jugador
                nxt_state <= S2_5;
                
            when S2_2 =>
                wait for 250 ms;
                nxt_state <= S2_5;
                
            when S2_3 =>
                wait for 250 ms;
                nxt_state <= S2_5;
                
            when S2_4 =>
                wait for 250 ms;
                nxt_state <= S2_5;
                
            when S2_5 =>
                if (i < (PARAM_SHOWSEQ_size - 1)) then -- Pulsación correcta
                    i := i + 1;
                    nxt_state <= S2_0;
                else 
                    nxt_state <= S2_6;
                end if;
                
            when S2_6 =>
                -- Reinicio de las variables auxiliasres
                i := 0;
                nxt_state <= S2_WT;
                
            when others =>
                i := 0;
                nxt_state <= S2_WT; -- En caso de error en los estados, mandar a reposo la máquina de estado
        end case;
    end process nxt_state_decoder;
    
    
    output_decoder: process(cur_state)
    begin
        LED_VALUE    <= 0;
        DONE_SHOWSEQ <= '0';
        case cur_state is
            when S2_WT =>
                LED_VALUE    <= 0;
                DONE_SHOWSEQ <= '0';
            when S2_0 =>
                LED_VALUE    <= 0;
                DONE_SHOWSEQ <= '0';
            when S2_1 =>
                LED_VALUE    <= 1;
                DONE_SHOWSEQ <= '0';
            when S2_2 =>
                LED_VALUE    <= 2;
                DONE_SHOWSEQ <= '0';
            when S2_3 =>
                LED_VALUE    <= 3;
                DONE_SHOWSEQ <= '0';
            when S2_4 =>
                LED_VALUE    <= 4;
                DONE_SHOWSEQ <= '0';
            when S2_5 =>
                LED_VALUE    <= 0;
                DONE_SHOWSEQ <= '0';
            when S2_6 =>
                LED_VALUE    <= 0;
                DONE_SHOWSEQ <= '1';
            when others =>
                LED_VALUE    <= 0;
                DONE_SHOWSEQ <= '0';
        end case;
    end process output_decoder;
end Behavioral;


















-- ENVIO DE MENSAJES DE SALIDA DE LA SECUENCIA
--				for i in 0 to (cur_size-1) loop
--					SEQUENCE_VALUE <= game_sequence(i); -- LED que encender (valores posibles: 1 2 3 4 (UP DOWN RIGHT LEFT))
--					wait for 2000 ms;
--				end loop;
--				nxt_state <= S3; -- Tras recorrer el vector, pasar al siguiente estado.
--				i := 0; --Reinicio del iterador
				
				-- Otra implementación por si el loop no es sintetizable
--				SEQUENCE_VALUE <= game_sequence(i); -- LED que encender (valores posibles: 1 2 3 4 (UP DOWN RIGHT LEFT))
--				wait for 2000 ms;
--				if i < (cur_size) then -- Si aún no se ha recorrido todo el vector
--					i := i + 1; -- Paso al siguiente elemento de la secuencia
--				else -- Si se ha recorrido todo el vector, se pasa al siguiente estado.
--					nxt_state <= S3;
--					i := 0; --Reinicio del iterador
--				end if;