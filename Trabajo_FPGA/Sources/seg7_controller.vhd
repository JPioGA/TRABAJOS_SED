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
begin
    
    if rising_edge(CLK) then
        anode <= "00000000";
        case selector is
            when 0 =>
                -- imprimir mensaje de inicio
            when 1 =>
                if anode_s = 7 or anode_s = 3 then
                    segments <= round_7seg_larger;
                    anode(3) <= '1';
                elsif anode_s = 6 or anode_s = 2 then
                    segments <= round_7seg_smaller;
                    anode(2) <= '1';
                elsif anode_s = 5 or anode_s = 1 then
                    segments <= time_7seg_larger;
                    anode(1) <= '1';
                else
                    segments <= time_7seg_smaller;
                    anode(0) <= '1';
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
