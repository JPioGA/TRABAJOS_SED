library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity CLOCK_CONVERTER is
    generic(
        VALUE : integer := 100 -- Valor a dividir la frecuencia de entrada
    );
    port ( 
           RST_N : in STD_LOGIC;
           CLK_IN : in STD_LOGIC;
           CLK_OUT : out STD_LOGIC
    );
end CLOCK_CONVERTER;

architecture Behavioral of CLOCK_CONVERTER is
    signal count: integer := VALUE;
    signal tmp : std_logic := '0';
begin
    process(CLK_IN, RST_N)
        begin
            if(RST_N='1') then
                count<=VALUE;
                tmp <= '0';
            elsif(CLK_IN'event and CLK_IN='1') then
                count <= count-1;
                if (count = 0) then
                    tmp <= NOT tmp;
                    count <= VALUE;
                end if;
            end if;
            CLK_OUT <= tmp;
    end process;
end Behavioral;
