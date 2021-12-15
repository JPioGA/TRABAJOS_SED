library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity BOTON_TOP is
    port(
        Button_in	:in  std_logic_vector(4 downto 0);
        Button_out  :out std_logic_vector(4 downto 0);
        CLK		    :in  std_logic;
        RST_N		:in  std_logic
    );

end BOTON_TOP;

architecture structural of BOTON_TOP is
    component BOTON is
    port ( 
                CLK100MHZ	: in     std_logic;
                BTNC		: in     std_logic;
                CPU_RESETN	: in     std_logic;
                BUTTON_PUSHED:out	 std_logic
            );
    end component;
    
begin
    Boton_ok:		BOTON port map(CLK, Button_in(0), RST_N, Button_out(0));
    Boton_up:		BOTON port map(CLK, Button_in(1), RST_N, Button_out(1));
    Boton_down:		BOTON port map(CLK, Button_in(2), RST_N, Button_out(2));
    Boton_left:		BOTON port map(CLK, Button_in(3), RST_N, Button_out(3));
    Boton_right:	BOTON port map(CLK, Button_in(4), RST_N, Button_out(4));
    
end architecture structural;
