library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use work.tipos_especiales.ALL;


entity SLAVE_INCHECK_tb is
end SLAVE_INCHECK_tb;

architecture tb of SLAVE_INCHECK_tb is
component FSM_INCHECK
    port (  CLK : in STD_LOGIC;
            RST_N           : in std_logic;
            START_INCHECK   : in std_logic;  -- Señal de inicio de la comparación
            PARAM_SEQ       : in SEQUENCE2_T; -- Secuencia aleatoria a adivinar por el jugador
 
            UP_BTN          : in std_logic;
            DOWN_BTN        : in std_logic;
            LEFT_BTN        : in std_logic;
            RIGHT_BTN       : in std_logic;
            --LED           : out std_logic_vector (3 downto 0); -- LEDS a ENCENDER según se vayan encendiendo los LEDS.
            DONE_INCHECK    : out std_logic_vector(1 downto 0); -- "00" si NOT DONE // "01" si WIN // "10" si GAME OVER
            INTENTOS        : out natural range 0 to 9;
            
            STATE           : out STATE_INCHECK_T);
   end component;
   
signal CLK             : std_logic  := '0';
signal RST_N           : std_logic;
signal START_INCHECK   : std_logic;  -- SeÃ±al de inicio de la comparaciÃ³n
signal PARAM_SEQ       : SEQUENCE2_T := ("00","01","10","11"); -- Secuencia aleatoria a adivinar por el jugador
signal UP_BTN          : std_logic := '0'; -- Entrada de botones pulsados. 
signal DOWN_BTN        : std_logic := '0';
signal LEFT_BTN        : std_logic := '0';
signal RIGHT_BTN       : std_logic := '0';

 --LED             : out std_logic_vector (3 downto 0); -- LEDS a ENCENDER segÃºn se vayan encendiendo los LEDS.
signal DONE_INCHECK    : std_logic_vector(1 downto 0); -- "00" si NOT DONE // "01" si WIN // "10" si GAME OVER
signal INTENTOS        : natural range 0 to 5;

signal STATE : STATE_INCHECK_T;

begin

tb : FSM_INCHECK port map (
CLK,
RST_N,
START_INCHECK,
PARAM_SEQ,
UP_BTN,
DOWN_BTN,
LEFT_BTN,
RIGHT_BTN,
DONE_INCHECK,
INTENTOS,
STATE);

CLK <= not CLK after 5ns;
process
begin

wait for 10ns;

START_INCHECK <= '1';
wait for 20ns;
START_INCHECK <= '0';

wait for 10ns;
wait;

end process;

process
begin
wait until STATE = S1;
wait for 20ns;
UP_BTN<='1';
wait for 10ns;
UP_BTN<='0';
wait for 5ns;

wait until STATE = S2;
wait for 20ns;
DOWN_BTN<='1';
wait for 10ns;
DOWN_BTN<='0';

wait until STATE = S3;
wait for 20ns;
LEFT_BTN<='1';
wait for 10ns;
LEFT_BTN<='0';

wait until STATE = S4;
wait for 20ns;
RIGHT_BTN<='1';
wait for 10ns;
RIGHT_BTN<='0';

wait for 10ns;
wait;
end process;

process
begin
wait for 300ns;
assert false
report "Simulacion finalizada"
severity failure;
end process;
end tb;
