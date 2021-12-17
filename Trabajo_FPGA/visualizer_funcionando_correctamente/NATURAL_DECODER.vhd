library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity NATURAL_DECODER is
  port (
    value : in natural range 0 to 99;
    segments_smaller : out std_logic_vector(6 downto 0);
    segments_larger : out std_logic_vector(6 downto 0)
  );
end NATURAL_DECODER;

architecture rtl of NATURAL_DECODER is

  -- Binary-coded decimal representation of value
  subtype digit_type is natural range 0 to 9;
  type digits_type is array (1 downto 0) of digit_type;

begin

  -- Convert to BCD
  


 process(value)
    variable digits : digits_type;
  begin
    digits(1) := value / 10;
    digits(0) := value - ((value / 10) * 10);
    case digits(1) is

      when 0 => segments_larger <= "0000001";
      when 1 => segments_larger <= "1001111";
      when 2 => segments_larger <= "0010010";
      when 3 => segments_larger <= "0000110";
      when 4 => segments_larger <= "1001100";
      when 5 => segments_larger <= "0100100";
      when 6 => segments_larger <= "0100000";
      when 7 => segments_larger <= "0001111";
      when 8 => segments_larger <= "0000000";
      when 9 => segments_larger <= "0000100";
      when others => segments_larger <= "1111110";
      end case;
  
  case digits(0) is

      when 0 => segments_smaller <= "0000001";
      when 1 => segments_smaller <= "1001111";
      when 2 => segments_smaller <= "0010010";
      when 3 => segments_smaller <= "0000110";
      when 4 => segments_smaller <= "1001100";
      when 5 => segments_smaller <= "0100100";
      when 6 => segments_smaller <= "0100000";
      when 7 => segments_smaller <= "0001111";
      when 8 => segments_smaller <= "0000000";
      when 9 => segments_smaller <= "0000100";
      when others => segments_smaller <= "1111110";
      end case;
  end process;

end architecture;