----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.12.2021 19:04:04
-- Design Name: 
-- Module Name: visualizer - Behavioral
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

entity visualizer is
  Port (
    CLK100MHZ  :in std_logic;
    CPU_RESETN : in std_logic;
    round      : in natural;
    seq        : in natural;
    time       : in natural;
    selector   : in natural;
    segments   : out std_logic_vector(6 downto 0);
    anode      : out std_logic_vector(7 downto 0);
    leds       : out std_logic_vector(3 downto 0) 
   );
end visualizer;

architecture Behavioral of visualizer is

component decoder_nat_7seg
    port (
        value : in natural range 0 to 99;
        segments_smaller : out std_logic_vector(6 downto 0);
        segments_larger : out std_logic_vector(6 downto 0)
  );
end component;

component decoder_nat_leds
    port(
        selector : in  natural;
        seq      : in  natural;
        leds     : out std_logic_vector(3 downto 0));
end component;

component seg7_controller
    port(
        selector           : in  natural;
        time_7seg_smaller  : in  std_logic_vector(6 downto 0);
        time_7seg_larger   : in  std_logic_vector(6 downto 0);
        round_7seg_smaller : in  std_logic_vector(6 downto 0);
        round_7seg_larger  : in  std_logic_vector(6 downto 0);
        CLK                : in std_logic;
        anode              : out std_logic_vector(7 downto 0);
        segments           : out std_logic_vector(6 downto 0));
end component;
    signal round_7seg_larger : std_logic_vector(6 downto 0);
    signal round_7seg_smaller : std_logic_vector(6 downto 0);
    signal time_7seg_larger : std_logic_vector(6 downto 0);
    signal time_7seg_smaller : std_logic_vector(6 downto 0);
begin
round_decoder : decoder_nat_7seg port map(value => round, segments_smaller => round_7seg_smaller, segments_larger => round_7seg_larger); 
time_decoder  : decoder_nat_7seg port map(value => time, segments_smaller => time_7seg_smaller, segments_larger => time_7seg_larger);
led_decoder   : decoder_nat_leds port map(seq => seq, leds => leds, selector => selector);
disp_contr    : seg7_controller  port map(
        selector => selector,
        time_7seg_smaller => time_7seg_smaller,
        time_7seg_larger => time_7seg_larger,
        round_7seg_smaller => round_7seg_smaller,
        round_7seg_larger => round_7seg_larger,
        CLK => CLK100MHZ,
        anode => anode,
        segments => segments);

end Behavioral;
