library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.tipos_esp.ALL;

entity FSM_1_SLAVE_INCHECK_TOP is
    port (
        CLK                     : in STD_LOGIC;
        RST_N                   : in STD_LOGIC;
        UP_BUTTON               : in std_logic;
        DOWN_BUTTON             : in std_logic;
        RIGHT_BUTTON            : in std_logic;
        LEFT_BUTTON             : in std_logic;
        BUTTON_PUSHED           : out BUTTON_T;
        LED_VALUE               : out LED_T; --LED a encender
        STATE_INCHECK           : out STATE_INCHECK_T;

        
        -- MASTER-SLAVE INCHECK interfece
        START_INCHECK           : in std_logic;
        PARAM_INCHECK_size      : in natural; -- SIZE. Tamaño de la secuencia actual
        PARAM_INCHECK_seq       : in natural_vector; -- SEQ. Secuencia actual
        DONE_INCHECK            : out natural -- 0: none; 1: NO OK; 2: name
    );
end FSM_1_SLAVE_INCHECK_TOP;

architecture Behavioral of FSM_1_SLAVE_INCHECK_TOP is
    component FSM_1_SLAVE_INCHECK
        port(
            CLK                     : in STD_LOGIC;
            RST_N                   : in STD_LOGIC;
            UP_BUTTON               : in std_logic;
            DOWN_BUTTON             : in std_logic;
            RIGHT_BUTTON            : in std_logic;
            LEFT_BUTTON             : in std_logic;
            BUTTON_PUSHED_INCHECK   : out BUTTON_T;
            LED_VALUE               : out LED_T; --LED a encender
            STATE_INCHECK           : out STATE_INCHECK_T;
            
            -- MASTER-SLAVE INCHECK interfece
            START_INCHECK           : in std_logic;
            PARAM_INCHECK_size      : in natural; -- SIZE. Tamaño de la secuencia actual
            PARAM_INCHECK_seq       : in natural_vector; -- SEQ. Secuencia actual
            DONE_INCHECK            : out natural; -- 0: none; 1: NO OK; 2: name
            
            -- SLAVE SHOWSEQ-SLAVE WAITLED interface
            START_WAITLED   : out std_logic;
            PARAM_WAITLED   : out natural; -- NÃºmero de ciclos de reloj a esperar
            DONE_WAITLED    : in std_logic
        );
    end component;
    
    component FSM_1_SLAVE_WAITLED
        port(
            CLK		      :	in 	std_logic; -- Entrada de RELOJ
            RST_N	      :	in 	std_logic; -- Entrada de RESET
            START_WAITLED : in std_logic;
            PARAM_WAITLED : in natural; -- NÃºmero de ciclos de reloj a esperar
            DONE_WAITLED  : out std_logic
        );
    end component;
    
    signal start_wait : std_logic;
    signal done_wait  : std_logic;
    signal param_wait : natural;
begin
    instance_incheck: FSM_1_SLAVE_INCHECK port map(
        CLK                     => CLK,
        RST_N                   => RST_N,
        UP_BUTTON               => UP_BUTTON,
        DOWN_BUTTON             => DOWN_BUTTON,
        RIGHT_BUTTON            => RIGHT_BUTTON,
        LEFT_BUTTON             => LEFT_BUTTON,
        BUTTON_PUSHED_INCHECK   => BUTTON_PUSHED,
        LED_VALUE               => LED_VALUE,
        STATE_INCHECK           => STATE_INCHECK,
        -- MASTER-SLAVE INCHECK interfece
        START_INCHECK           => START_INCHECK,
        PARAM_INCHECK_size      => PARAM_INCHECK_size,
        PARAM_INCHECK_seq       => PARAM_INCHECK_seq,
        DONE_INCHECK            => DONE_INCHECK,
        -- SLAVE SHOWSEQ-SLAVE WAITLED interface
        START_WAITLED           => start_wait,
        PARAM_WAITLED           => param_wait,
        DONE_WAITLED            => done_wait
    );
    
    instance_waitled: FSM_1_SLAVE_WAITLED port map(
        CLK             => CLK,
        RST_N           => RST_N,
        START_WAITLED   => start_wait,
        PARAM_WAITLED   => param_wait,
        DONE_WAITLED    => done_wait
    );
end Behavioral;