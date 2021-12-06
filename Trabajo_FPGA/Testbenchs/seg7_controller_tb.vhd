----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.12.2021 11:38:12
-- Design Name: 
-- Module Name: seg7_controller_tb - Behavioral
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

entity seg7_controller_tb is
end seg7_controller_tb;

architecture Behavioral of seg7_controller_tb is
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
    signal selector_tb : natural;
    signal time_7seg_smaller_tb  : std_logic_vector(6 downto 0);
    signal time_7seg_larger_tb   : std_logic_vector(6 downto 0);
    signal round_7seg_smaller_tb : std_logic_vector(6 downto 0);
    signal round_7seg_larger_tb  : std_logic_vector(6 downto 0);
    signal CLK_tb                : std_logic := '0';
    signal anode_tb              : std_logic_vector(7 downto 0);
    signal segments_tb           : std_logic_vector(6 downto 0);
begin
    seg7_contr : seg7_controller port map(
        selector => selector_tb,
        time_7seg_smaller => time_7seg_smaller_tb,
        time_7seg_larger => time_7seg_larger_tb,
        round_7seg_smaller => round_7seg_smaller_tb,
        round_7seg_larger => round_7seg_larger_tb,
        CLK => CLK_tb,
        anode => anode_tb,
        segments => segments_tb
    );
    CLK_tb <= not clk_tb after 5 ns;
    process
    begin
        selector_tb <= 1;
        round_7seg_larger_tb <= "0101010";
        round_7seg_smaller_tb <= "1111111";
        time_7seg_larger_tb <= "0000000";
        time_7seg_smaller_tb <= "1001001";
        for i in 1 to 8 loop
            wait until CLK_tb = '0';
        end loop;
        assert false
            report "[SUCCESS]: simulation finished."
            severity failure;
    end process;
end Behavioral;
