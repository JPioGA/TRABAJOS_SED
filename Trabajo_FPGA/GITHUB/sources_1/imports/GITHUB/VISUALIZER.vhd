library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VISUALIZER_TOP is
  Port (
    CLK        : in std_logic;
    round      : in natural range 0 to 99;
    time_s       : in natural range 0 to 99;
    selector   : in natural range 0 to 4;
    segments   : out std_logic_vector(6 downto 0);
    anode      : out std_logic_vector(7 downto 0)
   );
end VISUALIZER_TOP;

architecture Behavioral of VISUALIZER_TOP is

component NATURAL_DECODER
    port (
        value : in natural range 0 to 99;
        segments_smaller : out std_logic_vector(6 downto 0);
        segments_larger : out std_logic_vector(6 downto 0)
  );
end component;

component DISPLAY_CONTROLLER
    port(
        selector           : in  natural range 0 to 4;
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
round_decoder : NATURAL_DECODER port map(value => round, segments_smaller => round_7seg_smaller, segments_larger => round_7seg_larger); 
time_decoder  : NATURAL_DECODER port map(value => time_s, segments_smaller => time_7seg_smaller, segments_larger => time_7seg_larger);
disp_contr    : DISPLAY_CONTROLLER  port map(
        selector => selector,
        time_7seg_smaller => time_7seg_smaller,
        time_7seg_larger => time_7seg_larger,
        round_7seg_smaller => round_7seg_smaller,
        round_7seg_larger => round_7seg_larger,
        CLK => CLK,
        anode => anode,
        segments => segments);

end Behavioral;