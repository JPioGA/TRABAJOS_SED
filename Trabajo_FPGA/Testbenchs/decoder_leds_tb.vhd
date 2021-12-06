library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity decoder_nat_leds_tb is
end decoder_nat_leds_tb;

architecture Behavioral of decoder_nat_leds_tb is
    component decoder_nat_leds
        port(
            selector : in  natural;
            seq      : in  natural;
            leds     : out std_logic_vector(3 downto 0));
    end component;
    signal selector_tb : natural;
    signal seq_tb      : natural;
    signal leds_tb     : std_logic_vector(3 downto 0);
begin
    leds_sim : decoder_nat_leds port map(selector => selector_tb, seq => seq_tb, leds => leds_tb);
    process
    begin
            selector_tb <= 2;
            seq_tb <= 0;
        wait for 10 ns;
            seq_tb <= 1;
        wait for 10 ns;
            seq_tb <= 2;
        wait for 10 ns;
            seq_tb <= 3;
        wait for 10 ns;
            selector_tb <= 3;
        wait;
    end process;
end Behavioral;
