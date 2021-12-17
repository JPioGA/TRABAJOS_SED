----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity FSM_1_SLAVE_TIMER is
    port (
        CLK         : in std_logic;
        RST_N       : in std_logic;
        START_TIMER : in std_logic;
        PARAM_TIMER : in natural;
        RST_COUNT   : in std_logic;
        DONE_TIMER  : out std_logic;
        COUNT       : out natural
    );
end FSM_1_SLAVE_TIMER;


architecture Behavioral of FSM_1_SLAVE_TIMER is
    signal count_aux : natural;
    signal fin_count : natural;
begin
    process(CLK, RST_N)
        --variable count_aux : natural;
        --variable fin_count : natural;
	begin
		if RST_N = '0' then -- Si entra un reset, mandamos a reposo la máquina de estados
			count_aux <= 0;
			DONE_TIMER <= '0';
		elsif rising_edge(CLK) then
		    DONE_TIMER <= '0';
			if START_TIMER = '1' then
				count_aux <= PARAM_TIMER;
			end if;
			if count_aux /= 0 then --Contamos de forma decreciente
				count_aux <= count_aux - 1;
				fin_count <= fin_count + 1;
		    else 
		      if PARAM_TIMER /= 0 then
		         if fin_count = PARAM_TIMER then
				    DONE_TIMER <= '1';
				    fin_count <= 0;
			     end if;
			  end if;
			end if;
			
		end if;
	end process;
    
    COUNT <= count_aux;
end Behavioral;
