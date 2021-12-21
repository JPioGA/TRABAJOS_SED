library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.tipos_especiales.ALL;

entity FSM_INCHECK is
    port (  CLK : in STD_LOGIC;
            RST_N           : in std_logic;
            START_INCHECK   : in std_logic;  -- Señal de inicio de la comparación
            PARAM_SEQ       : in SEQUENCE2_T; -- Secuencia aleatoria a adivinar por el jugador
 
            UP_BTN          : in std_logic;
            DOWN_BTN        : in std_logic;
            LEFT_BTN        : in std_logic;
            RIGHT_BTN       : in std_logic;
            --LED           : out std_logic_vector (3 downto 0); -- LEDS a ENCENDER según se vayan encendiendo los LEDS.
            DONE_INCHECK    : out std_logic_vector(1 downto 0); -- "00" si NOT DONE // "01" si WIN // "10" si GAME OVER
            INTENTOS        : out natural range 0 to 9);
end FSM_INCHECK;

architecture Behavioral of FSM_INCHECK is
    -- Señales utilizadas
    signal cur_state	 : STATE_INCHECK_T;				-- Estado actual
	signal nxt_state	 : STATE_INCHECK_T;				-- Estado siguiente
	signal cur_size : natural := 4;
	signal nxt_size : natural;
	signal cur_try : natural := 9; -- Intentos del jugador
	signal nxt_try : natural;
	
begin
    -- Actualización de los estados
	state_register: process(CLK, RST_N)
	begin
		if RST_N = '0' then -- Si entra un reset, mandar a reposo la máquina de estados
			cur_state <= S_STBY;
			cur_size <= 4;
			cur_try <= 5;
		elsif rising_edge(CLK) then
			cur_state <= nxt_state;
			cur_size <= nxt_size;
			cur_try <= nxt_try;
		end if;
	end process;
	
	
	-- TRANSICIONES DE ESTADO
    nxt_state_decoder: process(cur_state,UP_BTN,DOWN_BTN,LEFT_BTN,RIGHT_BTN,PARAM_SEQ)
        --variable tmp_sequence :  SEQUENCE2_T;
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
		
    
		case cur_state is
			when S_STBY =>
				if START_INCHECK = '1' then -- Inicio del juego
				    --tmp_sequence := PARAM_SEQ;
				    nxt_size <= 4;
				    nxt_try <= 5;
					nxt_state <= S0;
				end if;
						
			when S0 =>
                if PARAM_SEQ(cur_size-1) = "00" then -- Paso a esperar UP_BTN
                    nxt_state <= S1;
                elsif PARAM_SEQ(cur_size-1) = "01" then -- Paso a esperar DOWN_BTN
                    nxt_state <= S2;
                elsif PARAM_SEQ(cur_size-1) = "10" then -- Paso a esperar LEFT_BTN
                    nxt_state <= S3;
                elsif PARAM_SEQ(cur_size-1) = "11" then -- Paso a esperar RIGHT_BTN
                    nxt_state <= S4;
                end if;
                           

			when S1 =>
			    if UP_BTN = '1' then
					nxt_state <= S5; -- OK
			    elsif (DOWN_BTN = '1')OR(RIGHT_BTN = '1')OR(LEFT_BTN = '1') then
			        nxt_state <= S6; -- NO OK
				end if;

			when S2 =>
			    if DOWN_BTN = '1' then
					nxt_state <= S5; -- OK
			    elsif (UP_BTN = '1')OR(RIGHT_BTN = '1')OR(LEFT_BTN = '1') then
			        nxt_state <= S6; -- NO OK
				end if;


            
            when S3 =>
                if LEFT_BTN = '1' then
					nxt_state <= S5; -- OK
			    elsif (DOWN_BTN = '1')OR(RIGHT_BTN = '1')OR(UP_BTN = '1') then
			        nxt_state <= S6; -- NO OK
				end if;
				
            when S4 =>
                if RIGHT_BTN = '1' then
					nxt_state <= S5; -- OK
			    elsif (DOWN_BTN = '1')OR(UP_BTN = '1')OR(LEFT_BTN = '1') then
			        nxt_state <= S6; -- NO OK
				end if;
                
            when S5 => -- INPUT OK
                if cur_size > 1 then 
                    nxt_size <= cur_size - 1;
                    nxt_state <= S0; 
                elsif cur_size <= 1 then
                    nxt_state <= S7; -- WIN
                end if;
                
            when S6 => -- INPUT NO OK
                if cur_try >= 1 then -- Si TRY era 1, significa que esta ronda era su ultimo intento.
                    nxt_try <= cur_try - 1;
                    nxt_size <= 4; -- Reinicio el tama�o a comparar
                    nxt_state <= S0; 
                elsif cur_try < 1 then
                    nxt_state <= S8; -- GAME OVER
                end if;
                  
			when S7 =>
			    DONE_INCHECK <= "01";
                nxt_state <= S_STBY; -- Envio de señal de DONE
				
	
			when S8 =>
                DONE_INCHECK <= "10";
                nxt_state <= S_STBY;
				
			when others =>
                DONE_INCHECK <= "00";
                nxt_state <= S_STBY; -- En caso de fallo, volver al estado de espera.	
		end case;
		
	end process;

end Behavioral;
