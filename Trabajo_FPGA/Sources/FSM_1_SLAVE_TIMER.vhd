----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity FSM_1_SLAVE_TIMER is
    port (
        CLK         : in std_logic;
        RST_N       : in std_logic;
        START_TIMER : in std_logic;
        PARAM_TIMER : in natural;
        RST_COUNT   : in std_logic;
        DONE_TIMER  : out std_logic;
        COUNT       : out natural
    );
end FSM_1_SLAVE_TIMER;


architecture Behavioral of FSM_1_SLAVE_TIMER is

begin


end Behavioral;
