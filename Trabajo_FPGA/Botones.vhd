library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Button_UP is
	port ( 
			CLK100MHZ	: in     std_logic;
			BTNC_UP		: in     std_logic;
			CPU_RESETN	: in     std_logic;
			BUTTON_UP_PUSHED:out	 std_logic;
		);
end Button_UP;

architecture structural of Button_UP is

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
          
    signal SYNC_UP: std_logic;
    signal EDGED_UP: std_logic;
    
begin
sincronizador_up:  synchrnzr 	port map (CLK100MHZ, BTNC_UP, SYNC_UP); 
flanqueador_up:    edgedtctr 	port map (CLK100MHZ, SYNC_UP, EDGED_UP);
BUTTON_UP_PUSHED <= EDGED_UP;

end architecture structural;



entity Button_DOWN is
	port ( 
			CLK100MHZ	: in     std_logic;
			BTNC_DOWN	: in     std_logic;
			CPU_RESETN	: in     std_logic;
			BUTTON_DOWN_PUSHED:out	 std_logic;
		);
end Button_DOWN;

architecture structural of Button_DOWN is

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
          
    signal SYNC_DOWN:  std_logic;
    signal EDGED_DOWN: std_logic;
    
begin
sincronizador_down:  synchrnzr 	port map (CLK100MHZ, BTNC_DOWN, SYNC_DOWN); 
flanqueador_down:    edgedtctr 	port map (CLK100MHZ, SYNC_DOWN, EDGED_DOWN);
BUTTON_DOWN_PUSHED <= EDGED_DOWN;

end architecture structural;



entity Button_LEFT is
	port ( 
			CLK100MHZ	: in     std_logic;
			BTNC_LEFT	: in     std_logic;
			CPU_RESETN	: in     std_logic;
			BUTTON_LEFT_PUSHED:out	 std_logic;
		);
end Button_LEFT;

architecture structural of Button_LEFT is

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
          
    signal SYNC_LEFT:  std_logic;
    signal EDGED_LEFT: std_logic;
    
begin
sincronizador_left:  synchrnzr 	port map (CLK100MHZ, BTNC_LEFT, SYNC_LEFT); 
flanqueador_left:    edgedtctr 	port map (CLK100MHZ, SYNC_LEFT, EDGED_LEFT);
BUTTON_LEFT_PUSHED <= EDGED_LEFT;

end architecture structural;



entity Button_RIGHT is
	port ( 
			CLK100MHZ	: in     std_logic;
			BTNC_RIGHT	: in     std_logic;
			CPU_RESETN	: in     std_logic;
			BUTTON_RIGHT_PUSHED:out	 std_logic;
		);
end Button_RIGHT;

architecture structural of Button_RIGHT is

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
          
    signal SYNC_RIGHT: std_logic;
    signal EDGED_RIGHT: std_logic;
    
begin
sincronizador_right:  synchrnzr 	port map (CLK100MHZ, BTNC_RIGHT, SYNC_RIGHT); 
flanqueador_right:    edgedtctr 	port map (CLK100MHZ, SYNC_RIGHT, EDGED_RIGHT);
BUTTON_RIGHT_PUSHED <= EDGED_RIGHT;

end architecture structural;