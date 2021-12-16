library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP is
    port(
        CLK100MHZ          : in std_logic;
        TIME        : in  std_logic_vector(6 downto 0);
        ROUND        : in  std_logic_vector(6 downto 0);
        SEL     : in  std_logic_vector(1 downto 0);
        boton     : in  std_logic_vector(3 downto 0);
        segment     : out std_logic_vector(6 downto 0);
        anode        : out std_logic_vector(7 downto 0);
        leds         : out std_logic_vector(3 downto 0) );
end TOP;

architecture Behavioral of TOP is
    component visualizer 
        port(
                CLK        : in std_logic;
                round      : in natural;
                seq        : in natural;
                time_s       : in natural;
                selector   : in natural;
                segments   : out std_logic_vector(6 downto 0);
                anode      : out std_logic_vector(7 downto 0);
                leds       : out std_logic_vector(3 downto 0) 
               );
    end component;
    component interface
        port(
                timer        : in  std_logic_vector(6 downto 0);
                round        : in  std_logic_vector(6 downto 0);
                selector     : in  std_logic_vector(1 downto 0);
                sequence     : in  std_logic_vector(3 downto 0);
                timer_out    : out natural;
                round_out    : out natural;
                selector_out : out natural;
                sequence_out : out natural
                );
    end component;
    
    signal time_signal : natural;
    signal round_signal : natural;
    signal selector_signal : natural;
    signal sequence_signal : natural;
begin
    visual: visualizer
        port map(
                CLK => CLK100MHZ,
                round => round_signal,
                seq => sequence_signal,
                time_s => time_signal,
                selector => selector_signal,
                segments => segment,
                anode => anode,
                leds =>leds);
    inter: interface
        port map(
                timer => TIME,
                round => ROUND,
                selector => SEL,
                sequence => boton,
                timer_out => time_signal,
                round_out => round_signal,
                selector_out => selector_signal,
                sequence_out => sequence_signal);
end Behavioral;
