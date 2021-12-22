library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity BOTON_DEBOUNCER is
	port ( 
			CLK	: in     std_logic;
			BTNC		: in     std_logic;
			BUTTON_PUSHED:out	 std_logic
		);
end BOTON_DEBOUNCER;

architecture structural of BOTON_DEBOUNCER is

    component debouncer
        port(
        CLK     : in  std_logic;
        BUTTON  : in  std_logic;
        DEB     : out std_logic
    );
    end component;
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
    
    signal DEB_OUT: std_logic;
    signal SYNC: std_logic;
    signal EDGED: std_logic;
    
begin
    antirrebotes: debouncer
        port map ( CLK => CLK,
                   BUTTON => BTNC,
                   DEB => DEB_OUT
                   );
    sincronizador:  synchrnzr
        port map (  CLK => CLK,
                    ASYNC_IN => DEB_OUT,
                    SYNC_OUT => SYNC);
    flanqueador:    edgedtctr
        port map (  CLK => CLK,
                    SYNC_IN=> SYNC,
                    EDGE => EDGED);
    BUTTON_PUSHED <= EDGED;

end architecture structural;