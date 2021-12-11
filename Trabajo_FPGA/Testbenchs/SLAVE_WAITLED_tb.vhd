library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity SLAVE_WAITLED_tb is
end SLAVE_WAITLED_tb;

architecture tb of SLAVE_WAITLED_tb is
component FSM_1_SLAVE_WAITLED
port(
        CLK		      :	in 	std_logic; -- Entrada de RELOJ
		RST_N	      :	in 	std_logic; -- Entrada de RESET
        START_WAITLED : in std_logic;
        PARAM_WAITLED : in natural; -- Número de ciclos de reloj a esperar
        DONE_WAITLED  : out std_logic
    );

end component;
signal  CLK_tb		      :  std_logic:='0'; -- Entrada de RELOJ
signal	RSTN_tb	          :	 std_logic; -- Entrada de RESET
signal  START_tb          :  std_logic;
signal  PARAM_tb          :  natural:=4; -- Número de ciclos de reloj a esperar
signal  DONE_tb           :  std_logic;

begin
uut : FSM_1_SLAVE_WAITLED port map (CLK_tb, RSTN_tb, START_tb, PARAM_tb, DONE_tb );

CLK_tb<=not CLK_tb after 5ns;
process
begin
RSTN_tb<='0';
START_tb<='0';
		wait for 10ns;
		RSTN_tb<=not RSTN_tb;
		wait for 20ns;
		START_tb<=not START_tb;
		wait for 10ns;
		START_tb<='0';
		
		wait for 60ns;
		
		assert DONE_tb='1'
		report "Tiempo fallido"
		severity failure;
		
wait for 100ns;
RSTN_tb<='0';

		assert false
		report "Simulacion finalizada"
		severity failure;

wait;
		  
end process;


end tb;