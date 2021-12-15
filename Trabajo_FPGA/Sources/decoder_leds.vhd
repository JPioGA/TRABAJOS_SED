----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.12.2021 19:31:34
-- Design Name: 
-- Module Name: decoder_leds - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decoder_nat_leds is
  Port (
    selector : in natural;
    seq : in natural;
    leds : out std_logic_vector(3 downto 0)
   );
end decoder_nat_leds;

architecture Behavioral of decoder_nat_leds is

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
