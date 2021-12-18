-----------------------------------------------------------------------------------
-- FSM_SLAVE_INCHECK
-- Compente esclavo de FSM_MASTER encargado de comprobar los inputs del jugador con
-- la secuencia creada.
-----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use work.tipos_especiales.ALL;

entity FSM_SLAVE_INCHECK is
    port (  CLK             : in std_logic;
            RST_N           : in std_logic;
            START_INCHECK   : in std_logic;  -- Se�al de inicio de la comparaci�n
            PARAM_SEQ       : in SEQUENCE_T; -- Secuencia aleatoria a adivinar por el jugador
            BTN             : in std_logic_vector (3 downto 0); -- Entrada de botones pulsados. 
            LED             : out std_logic_vector (3 downto 0); -- LEDS a ENCENDER seg�n se vayan encendiendo los LEDS.
            DONE_INCHECK    : out std_logic_vector(1 downto 0) -- "00" si NOT DONE // "01" si WIN // "10" si GAME OVER
            );
end FSM_SLAVE_INCHECK;

architecture Behavioral of FSM_SLAVE_INCHECK is

    -- Se�ales utilizadas
    signal cur_state	 : STATE_SLAVE_T;				-- Estado actual
	signal nxt_state	 : STATE_SLAVE_T;				-- Estado siguiente
	
    signal tmp_button           : std_logic; -- Se�al que indica el inicio de la comparaci�n
    signal tmp_button_pushed    : std_logic_vector (3 downto 0); -- Bot�n pulsado por el jugador
    signal tmp_seq_to_compare   : std_logic_vector (3 downto 0); -- Elemento de la secuencia a comparar con el bot�n del juagador
    signal tmp_result_comp      : std_logic; -- Se�al que indica el resultado de la comparaci�n entre el bot�n pulsado y secuencia 
begin
    comp: COMPARATOR 
        port map (  CLK  => CLK,
                    CE   => tmp_button,
                    X    => tmp_seq_to_compare,
                    Y    => tmp_button_pushed,
                    EQ   => tmp_result_comp
);
                    
    -- Actualizaci�n de los estados
	state_register: process(CLK, RST_N)
	begin
		if RST_N = '0' then -- Si entra un reset, mandar a reposo la m�quina de estados
			cur_state <= S_STBY;
		elsif rising_edge(CLK) then
			cur_state <= nxt_state;
		end if;
	end process;
end Behavioral;
