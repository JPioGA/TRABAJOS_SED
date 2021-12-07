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
		LED_VALUE       		: out natural --LED a encender
    );
end FSM_1_SLAVE_SHOWSEQ;


architecture Behavioral of FSM_1_SLAVE_SHOWSEQ is

begin


end Behavioral;

















-- ENVIO DE MENSAJES DE SALIDA DE LA SECUENCIA
				for i in 0 to (cur_size-1) loop
					SEQUENCE_VALUE <= game_sequence(i); -- LED que encender (valores posibles: 1 2 3 4 (UP DOWN RIGHT LEFT))
					wait for 2000 ms;
				end loop;
				nxt_state <= S3; -- Tras recorrer el vector, pasar al siguiente estado.
				i := 0; --Reinicio del iterador
				
				-- Otra implementación por si el loop no es sintetizable
--				SEQUENCE_VALUE <= game_sequence(i); -- LED que encender (valores posibles: 1 2 3 4 (UP DOWN RIGHT LEFT))
--				wait for 2000 ms;
--				if i < (cur_size) then -- Si aún no se ha recorrido todo el vector
--					i := i + 1; -- Paso al siguiente elemento de la secuencia
--				else -- Si se ha recorrido todo el vector, se pasa al siguiente estado.
--					nxt_state <= S3;
--					i := 0; --Reinicio del iterador
--				end if;