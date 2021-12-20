library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity BOTON_TOP is
    port(
        Button_in	:in  std_logic_vector(4 downto 0);
        Button_out  :out std_logic_vector(4 downto 0);
        CLK		    :in  std_logic
    );

end BOTON_TOP;

architecture structural of BOTON_TOP is
    component BOTON is
    port ( 
                CLK	: in     std_logic;
                BTNC		: in     std_logic;
                BUTTON_PUSHED:out	 std_logic
            );
    end component;
    
begin
    Boton_ok:		BOTON port map(CLK => CLK, BTNC => Button_in(0), BUTTON_PUSHED => Button_out(0));
    Boton_up:		BOTON port map(CLK => CLK, BTNC => Button_in(1), BUTTON_PUSHED => Button_out(1));
    Boton_down:		BOTON port map(CLK => CLK, BTNC => Button_in(2), BUTTON_PUSHED => Button_out(2));
    Boton_left:		BOTON port map(CLK => CLK, BTNC => Button_in(3), BUTTON_PUSHED => Button_out(3));
    Boton_right:	BOTON port map(CLK => CLK, BTNC => Button_in(4), BUTTON_PUSHED => Button_out(4));
    
end architecture structural;
