library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.tipos_esp.ALL;

entity SIMON_DICE_TOP is
    generic(
        COLORS      : natural := 4
    );
    port (
         boton : in std_logic_vector (4 downto 0);
         CLK100MHZ :  in std_logic;
         CPU_RESETN : in std_logic;
         segment   : out std_logic_vector(6 downto 0);
         anode      : out std_logic_vector(7 downto 0);
         leds       : out std_logic_vector(COLORS-1 downto 0)
    );
end SIMON_DICE_TOP;

architecture structural of SIMON_DICE_TOP is
    component BOTON_TOP is
    port(
        Button_in	:in  std_logic_vector(4 downto 0);
        Button_out  :out std_logic_vector(4 downto 0);
        CLK		    :in  std_logic
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
            --LED_VALUE_top    : out LED_T;
            LIGHT_top        : out std_logic_vector(COLORS-1 downto 0);
            OUT_MESSAGE_top  : out MESSAGE_T;
            CUR_TIME_top     : out natural;
            ROUND_top        : out ROUND_T
        );
    end component;
component VISUALIZER_TOP
 Port (
    CLK        : in std_logic;
    round      : in natural range 0 to 99;
    --time_s       : in natural range 0 to 99;
    selector   : in natural range 0 to 4;
    segments   : out std_logic_vector(6 downto 0);
    anode      : out std_logic_vector(7 downto 0)
   );
   end component; 
   component CLOCK_CONVERTER
    port ( 
           RST_N : in STD_LOGIC;
           CLK_IN : in STD_LOGIC;
           CLK_OUT : out STD_LOGIC
    );
   end component;   

    signal boton_out_signal : std_logic_vector (4 downto 0);
    signal message_value_signal : MESSAGE_T;
    --signal time_value_signal : natural;
    signal round_value_signal : ROUND_T;
    signal clock_out_signal    : std_logic;
    
begin

    botones: BOTON_TOP 
        port map(
            CLK         => CLK100MHZ,
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
            LIGHT_top        => leds,
            -- Salidas ha visualizer
            --LED_VALUE_top    => led_value_signal,
            OUT_MESSAGE_top  => message_value_signal,
            --CUR_TIME_top     => time_value_signal,
            ROUND_top        => round_value_signal
       
        );
     visualizer: VISUALIZER_TOP
         port map(
            CLK       => CLK100MHZ,
            round     =>round_value_signal,
            --time_s   =>  time_value_signal, 
            selector  =>message_value_signal, 
            segments   =>segment,
            anode       =>   anode
         );
     converter:     CLOCK_CONVERTER
         port map(
             RST_N => CPU_RESETN,
             CLK_IN => CLK100MHZ,
             CLK_OUT =>clock_out_signal
         );
end structural;
