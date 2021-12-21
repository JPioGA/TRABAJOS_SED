library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.tipos_especiales.ALL;

entity FSM_SLAVE_INCHECK is
    port (  CLK             : in std_logic;
            RST_N           : in std_logic;
            START_INCHECK   : in std_logic;  -- Señal de inicio de la comparación
            PARAM_SEQ       : in SEQUENCE_T; -- Secuencia aleatoria a adivinar por el jugador
            --BTN             : in std_logic_vector (3 downto 0); -- Entrada de botones pulsados. 
            UP_BTN          : in std_logic;
            DOWN_BTN          : in std_logic;
            LEFT_BTN          : in std_logic;
            RIGHT_BTN          : in std_logic;
            --LED             : out std_logic_vector (3 downto 0); -- LEDS a ENCENDER según se vayan encendiendo los LEDS.
            DONE_INCHECK    : out std_logic_vector(1 downto 0); -- "00" si NOT DONE // "01" si WIN // "10" si GAME OVER
            INTENTOS        : out natural range 0 to 9
                    
            );
end FSM_SLAVE_INCHECK;

architecture Behavioral of FSM_SLAVE_INCHECK is

    -- Señales utilizadas
    signal cur_state	 : STATE_SLAVE_T;				-- Estado actual
	signal nxt_state	 : STATE_SLAVE_T;				-- Estado siguiente
	signal cur_size : natural := 4;
	signal nxt_size : natural;
	signal cur_try : natural := 9; -- Intentos del jugador
	signal nxt_try : natural;
	signal BTN     : std_logic_vector (3 downto 0);
    --signal tmp_button           : std_logic; -- Señal que indica el inicio de la comparación
    --signal tmp_button_pushed    : std_logic_vector (3 downto 0) := "0000";  -- Botón pulsado por el jugador
    --signal tmp_sequence :  SEQUENCE_T;
    --signal tmp_elem_to_compare   : std_logic_vector (3 downto 0); -- Elemento de la secuencia a comparar con el botón del juagador
    --signal tmp_result_comp      : std_logic; -- Señal que indica el resultado de la comparación entre el botón pulsado y secuencia 
begin    

    -- Actualización de los estados
	state_register: process(CLK, RST_N)
	begin
		if RST_N = '0' then -- Si entra un reset, mandar a reposo la máquina de estados
			cur_state <= S_STBY;
			cur_size <= 4;
			cur_try <= 4;
		--elsif rising_edge(CLK) or falling_edge(CLK) then
		elsif rising_edge(CLK) then
			cur_state <= nxt_state;
			cur_size <= nxt_size;
			cur_try <= nxt_try;
		end if;
	end process;
	
	-- TRANSICIONES DE ESTADO
    nxt_state_decoder: process(cur_state, START_INCHECK, BTN)
        variable tmp_sequence :  SEQUENCE_T;
        --variable tmp_button_pushed    : std_logic_vector (3 downto 0) := "0000"; -- Botón pulsado por el jugador
        --variable size : natural := 4;
        --variable try  : natural := 9; -- Intentos del jugador
    begin
        -- Asegurar que el proceso sea combinacional
		nxt_state <= cur_state;
		nxt_size <= cur_size;
		nxt_try <= cur_try;
        INTENTOS <= cur_try;		
		DONE_INCHECK <= "00";
		
		BTN(0) <= UP_BTN;
        BTN(1) <= DOWN_BTN;
        BTN(2) <= LEFT_BTN;
        BTN(3) <= RIGHT_BTN;
    
		case cur_state is
			when S_STBY =>
				if START_INCHECK = '1' then -- Inicio del juego
				    tmp_sequence := PARAM_SEQ;
				    nxt_size <= 4;
				    nxt_try <= 4;
					nxt_state <= S1;
				end if;

	
			when S1 =>
                 --Guardamos continuamente el valor de entrada de los botones
			    if BTN /= "0000" and BTN /= "UUUU" then
                    nxt_state <= S2; -- Disparo el timer y paso a esperar
			    end if;

			when S2 =>
                if BTN = tmp_sequence(cur_size-1) then -- OK INPUT
                    if cur_size >= 1 then
                        nxt_size <= cur_size - 1;
                        nxt_state <= S1; -- Vuelta a esperar un input
                    end if;
                elsif BTN /= tmp_sequence(cur_size-1) then -- NO OK INPUT
                    if cur_try >= 1 then
                        nxt_try <= cur_try - 1;
                        nxt_state <= S1; -- Vuelta a esperar un input
                    end if;
                end if;
                
                if cur_size < 1 then
                    nxt_state <= S3; -- WIN
				end if;
				if cur_try < 1 then -- Si TRY era 1, significa que esta ronda era su ultimo intento.
                     nxt_state <= S4; -- GAME OVER
                end if;
                
                
			when S3 =>
			    DONE_INCHECK <= "01";
                nxt_state <= S_STBY; -- Envio de señal de DONE
				
				
			when S4 =>
                DONE_INCHECK <= "10";
                nxt_state <= S_STBY;
				
			when others =>
                DONE_INCHECK <= "00";
                nxt_state <= S_STBY; -- En caso de fallo, volver al estado de espera.	
		end case;
		
	end process;
end Behavioral;
