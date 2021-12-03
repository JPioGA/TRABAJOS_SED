
library ieee;
use ieee.std_logic_1164.all;

entity button_tb is
end button_tb;

architecture tb of button_tb is
	component Button_UP
	port ( 
			CLK100MHZ	: in     std_logic;
			BTNC_UP		: in     std_logic;
			CPU_RESETN	: in     std_logic;
			BUTTON_UP_PUSHED:out	 std_logic;
		);
	end component;

	signal reset: std_logic;
	signal clk	: std_logic:='0';
	signal boton: std_logic;
	signal botonpulsado: std_logic;
	constant k  : time := 5ns;
	
begin
	uut: Button_UP port map (clk, boton, reset, botonpulsado);
	
	clk<=not clk after k;
	
	process
	begin
		reset<='0';
		wait for k;
		reset<=not reset;
		
		for i in 0 to 5 loop
			boton<='1';
			wait for 2*k;
			boton<='0';
			wait for 4*k;
		end loop;
		reset<='0';
        wait for 4*k;
        
		assert false
		  report "Simulacion finalizada"
		  severity failure;
	end process;
end tb;