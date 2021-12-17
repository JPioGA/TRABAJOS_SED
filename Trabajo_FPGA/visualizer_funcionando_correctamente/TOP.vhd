library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP is
    port(
        CLK100MHZ          : in std_logic;
        TIMER        : in  std_logic_vector(6 downto 0);
        ROUND        : in  std_logic_vector(6 downto 0);
        SEL     : in  std_logic_vector(1 downto 0);
        segment     : out std_logic_vector(6 downto 0);
        anode        : out std_logic_vector(7 downto 0));
end TOP;

architecture Behavioral of TOP is
    component VISUALIZER_TOP 
        port(
                CLK        : in std_logic;
                round      : in natural range 0 to 99;
                time_s     : in natural range 0 to 99;
                selector   : in natural range 0 to 4;
                segments   : out std_logic_vector(6 downto 0);
                anode      : out std_logic_vector(7 downto 0)
               );
    end component;
    component INTERFACE
        port(
                timer        : in  std_logic_vector(6 downto 0);
                round        : in  std_logic_vector(6 downto 0);
                selector     : in  std_logic_vector(1 downto 0);
                timer_out    : out natural range 0 to 99;
                round_out    : out natural range 0 to 99;
                selector_out : out natural range 0 to 4
                );
    end component;
    
    signal time_signal : natural range 0 to 99;
    signal round_signal : natural range 0 to 99;
    signal selector_signal : natural range 0 to 4;
begin
    visual: VISUALIZER_TOP
        port map(
                CLK => CLK100MHZ,
                round => round_signal,
                time_s => time_signal,
                selector => selector_signal,
                segments => segment,
                anode => anode);
    inter: INTERFACE
        port map(
                timer => TIMER,
                round => ROUND,
                selector => SEL,
                timer_out => time_signal,
                round_out => round_signal,
                selector_out => selector_signal);
end Behavioral;