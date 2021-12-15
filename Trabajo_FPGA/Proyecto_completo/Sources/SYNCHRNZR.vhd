library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SYNCHRNZR is
    Port ( clk : in STD_LOGIC;
           async_in : in STD_LOGIC;
           sync_out : out STD_LOGIC);
end SYNCHRNZR;

architecture Behavioral of SYNCHRNZR is
    signal sreg : std_logic_vector(1 downto 0);
begin
    process (CLK)
    begin
        if rising_edge(CLK) then
            sync_out <= sreg(1);
            sreg <= sreg(0) & async_in;
        end if;
    end process;
end Behavioral;