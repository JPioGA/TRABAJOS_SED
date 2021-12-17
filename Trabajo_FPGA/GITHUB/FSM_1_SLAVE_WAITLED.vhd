----------------------------------------------------------------------------------
-- FSM_1_SLAVE_WAITLED
-- Esta es una m�quina de estados encargada de realizar las esperas para mantener
-- los LEDS o DISPLAYS encendidos durante un tiempo determinado.
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity FSM_1_SLAVE_WAITLED is
    port (
        CLK		      :	in 	std_logic; -- Entrada de RELOJ
		RST_N	      :	in 	std_logic; -- Entrada de RESET
        START_WAITLED : in std_logic;
        PARAM_WAITLED : in natural; -- Número de ciclos de reloj a esperar
        DONE_WAITLED  : out std_logic
    );
end FSM_1_SLAVE_WAITLED;

architecture Behavioral of FSM_1_SLAVE_WAITLED is
begin
    process(CLK, RST_N)
    variable count : natural;
    variable fin_count : natural;
	begin
		if RST_N = '0' then -- Si entra un reset, mandamos a reposo la máquina de estados
			count := 0;
			DONE_WAITLED <= '0';
		elsif rising_edge(CLK) then
		    DONE_WAITLED <= '0';
			if START_WAITLED = '1' then
				count := PARAM_WAITLED;
			end if;
			if count /= 0 then --Contamos de forma decreciente
				count := count - 1;
				fin_count := fin_count + 1;
		    else 
		      if PARAM_WAITLED /= 0 then
		         if fin_count = PARAM_WAITLED then
				    DONE_WAITLED <= '1';
				    fin_count := 0;
			     end if;
			  end if;
			end if;
			
		end if;
	end process;
	
	end;