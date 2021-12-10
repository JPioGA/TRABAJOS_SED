----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.tipos_esp.ALL;

entity FSM_1_SLAVE_SHOWSEQ is
    generic(
        MAX_ROUND   : natural := 99;
        COLORS      : natural := 4;
        TIME_WAIT   : natural := 1000000 --1 Mill�n de ciclos de reloj
    );
    port (
        CLK                     : in STD_LOGIC;
        RST_N                   : in STD_LOGIC;
        LED_VALUE               : out natural; --LED a bit
        
        -- MASTER-SLAVE SHOWSEQ interface
        START_SHOWSEQ           : in std_logic;
        PARAM_SHOWSEQ_sequence  : in natural_vector;
        PARAM_SHOWSEQ_size      : in natural;
        DONE_SHOWSEQ            : out std_logic;

        -- SLAVE SHOWSEQ-SLAVE WAITLED interface
        START_WAITLED   : out std_logic;
        PARAM_WAITLED   : out natural; -- N�mero de ciclos de reloj a esperar
        DONE_WAITLED    : in std_logic
    );
end FSM_1_SLAVE_SHOWSEQ;


architecture Behavioral of FSM_1_SLAVE_SHOWSEQ is
    type STATE_T is (
	    S2_STBY,  -- S2_STBY: Estado de STANDBY. Cuando la m�quian de estados no est� en uso.
		S2_0,	-- S2_0: COMPROBACI�N de valor de la secuancia a encender.
		S2_1,   -- S2_1: Disparo de WAITLED para LED 1 ON
		S2_1WT, -- S2_1WT: Mantenimiento de LED 1 ON
		S2_2,   -- S2_2: Disparo de WAITLED para LED 2 ON
		S2_2WT, -- S2_2WT: Mantenimiento de LED 2 ON
		S2_3,	-- S2_3: Disparo de WAITLED para LED 3 ON
		S2_3WT, -- S2_3WT: Mantenimiento de LED 3 ON
		S2_4,   -- S2_4: Disparo de WAITLED para LED 4 ON
		S2_4WT, -- S2_4WT: Mantenimiento de LED 4 ON
		S2_5,   -- S2_5: COMPROBACI�N si se ha completado la secuencai
		S2_6	-- S2_6: END SHOW SEQUENCE.
	);
	signal cur_state    : STATE_T;    -- Estado actual
	signal nxt_state	: STATE_T;    -- Estado siguiente
begin
    state_register: process(CLK, RST_N)
	begin
		if RST_N = '0' then -- Si entra un reset, mandar a reposo la m�quina de estados
			cur_state <= S2_STBY;
		elsif rising_edge(CLK) then
			cur_state <= nxt_state;
		end if;
	end process state_register;
    
    nxt_state_decoder: process(cur_state, DONE_WAITLED, START_SHOWSEQ)
        variable button_pushed : natural := 0; -- Variable auxiliar de comprobaci�n de bot�n pulsado
        variable i : natural := 0;    -- Elemento iterador
    begin
        nxt_state <= cur_state;
        
        case cur_state is
            when S2_STBY =>
                if START_SHOWSEQ = '1' then
                    nxt_state <= S2_0; --Comienzo de la comprobaci�n
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
                nxt_state <= S2_1WT; 
            when S2_1WT =>
                if DONE_WAITLED <= '1' then nxt_state <= S2_5; end if;
       
            when S2_2 =>
                nxt_state <= S2_2WT;       
            when S2_2WT =>
                if DONE_WAITLED <= '1' then nxt_state <= S2_5; end if;
                    
            when S2_3 =>
                nxt_state <= S2_3WT;    
            when S2_3WT =>
                if DONE_WAITLED <= '1' then nxt_state <= S2_5; end if;
                
            when S2_4 =>
                nxt_state <= S2_4WT;   
            when S2_4WT =>
                if DONE_WAITLED <= '1' then nxt_state <= S2_5; end if;
                 
            when S2_5 =>
                if (i < (PARAM_SHOWSEQ_size - 1)) then -- Pulsaci�n correcta
                    i := i + 1;
                    nxt_state <= S2_0;
                else 
                    nxt_state <= S2_6;
                end if;
                
            when S2_6 =>
                -- Reinicio de las variables auxiliasres
                i := 0;
                nxt_state <= S2_STBY;
                
            when others =>
                i := 0;
                nxt_state <= S2_STBY; -- En caso de error en los estados, mandar a reposo la m�quina de estado
        end case;
    end process nxt_state_decoder;
    
    output_decoder: process(cur_state)
    begin
        LED_VALUE     <= 0;
        DONE_SHOWSEQ  <= '0';
        START_WAITLED <= '0';
        PARAM_WAITLED <= 0;
        case cur_state is
            when S2_STBY =>
                LED_VALUE    <= 0;
                DONE_SHOWSEQ <= '0';
                START_WAITLED <= '0';
                PARAM_WAITLED <= 0;
            when S2_0 =>
                LED_VALUE    <= 0;
                DONE_SHOWSEQ <= '0';
                START_WAITLED <= '0';
                PARAM_WAITLED <= 0;
            when S2_1 =>
                LED_VALUE     <= 1;
                DONE_SHOWSEQ  <= '0';
                START_WAITLED <= '1';
                PARAM_WAITLED <= TIME_WAIT;
            when S2_1WT =>
                LED_VALUE     <= 1;
                DONE_SHOWSEQ  <= '0';
                START_WAITLED <= '0';
                PARAM_WAITLED <= 0;
            when S2_2 =>
                LED_VALUE     <= 2;
                DONE_SHOWSEQ  <= '0';
                START_WAITLED <= '1';
                PARAM_WAITLED <= TIME_WAIT;
            when S2_2WT =>
                LED_VALUE     <= 2;
                DONE_SHOWSEQ  <= '0';
                START_WAITLED <= '0';
                PARAM_WAITLED <= 0;
            when S2_3 =>
                LED_VALUE     <= 3;
                DONE_SHOWSEQ  <= '0';
                START_WAITLED <= '1';
                PARAM_WAITLED <= TIME_WAIT;
            when S2_3WT =>
                LED_VALUE     <= 3;
                DONE_SHOWSEQ  <= '0';
                START_WAITLED <= '0';
                PARAM_WAITLED <= 0;
            when S2_4 =>
                LED_VALUE     <= 4;
                DONE_SHOWSEQ  <= '0';
                START_WAITLED <= '1';
                PARAM_WAITLED <= TIME_WAIT;
            when S2_4WT =>
                LED_VALUE     <= 4;
                DONE_SHOWSEQ  <= '0';
                START_WAITLED <= '0';
                PARAM_WAITLED <= 0;
            when S2_5 =>
                LED_VALUE     <= 0;
                DONE_SHOWSEQ  <= '0';
                START_WAITLED <= '0';
                PARAM_WAITLED <= 0;
            when S2_6 =>
                LED_VALUE     <= 0;
                DONE_SHOWSEQ  <= '1';
                START_WAITLED <= '0';
                PARAM_WAITLED <= 0;
            when others =>
                LED_VALUE     <= 0;
                DONE_SHOWSEQ  <= '0';
                START_WAITLED <= '0';
                PARAM_WAITLED <= 0;
        end case;
    end process output_decoder;
end Behavioral;
