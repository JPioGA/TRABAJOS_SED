library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use work.tipos_especiales.ALL;


entity SLAVE_INCHECK_tb is
end SLAVE_INCHECK_tb;

architecture tb of SLAVE_INCHECK_tb is
component FSM_SLAVE_INCHECK
   port (  CLK             : in std_logic;
            RST_N           : in std_logic;
            START_INCHECK   : in std_logic;  -- SeÃ±al de inicio de la comparaciÃ³n
            PARAM_SEQ       : in SEQUENCE_T; -- Secuencia aleatoria a adivinar por el jugador
            BTN             : in std_logic_vector (3 downto 0); -- Entrada de botones pulsados. 
            --LED             : out std_logic_vector (3 downto 0); -- LEDS a ENCENDER segÃºn se vayan encendiendo los LEDS.
            DONE_INCHECK    : out std_logic_vector(1 downto 0); -- "00" si NOT DONE // "01" si WIN // "10" si GAME OVER
            INTENTOS        : out natural range 0 to 10;
            
            STATE : out STATE_SLAVE_T
            );
   end component;
   
signal CLK             : std_logic  := '0';
signal RST_N           : std_logic;
signal START_INCHECK   : std_logic;  -- SeÃ±al de inicio de la comparaciÃ³n
signal PARAM_SEQ       : SEQUENCE_T := ("0001","0010","0100","1000"); -- Secuencia aleatoria a adivinar por el jugador
signal BTN             : std_logic_vector (3 downto 0); -- Entrada de botones pulsados. 
            --LED             : out std_logic_vector (3 downto 0); -- LEDS a ENCENDER segÃºn se vayan encendiendo los LEDS.
signal DONE_INCHECK    : std_logic_vector(1 downto 0); -- "00" si NOT DONE // "01" si WIN // "10" si GAME OVER
signal INTENTOS        : natural range 0 to 10;
signal STATE : STATE_SLAVE_T;

begin

tb : FSM_SLAVE_INCHECK port map (
CLK,
RST_N,
START_INCHECK,
PARAM_SEQ,
BTN,
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
assert STATE = S1
report "Inicio fallido"
severity failure;

wait;

end process;

process
begin
wait until STATE = S1;
wait for 20ns;
BTN<="0001";
wait for 5ns;
assert STATE = S2
report "Pulsacion fallida"
severity failure;
wait for 5ns;
BTN<="0000";
wait for 5ns;
assert STATE = S1
report "Pulsacion fallida"
severity failure;
wait until STATE = S1;
wait for 20ns;
BTN<="0010";
wait for 10ns;
BTN<="0000";
wait until STATE = S1;
wait for 20ns;
BTN<="0100";
wait for 10ns;
BTN<="0000";
wait until STATE = S1;
wait for 20ns;
BTN<="1000";
wait for 10ns;
assert STATE = S3
report "Secuencia incorrecta"
severity failure;
BTN<="0000";

wait for 10ns;
assert STATE = S_STBY
report "Simulacion incorrecta"
severity failure;
wait;
end process;

process
begin
wait for 200ns;
assert false
report "Simulacion finalizada"
severity failure;
end process;
end tb;
