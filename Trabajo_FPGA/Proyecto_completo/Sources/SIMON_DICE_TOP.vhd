library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.tipos_esp.ALL;

entity SIMON_DICE_TOP is
    port (
         boton : in std_logic_vector (4 downto 0);
         CLK100MHZ :  in std_logic;
         CPU_RESETN : in std_logic;
         segment   : out std_logic_vector(6 downto 0);
         anode      : out std_logic_vector(7 downto 0);
         leds       : out std_logic_vector(3 downto 0) 
    );
end SIMON_DICE_TOP;

architecture structural of SIMON_DICE_TOP is
    component BOTON_TOP is
    port(
        Button_in	:in  std_logic_vector(4 downto 0);
        Button_out  :out std_logic_vector(4 downto 0);
        CLK		    :in  std_logic;
        RST_N		:in  std_logic
    );
    end component;
    
    component FSM_1_TOP is
        port(
            CLK              : in  std_logic;
            RST_N            : in  std_logic;
            -- Entradas botones
            OK_BUTTON_top    : in std_logic;
            UP_BUTTON_top    : in std_logic;
            DOWN_BUTTON_top  : in std_logic;
            RIGHT_BUTTON_top : in std_logic;
            LEFT_BUTTON_top  : in std_logic;
            -- Salidas ha visualizer
            LED_VALUE_top    : out natural;
            OUT_MESSAGE_top  : out natural;
            CUR_TIME_top     : out natural;
            ROUND_top        : out natural
        );
    end component;
    
    component VISUALIZER_TOP is
        port (
            CLK  : in std_logic;
            round      : in natural;
            seq        : in natural;
            tim       : in natural;
            selector   : in natural;
            segments   : out std_logic_vector(6 downto 0);
            anode      : out std_logic_vector(7 downto 0);
            leds       : out std_logic_vector(3 downto 0) 
        );
    
    end component;

    signal boton_out_signal : std_logic_vector (4 downto 0);
    signal led_value_signal : LED_T;
    signal message_value_signal : MESSAGE_T;
    signal time_value_signal : natural;
    signal round_value_signal : natural;
    
begin

    botones: BOTON_TOP 
        port map(
            CLK => CLK100MHZ,
            RST_N => CPU_RESETN,
            Button_in	=> boton,
            Button_out  => boton_out_signal
        );
    fsm: FSM_1_TOP
        port map(
            CLK => CLK100MHZ,
            RST_N => CPU_RESETN,
            -- Entradas botones
            OK_BUTTON_top    => boton_out_signal(0),
            UP_BUTTON_top    => boton_out_signal(1),
            DOWN_BUTTON_top  => boton_out_signal(4),
            RIGHT_BUTTON_top => boton_out_signal(3),
            LEFT_BUTTON_top  => boton_out_signal(2),
            -- Salidas ha visualizer
            LED_VALUE_top    => led_value_signal,
            OUT_MESSAGE_top  => message_value_signal,
            CUR_TIME_top     => time_value_signal,
            ROUND_top        => round_value_signal
        );
     visualizer: VISUALIZER_TOP
        port map(
            CLK => CLK100MHZ,
            round      => round_value_signal,
            seq        => led_value_signal,
            tim        => time_value_signal,
            selector   => message_value_signal,
            segments   => segment,
            anode      => anode,
            leds       => leds
        );
end structural;
