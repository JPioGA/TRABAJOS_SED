library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 


entity FSM_1_SLAVE is
	port (
		CLK		:	in 	std_logic; -- Entrada de RELOJ
		RST_N	:	in 	std_logic; -- Entrada de RESET a nivel bajo
		
		START		:	in 	std_logic; -- Señal de inicio del temporizador
		PARAM		:	in 	unsigned(8 downto 0); -- Tiempo carga del temporizador
		RST_COUNT	:	in std_logic; -- Señal que indica que el temporizador deje de contar. El jugador introdujo a tiempo la secuencia.
		DONE 		:	out std_logic; -- Señal de fin del temporizador
		COUNT		:	out positive; -- Valor actual de la cuenta del temporizador.
	);
end entity FSM_1_SLAVE;

architecture behavioral of FSM_1_SLAVE is
	signal count : unsigned(DELAY'range);
begin
	process(CLK, RST_N)
	begin
		
		
	end process;
end architecture behavioral;