----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2021 19:27:50
-- Design Name: 
-- Module Name: interface - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity interface is
  Port ( 
     timer        : in  std_logic_vector(6 downto 0);
     round        : in  std_logic_vector(6 downto 0);
     selector     : in  std_logic_vector(1 downto 0);
     sequence     : in  std_logic_vector(3 downto 0);
     timer_out    : out natural;
     round_out    : out natural;
     selector_out : out natural;
     sequence_out : out natural
  );
end interface;

architecture Behavioral of interface is

begin

    timer_out <= to_integer(unsigned(timer));
    round_out <= to_integer(unsigned(round));
    selector_out <= to_integer(unsigned(selector));
    sequence_out <= to_integer(unsigned(sequence));
    
end Behavioral;
