----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity COMPARATOR is
    port ( CLK  : in std_logic; -- Señal de reloj
           CE   : in std_logic; -- Señal de Chip Enable
           X    : in std_logic_vector (3 downto 0); -- Entrada 1 a comparar
           Y    : in std_logic_vector (3 downto 0); -- Entrada 1 a comparar
           EQ   : out std_logic -- Resultado de la comparación ('1' si iguales, '0' si diferentes)
    );
end COMPARATOR;

architecture Behavioral of COMPARATOR is

begin
    process (CE, CLK, X, Y)
	begin
		if (CE = '1') then -- Si se activa la comparación
			if(rising_edge(CLK)) then -- En cada flanco de subida se realiza la comparación
				if (X = Y) then
					EQ <= '1'; 
				elsif (X /= Y) then
					EQ <= '0'; 
				end if;
			end if;
		end if;
	end process;

end Behavioral;
