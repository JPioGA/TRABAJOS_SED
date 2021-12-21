library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity SLAVE_TIMER_tb is
end SLAVE_TIMER_tb;

architecture tb of SLAVE_TIMER_tb is
component FSM_SLAVE_TIMER

   port (  CLK         : in std_logic;
            RST_N       : in std_logic;
            START_TIMER : in std_logic;
            DONE_TIMER  : out std_logic);

end component;
signal  CLK_tb		      :  std_logic:='0'; -- Entrada de RELOJ
signal	RSTN_tb	          :	 std_logic; -- Entrada de RESET
signal  START_tb          :  std_logic;
signal  DONE_tb           :  std_logic;

begin
uut : FSM_SLAVE_TIMER port map (CLK_tb, RSTN_tb, START_tb, PARAM_tb, DONE_tb );

CLK_tb<=not CLK_tb after 5ns;
process
begin
START_tb<='0';
		wait for 20ns;
		START_tb<=not START_tb;
		wait for 10ns;
		START_tb<='0';
		
		wait for 60ns; --Tiempo exclusivo para tb
		
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