library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 


entity FSM_1_SLAVE is
	port (
		CLK		:	in 	std_logic; -- Entrada de RELOJ
		RST_N	:	in 	std_logic; -- Entrada de RESET a nivel bajo
		
		START		:	in 	std_logic; -- Señal de inicio del temporizador
		PARAM		:	in 	natural; -- Tiempo carga del temporizador
		RST_COUNT	:	in 	std_logic; -- Señal que indica que el temporizador deje de contar. El jugador introdujo a tiempo la secuencia.
		DONE 		:	out std_logic; -- Señal de fin del temporizador
		COUNT		:	out natural; -- Valor actual de la cuenta del temporizador.
	);
end entity FSM_1_SLAVE;

architecture behavioral of FSM_1_SLAVE is
	signal count 	: natural;
	signal cur_state	: STATE_T;		-- Estado actual
	signal nxt_state	: STATE_T;		-- Estado siguiente
	type STATE_T is (
		S0_SLV,		-- S0_SLV: Estado de contador activo
		S1_SLV		-- S1_SLV: Estado de contador no activo
	);
	
begin
	process(CLK, RST_N, RST_COUNT) -- Entradas asíncronas (RST_COUNT)
	begin
		DONE <= '1' when count = 0 else '0';
		
		if RST_N = '0' then -- Si entra un reset, mandamos a reposo la máquina de estados
			count <= 0;
			DONE <= '1';
		elsif RST_COUNT = '1' then
			DONE <= '0';
		elsif rising_edge(CLK) then
			if START = '1' then
				count <= PARAM;
				DONE <= '0';
			elsif count /= '0' then --Contamos de forma decreciente
				count <= count - 1;
			else
				DONE <= '1';
			end if;
		end if;
		
	end process;
end architecture behavioral;