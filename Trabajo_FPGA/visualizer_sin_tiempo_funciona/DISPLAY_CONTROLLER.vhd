library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DISPLAY_CONTROLLER is
  Port (
    selector           : in  natural range 0 to 4;
    round_7seg_smaller : in  std_logic_vector(6 downto 0);
    round_7seg_larger  : in  std_logic_vector(6 downto 0);
    CLK                : in std_logic;
    anode              : out std_logic_vector(7 downto 0) := "11111111";
    segments           : out std_logic_vector(6 downto 0) := "1111111"
   );
end DISPLAY_CONTROLLER;

architecture Behavioral of DISPLAY_CONTROLLER is
signal anode_s : natural:= 0;
begin
process(CLK)
variable counter : natural := 100000;
begin
    
    if rising_edge(CLK) then
        counter := counter - 1;
    end if;
    if counter = 0 then
        counter := 100000;
        segments <= "1111111";
        case selector is
            when 1 => --start
                if anode_s = 0 then
                    segments <= "0100100";
                    anode <= "01111111";
                elsif anode_s = 1 then
                    segments <= "1110000";
                    anode <= "10111111";
                elsif anode_s = 2 then
                    segments <= "0001000";
                    anode <= "11011111";
                elsif anode_s = 3 then
                    segments <= "1111010";
                    anode <= "11101111";
                elsif anode_s = 4 then
                    segments <= "1110000";
                    anode <= "11110111";
                end if;
            when 0 => --show sequence
                if anode_s mod 2 = 0 then
                    segments <= round_7seg_smaller;
                    anode <= "11111011";
                else
                    segments <= round_7seg_larger;
                    anode <= "11110111";
                end if; 
            when 2 => --go
                if anode_s mod 2 = 0 then
                    segments <= "0000100";
                    anode <= "01111111";
                else
                    segments <= "0000001";
                    anode <= "10111111";
                end if;
            when 4 => --done
                if anode_s = 7 or anode_s = 3 then
                    segments <= "0110000";
                    anode <= "11101111";
                elsif anode_s = 6 or anode_s = 2 then
                    segments <= "1101010";
                    anode <= "11011111";
                elsif anode_s = 5 or anode_s = 1 then
                    segments <= "0000001";
                    anode <= "10111111";
                else
                    segments <= "1000010";
                    anode <= "01111111";
                end if;
            when 3 => -- gameover
                if anode_s = 0 then
                    segments <= "0000100";
                    anode <= "01111111";
                elsif anode_s = 1 then
                    segments <= "0001000";
                    anode <= "10111111";
                elsif anode_s = 2 then
                    segments <= "0001001";
                    anode <= "11011111";
                elsif anode_s = 3 then
                    segments <= "0110000";
                    anode <= "11101111";
                elsif anode_s = 4 then
                    segments <= "0000001";
                    anode <= "11110111";
                elsif anode_s = 5 then
                    segments <= "1100011";
                    anode <= "11111011";
                elsif anode_s = 6 then
                    segments <= "0110000";
                    anode <= "11111101";
                elsif anode_s = 7 then
                    segments <= "1111010";
                    anode <= "11111110";
                end if;
            when others =>
                segments <= "1111111";
                anode <= "11111111";
        end case;   
    
        if anode_s = 7 then
            anode_s <= 0;
        else
            anode_s <= anode_s +1;
        end if; 
    end if;
end process;
    
end Behavioral;