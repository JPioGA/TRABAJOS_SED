library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.tipos_esp.ALL;

entity VISUALIZER_TOP is
  Port (
    CLK  : in std_logic;
    round      : in ROUND_T;
    seq        : in LED_T;
    tim        : in natural;
    selector   : in MESSAGE_T;
    segments   : out std_logic_vector(6 downto 0);
    anode      : out std_logic_vector(7 downto 0);
    leds       : out std_logic_vector(3 downto 0) 
   );
end VISUALIZER_TOP;

architecture Behavioral of VISUALIZER_TOP is

component NATURAL_DECODER
    port (
        value : in natural;
        segments_smaller : out std_logic_vector(6 downto 0);
        segments_larger : out std_logic_vector(6 downto 0)
  );
end component;

component LED_DECODER
    port(
        selector : in  natural;
        seq      : in  LED_T;
        leds     : out std_logic_vector(3 downto 0));
end component;

component DISPLAY_CONTROLLER
    port(
        selector           : in  MESSAGE_T;
        time_7seg_smaller  : in  std_logic_vector(6 downto 0);
        time_7seg_larger   : in  std_logic_vector(6 downto 0);
        round_7seg_smaller : in  std_logic_vector(6 downto 0);
        round_7seg_larger  : in  std_logic_vector(6 downto 0);
        CLK                : in std_logic;
        anode              : out std_logic_vector(7 downto 0);
        segments           : out std_logic_vector(6 downto 0));
end component;
    signal round_7seg_larger : std_logic_vector(6 downto 0);
    signal round_7seg_smaller : std_logic_vector(6 downto 0);
    signal time_7seg_larger : std_logic_vector(6 downto 0);
    signal time_7seg_smaller : std_logic_vector(6 downto 0);
begin
round_decod : NATURAL_DECODER port map(value => round, segments_smaller => round_7seg_smaller, segments_larger => round_7seg_larger); 
time_decod  : NATURAL_DECODER port map(value => tim, segments_smaller => time_7seg_smaller, segments_larger => time_7seg_larger);
led_decod   : LED_DECODER port map(seq => seq, leds => leds, selector => selector);
disp_contr    : DISPLAY_CONTROLLER  port map(
        selector => selector,
        time_7seg_smaller => time_7seg_smaller,
        time_7seg_larger => time_7seg_larger,
        round_7seg_smaller => round_7seg_smaller,
        round_7seg_larger => round_7seg_larger,
        CLK => CLK,
        anode => anode,
        segments => segments);

end Behavioral;
