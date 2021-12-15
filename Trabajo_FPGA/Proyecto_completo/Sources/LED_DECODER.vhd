library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity LED_DECODER is
  Port (
    selector : in natural;
    seq : in natural;
    leds : out std_logic_vector(3 downto 0)
   );
end LED_DECODER;

architecture Behavioral of LED_DECODER is

begin
    process(selector, seq)
    begin
    
        leds <= "0000";
        if(selector = 1) then
            case seq is
                when 0 => leds(0) <= '1';
                when 1 => leds(1) <= '1';
                when 2 => leds(2) <= '1';
                when 3 => leds(3) <= '1';
                when others => leds <= "0000";
            end case;
      end if;
            
    end process;
end Behavioral;
