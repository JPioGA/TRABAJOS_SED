

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity interface is
  Port ( 
     timer        : in  std_logic_vector(6 downto 0);
     round        : in  std_logic_vector(6 downto 0);
     selector     : in  std_logic_vector(1 downto 0);
     timer_out    : out natural range 0 to 99;
     round_out    : out natural range 0 to 99;
     selector_out : out natural range 0 to 4
  );
end interface;

architecture Behavioral of interface is

begin

    timer_out <= to_integer(unsigned(timer));
    round_out <= to_integer(unsigned(round));
    selector_out <= to_integer(unsigned(selector));
    
end Behavioral;