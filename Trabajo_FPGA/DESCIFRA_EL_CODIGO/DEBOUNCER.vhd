library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity debouncer is
    port(
        CLK     : in  std_logic;
        BUTTON  : in  std_logic;
        DEB     : out std_logic
    );
end debouncer;

architecture logic of debouncer is

    constant delay : integer := 200000; 
    signal count : integer := 0;
    signal btn_tmp : std_logic := '0';

    begin

    process(clk)
    begin
        if rising_edge(clk) then
            if (BUTTON /= btn_tmp) then
                btn_tmp <= BUTTON;
                count <= 0;
            elsif (count = delay) then
                DEB <= btn_tmp;
            else
                count <= count + 1;
            end if;
        end if;
    end process;
end logic;