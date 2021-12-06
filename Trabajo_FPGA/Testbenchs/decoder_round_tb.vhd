library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder_nat_7seg_tb is
end decoder_nat_7seg_tb;

architecture sim of decoder_nat_7seg_tb is
  component decoder_nat_7seg
    port(
        value : in natural range 0 to 99;
        segments_smaller : out std_logic_vector(6 downto 0);
        segments_larger : out std_logic_vector(6 downto 0));
  end component;
  signal value_tb : natural range 0 to 99;
  signal segments_smaller_tb : std_logic_vector(6 downto 0);
  signal segments_larger_tb : std_logic_vector(6 downto 0);

begin


  -- Device under test
  DUT : decoder_nat_7seg port map (
    value => value_tb,
    segments_smaller => segments_smaller_tb,
    segments_larger => segments_larger_tb
  );

  process
  begin

    loop

      wait for 1 sec;

      if value_tb = 99 then
        value_tb <= 0;
      else
        value_tb <= value_tb + 1;
      end if;

    end loop;
  end process;

end architecture;