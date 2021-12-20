library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity BOTON is
	port ( 
			CLK	: in     std_logic;
			BTNC		: in     std_logic;
			BUTTON_PUSHED:out	 std_logic
		);
end BOTON;

architecture structural of BOTON is

    component synchrnzr
        port (
            CLK 	 : in std_logic;
		    ASYNC_IN : in std_logic;
		    SYNC_OUT : out std_logic
		);
    end component;
    component edgedtctr
        port (
		   CLK 		: in std_logic;
		   SYNC_IN  : in std_logic;
		   EDGE		: out std_logic
		);
    end component;
          
    signal SYNC: std_logic;
    signal EDGED: std_logic;
    
begin
    sincronizador:  synchrnzr
        port map (  CLK => CLK,
                    ASYNC_IN => BTNC,
                    SYNC_OUT => SYNC);
    flanqueador:    edgedtctr
        port map (  CLK => CLK,
                    SYNC_IN=> SYNC,
                    EDGE => EDGED);
    BUTTON_PUSHED <= EDGED;

end architecture structural;