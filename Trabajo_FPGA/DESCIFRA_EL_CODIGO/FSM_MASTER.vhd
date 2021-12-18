-----------------------------------------------------------------------------------
-- FSM_MASTER
-- Máqina de estado encargada de la coordinación general de las fases del juego.
-- Se encarga de coordinar las fases del juego: Muestra de mensajes, el inicio y fin del juego
-----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use work.tipos_especiales.ALL;

entity FSM_MASTER is
    port (  CLK : in std_logic;
            RST_N : in std_logic;
            OK_BUTTON   : in std_logic;
            OUT_MESSAGE : out std_logic_vector(2 downto 0); -- "000" si nada // "001" si START // "010" si GO // "011" si GAME OVER // "100" si WIN
            
            -- Interfez entre MASTER y TIMER
            START_TIMER : out std_logic;
            DONE_TIMER  : in std_logic;
            
            -- Interfaz entre MASTER y LFSR
            RAND_SEQ    : in SEQUENCE_T;
            DONE_LFSR   : in std_logic;
            
            -- Interfaz entre MASTER e INCHECK
            START_INCHECK : out std_logic;
            PARAM_SEQ     : out SEQUENCE_T;
            DONE_INCHECK : in std_logic_vector(1 downto 0) -- "00" si NOT DONE // "01" si WIN // "10" si GAME OVER
            );
end FSM_MASTER;

architecture Behavioral of FSM_MASTER is
    -- Declaración de señales utilizadas en el juego
    signal cur_state	 : STATE_MASTER_T; -- Estado actual
	signal nxt_state	 : STATE_MASTER_T; -- Estado siguiente
	signal game_sequence : SEQUENCE_T;     -- Secuencia a adivinar por el jugador
	
begin
    -- Actualización de los estados
	state_register: process(CLK, RST_N)
	begin
		if RST_N = '0' then -- Si entra un reset, mandar a reposo la máquina de estados
			cur_state <= S_STBY;
		elsif rising_edge(CLK) then
			cur_state <= nxt_state;
		end if;
	end process;
    
    
    -- TRANSICIONES DE ESTADO
    nxt_state_decoder: process(CLK, cur_state)
    begin
        -- Asegurar que el proceso sea combinacional
		nxt_state <= cur_state;
		
		case cur_state is
			when S_STBY =>
				if OK_BUTTON = '1' then -- Inicio del juego
					nxt_state <= S0;
				end if;
				
			when S0 =>
			    if DONE_LFSR = '1' then -- Llegada de una nueva secuencia
                    game_sequence <= RAND_SEQ; -- Cargo la nueva secuencia a adivinar en la señal auxiliar
                    nxt_state <= S1; -- Tras recibir la nueva secuencia, paso al siguiente estado
				end if;
				
			when S1 =>
                nxt_state <= S1_WT; -- Disparo el timer y paso a esperar
                
			when S1_WT =>
				if DONE_TIMER = '1' then -- Fin de la espera
					nxt_state <= S2;
				end if;
				
			when S2 => 
                nxt_state <= S2_WT; -- Disparo del incheck y paso a espera del fin del juego
                
			when S2_WT =>
				if DONE_INCHECK = "10" then -- Partida perdida. Paso a GAME OVER
					nxt_state <= S4;
			    elsif DONE_INCHECK = "01" then -- Partida ganada. Paso a WIN
			        nxt_state <= S3;
				end if;
				
			when S3 =>
				nxt_state <= S3_WT; -- Disparo el timer y paso a esperar
				
			when S3_WT =>
                if DONE_TIMER = '1' then -- Fin de la espera
					nxt_state <= S_STBY;
				end if;	
							
			when S4 =>
                nxt_state <= S4_WT; -- Disparo el timer y paso a esperar
                
			when S4_WT => 
                if DONE_TIMER = '1' then -- Fin de la espera
                    nxt_state <= S_STBY;
				end if;
				
			when others =>
                nxt_state <= S_STBY; -- En caso de fallo, volver al estado de espera.	
		end case;
    end process;
    
    
    -- ACTUALIZACIÓN DE LAS SALIDAS SEGÚN EL ESTADO
    output_decoder: process(cur_state)
    begin
        START_TIMER     <= '0';
        START_INCHECK   <= '0';
        OUT_MESSAGE     <= "000";
        PARAM_SEQ       <= ((others => '0'), (others => '0'), (others => '0'), (others => '0'));
        
        case cur_state is
			when S_STBY =>
                OUT_MESSAGE <= "001"; -- START MESSAGE
				
			when S0 =>
			    -- Aqui se espera ha tener una nueva secuencia aleatoria. No hay salidas 
				
			when S1 =>
                START_TIMER <= '1'; 
                
			when S1_WT =>
                OUT_MESSAGE <= "010"; -- GO MESSAGE
				
			when S2 => 
                START_INCHECK <= '1'; 
                PARAM_SEQ <= game_sequence; -- Inicio del juego con la secuencia aleatoria
                
			when S2_WT =>
				PARAM_SEQ <= game_sequence; -- Mantenimiento de la secuencia durante el juego
				
			when S3 =>
                START_TIMER <= '1';
				
			when S3_WT =>
                OUT_MESSAGE <= "010"; -- WIN MESSAGE
							
			when S4 =>
                START_TIMER <= '1'; 
                
			when S4_WT => 
                OUT_MESSAGE <= "010"; -- GAME OVER MESSAGE
				
			when others =>
                START_TIMER     <= '0';
                START_INCHECK   <= '0';
                OUT_MESSAGE     <= "000";
                	
		end case;
    end process;
end Behavioral;