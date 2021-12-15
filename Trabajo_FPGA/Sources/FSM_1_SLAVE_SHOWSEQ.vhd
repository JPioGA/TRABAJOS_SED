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
        TIME_WAIT   : natural := 2 -- ciclos de reloj de espera
    );
    port (
        CLK                     : in STD_LOGIC;
        RST_N                   : in STD_LOGIC;
        LED_VALUE               : out LED_T; --LED a bit
        STATE                   : out STATE_SHOWSEQ_T; -- Estado actual de la m醧uina
        
        -- MASTER-SLAVE SHOWSEQ interface
        START_SHOWSEQ           : in std_logic;
        PARAM_SHOWSEQ_sequence  : in natural_vector;
        PARAM_SHOWSEQ_size      : in natural;
        DONE_SHOWSEQ            : out std_logic;

        -- SLAVE SHOWSEQ-SLAVE WAITLED interface
        START_WAITLED   : out std_logic;
        PARAM_WAITLED   : out natural; -- N煤mero de ciclos de reloj a esperar
        DONE_WAITLED    : in std_logic
    );
end FSM_1_SLAVE_SHOWSEQ;


architecture Behavioral of FSM_1_SLAVE_SHOWSEQ is
	signal cur_state    : STATE_SHOWSEQ_T;    -- Estado actual
	signal nxt_state	: STATE_SHOWSEQ_T;    -- Estado siguiente
begin
    state_register: process(CLK, RST_N)
	begin
		if RST_N = '0' then -- Si entra un reset, mandar a reposo la m谩quina de estados
			cur_state <= S2_STBY;
		elsif rising_edge(CLK) then
			cur_state <= nxt_state;
		end if;
	end process state_register;
    
    nxt_state_decoder: process(cur_state, DONE_WAITLED, START_SHOWSEQ)
        variable button_pushed : natural := 0; -- Variable auxiliar de comprobaci贸n de bot贸n pulsado
        variable i : natural := 0;    -- Elemento iterador
    begin
        nxt_state <= cur_state;
        
        case cur_state is
            when S2_STBY =>
                if START_SHOWSEQ = '1' then
                    nxt_state <= S2_0; --Comienzo de la comprobaci贸n
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
               if falling_edge(DONE_WAITLED) then nxt_state <= S2_5;  end if;
            when S2_2 =>
                nxt_state <= S2_2WT;       
            when S2_2WT =>
               if falling_edge(DONE_WAITLED) then nxt_state <= S2_5;  end if;
            when S2_3 =>
                nxt_state <= S2_3WT;    
            when S2_3WT =>
                if falling_edge(DONE_WAITLED) then nxt_state <= S2_5;  end if;
            when S2_4 =>
                nxt_state <= S2_4WT;   
            when S2_4WT =>
                 if falling_edge(DONE_WAITLED) then nxt_state <= S2_5;  end if;
                 
            when S2_5 =>
                if (i < (PARAM_SHOWSEQ_size - 1)) then -- Pulsaci贸n correcta
                    nxt_state <= S2_0;
                    i := i + 1;
                else 
                    nxt_state <= S2_6;
                end if;
                
            when S2_6 =>
                -- Reinicio de las variables auxiliasres
                i := 0;
                nxt_state <= S2_STBY;
                
            when others =>
                i := 0;
                nxt_state <= S2_STBY; -- En caso de error en los estados, mandar a reposo la m谩quina de estado
        end case;
    end process nxt_state_decoder;
    
    output_decoder: process(cur_state)
    begin
        LED_VALUE     <= 0;
        DONE_SHOWSEQ  <= '0';
        START_WAITLED <= '0';
        PARAM_WAITLED <= 0;
        STATE <= S2_STBY;
        case cur_state is
            when S2_STBY =>
                LED_VALUE    <= 0;
                DONE_SHOWSEQ <= '0';
                START_WAITLED <= '0';
                PARAM_WAITLED <= 0;
                STATE         <= S2_STBY;
            when S2_0 =>
                LED_VALUE    <= 0;
                DONE_SHOWSEQ <= '0';
                START_WAITLED <= '0';
                PARAM_WAITLED <= 0;
                STATE         <= S2_0;
            when S2_1 =>
                LED_VALUE     <= 1;
                DONE_SHOWSEQ  <= '0';
                START_WAITLED <= '1';
                PARAM_WAITLED <= TIME_WAIT;
                STATE         <= S2_1;
            when S2_1WT =>
                LED_VALUE     <= 1;
                DONE_SHOWSEQ  <= '0';
                START_WAITLED <= '0';
                PARAM_WAITLED <= TIME_WAIT;
                STATE         <= S2_1WT;
            when S2_2 =>
                LED_VALUE     <= 2;
                DONE_SHOWSEQ  <= '0';
                START_WAITLED <= '1';
                PARAM_WAITLED <= TIME_WAIT;
                STATE         <= S2_2;
            when S2_2WT =>
                LED_VALUE     <= 2;
                DONE_SHOWSEQ  <= '0';
                START_WAITLED <= '0';
                PARAM_WAITLED <= TIME_WAIT;
                STATE         <= S2_2WT;
            when S2_3 =>
                LED_VALUE     <= 3;
                DONE_SHOWSEQ  <= '0';
                START_WAITLED <= '1';
                PARAM_WAITLED <= TIME_WAIT;
                STATE         <= S2_3;
            when S2_3WT =>
                LED_VALUE     <= 3;
                DONE_SHOWSEQ  <= '0';
                START_WAITLED <= '0';
                PARAM_WAITLED <= TIME_WAIT;
                STATE         <= S2_3WT;
            when S2_4 =>
                LED_VALUE     <= 4;
                DONE_SHOWSEQ  <= '0';
                START_WAITLED <= '1';
                PARAM_WAITLED <= TIME_WAIT;
                STATE         <= S2_4;
            when S2_4WT =>
                LED_VALUE     <= 4;
                DONE_SHOWSEQ  <= '0';
                START_WAITLED <= '0';
                PARAM_WAITLED <= TIME_WAIT;
                STATE         <= S2_4WT;
            when S2_5 =>
                LED_VALUE     <= 0;
                DONE_SHOWSEQ  <= '0';
                START_WAITLED <= '0';
                PARAM_WAITLED <= 0;
                STATE         <= S2_5;
            when S2_6 =>
                LED_VALUE     <= 0;
                DONE_SHOWSEQ  <= '1';
                START_WAITLED <= '0';
                PARAM_WAITLED <= 0;
                STATE         <= S2_6;
            when others =>
                LED_VALUE     <= 0;
                DONE_SHOWSEQ  <= '0';
                START_WAITLED <= '0';
                PARAM_WAITLED <= 0;
                STATE         <= S2_STBY;
        end case;
    end process output_decoder;
end Behavioral;
