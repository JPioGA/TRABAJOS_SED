----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.tipos_esp.ALL;

entity MUX_LEDS is
    port (
        SELECTOR : in std_logic;
        LEDS_SHOWSEQ : in std_logic_vector(3 downto 0);
        LEDS_INCHECK : in std_logic_vector(3 downto 0);
        OUTPUT_MUX       : out std_logic_vector(3 downto 0)
    );
end MUX_LEDS;

architecture behavioral of MUX_LEDS is
signal output_aux : std_logic_vector(3 downto 0);
begin
    OUTPUT_MUX <= output_aux;
    process(LEDS_SHOWSEQ, LEDS_INCHECK, SELECTOR)
    begin
        if SELECTOR = '0' then
            output_aux <= LEDS_SHOWSEQ;
        elsif SELECTOR = '1' then
            output_aux <= LEDS_INCHECK;
        else
            output_aux <= (others => 'Z');
        end if;
     end process;

end behavioral;
