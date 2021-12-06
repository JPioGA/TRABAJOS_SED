library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity Button_top is
port(
Button_in		:in  std_logic_vector(3 to 0);
Button_out		:out std_logic_vector(3 to 0);
CLK100MHZ		:in  std_logic;
CPU_RESETN		:in  std_logic;
);

end Button_top;

architecture structural of Button_top is
component Button is
port ( 
			CLK100MHZ	: in     std_logic;
			BTNC		: in     std_logic;
			CPU_RESETN	: in     std_logic;
			BUTTON_PUSHED:out	 std_logic;
		);
end component;

begin
Boton_up:		Button port map(CLK100MHZ, Button_in[0], CPU_RESETN, Button_out[0]);
Boton_down:		Button port map(CLK100MHZ, Button_in[1], CPU_RESETN, Button_out[1]);
Boton_left:		Button port map(CLK100MHZ, Button_in[2], CPU_RESETN, Button_out[2]);
Boton_right:	Button port map(CLK100MHZ, Button_in[3], CPU_RESETN, Button_out[3]);

end architecture structural;






