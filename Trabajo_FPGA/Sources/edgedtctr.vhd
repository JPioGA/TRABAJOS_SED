library ieee;
use ieee.std_logic_1164.all;

entity EDGEDTCTR is
	port (
		clk : in std_logic;
		sync_in : in std_logic;
		edge : out std_logic
	);
end EDGEDTCTR;

architecture behavioral of EDGEDTCTR is
	signal sreg : std_logic_vector(2 downto 0);
begin
	process (clk)
	begin
		if rising_edge(clk) then
			sreg <= sreg(1 downto 0) & sync_in;
		end if;
	end process;
	
	with sreg select
		edge <= '1' when "100",
				'0'when others;
end behavioral;