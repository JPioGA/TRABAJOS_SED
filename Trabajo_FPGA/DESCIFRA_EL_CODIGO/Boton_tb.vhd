library ieee;
use ieee.std_logic_1164.all;

entity button_tb is
end button_tb;

architecture tb of button_tb is
	component BOTON
	port ( 
			CLK	: in     std_logic;
			BTNC		: in     std_logic;
			BUTTON_PUSHED:out	 std_logic
		);
	end component;

	signal clk	: std_logic:='0';
	signal btn: std_logic;
	signal botonpulsado: std_logic;
	constant k  : time := 5ns;
	
begin
	uut: BOTON port map (CLK => clk, BTNC => btn, BUTTON_PUSHED => botonpulsado);
	
	clk<=not clk after k;
	
	process
	begin
		wait for 4*k;
		for i in 0 to 5 loop
			btn<='1';
			wait for 10*k;
			btn<='0';
			wait for 20*k;
		end loop;
        wait for 2*k;
        
		assert false
		  report "Simulacion finalizada"
		  severity failure;
	end process;
end tb;