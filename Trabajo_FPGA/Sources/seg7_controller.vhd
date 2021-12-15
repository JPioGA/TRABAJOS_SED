library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity seg7_controller is
  Port (
    selector           : in  natural;
    time_7seg_smaller  : in  std_logic_vector(6 downto 0);
    time_7seg_larger   : in  std_logic_vector(6 downto 0);
    round_7seg_smaller : in  std_logic_vector(6 downto 0);
    round_7seg_larger  : in  std_logic_vector(6 downto 0);
    CLK                : in std_logic;
    anode              : out std_logic_vector(7 downto 0) := "00000000";
    segments           : out std_logic_vector(6 downto 0) := "1111111"
   );
end seg7_controller;

architecture Behavioral of seg7_controller is
signal anode_s : natural:= 0;
begin
process(CLK)
variable counter : natural := 100;
begin
    
    if rising_edge(CLK) then
        counter := counter - 1;
    end if;
    if selector'event then
        counter := 0;
    end if;
    if counter = 0 then
        counter := 100;
        anode <= "00000000";
        segments <= "1111111";
        case selector is
            when 1 => --start
                if anode_s = 0 then
                    segments <= "0100100";
                    anode(0) <= '1';
                elsif anode_s = 1 then
                    segments <= "1110000";
                    anode(1) <= '1';
                elsif anode_s = 2 then
                    segments <= "0001000";
                    anode(2) <= '1';
                elsif anode_s = 3 then
                    segments <= "1111010";
                    anode(3) <= '1';
                elsif anode_s = 4 then
                    segments <= "1110000";
                    anode(4) <= '1';
                end if;
            when 0 => --show sequence
                if anode_s = 7 or anode_s = 3 then
                    segments <= time_7seg_smaller;
                    anode(3) <= '1';
                elsif anode_s = 6 or anode_s = 2 then
                    segments <= time_7seg_larger;
                    anode(2) <= '1';
                elsif anode_s = 5 or anode_s = 1 then
                    segments <= round_7seg_smaller;
                    anode(1) <= '1';
                else
                    segments <= round_7seg_larger;
                    anode(0) <= '1';
                end if; 
            when 2 => --go
                if anode_s mod 2 = 0 then
                    segments <= "0000100";
                    anode(0) <= '1';
                else
                    segments <= "0000001";
                    anode(1) <= '1';
                end if;
            when 3 => --done
                if anode_s = 7 or anode_s = 3 then
                    segments <= "0110000";
                    anode(3) <= '1';
                elsif anode_s = 6 or anode_s = 2 then
                    segments <= "1101010";
                    anode(2) <= '1';
                elsif anode_s = 5 or anode_s = 1 then
                    segments <= "1000010";
                    anode(1) <= '1';
                else
                    segments <= "1111111";
                    anode(0) <= '1';
                end if;
            when 4 => -- gameover
                if anode_s = 0 then
                    segments <= "0000100";
                    anode(0) <= '1';
                elsif anode_s = 1 then
                    segments <= "0001000";
                    anode(1) <= '1';
                elsif anode_s = 2 then
                    segments <= "0001001";
                    anode(2) <= '1';
                elsif anode_s = 3 then
                    segments <= "0110000";
                    anode(3) <= '1';
                elsif anode_s = 4 then
                    segments <= "0000001";
                    anode(4) <= '1';
                elsif anode_s = 5 then
                    segments <= "1100011";
                    anode(5) <= '1';
                elsif anode_s = 6 then
                    segments <= "0110000";
                    anode(6) <= '1';
                elsif anode_s = 7 then
                    segments <= "1111010";
                    anode(7) <= '1';
                end if;
            when others =>
                
        end case;   
    
        if anode_s = 7 then
            anode_s <= 0;
        else
            anode_s <= anode_s +1;
        end if; 
    end if;
end process;
    
end Behavioral;
