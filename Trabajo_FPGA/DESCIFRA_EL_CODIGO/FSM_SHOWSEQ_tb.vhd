

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.tipos_especiales.all;

entity FSM_SHOWSEQ_tb is
end FSM_SHOWSEQ_tb;

architecture Behavioral of FSM_SHOWSEQ_tb is
component FSM_SHOWSEQ
port (
       CLK         : in std_logic;
       RST_N       : in std_logic;
       PARAM_SEQ   : in SEQUENCE2_T; -- Secuencia aleatoria a adivinar por el jugador
      
       START_TIMER : out std_logic;
       DONE_TIMER  : in std_logic; 
             
       START_SHOWSEQ : in std_logic;      
       DONE_SHOWSEQ  : out std_logic;
       
       LEDS        : out std_logic_vector(3 downto 0);
       STATE       : out STATE_SHOWSEQ_T --Necesario añadir esta salida en el diseño y actualizar con STATE <= cur_state
);
end component;

signal    CLK         : std_logic := '0';
signal    RST_N       : std_logic;
signal    PARAM_SEQ   : SEQUENCE2_T := ("00", "01", "10", "11"); -- Secuencia aleatoria a adivinar por el jugador
      
signal    START_TIMER : std_logic;
signal    DONE_TIMER  : std_logic; 
             
signal    START_SHOWSEQ : std_logic;      
signal    DONE_SHOWSEQ  : std_logic;
       
signal    LEDS        : std_logic_vector(3 downto 0);
signal    STATE       : STATE_SHOWSEQ_T;

begin

tb: FSM_SHOWSEQ port map(
CLK,
RST_N,
PARAM_SEQ,
START_TIMER,
DONE_TIMER,
START_SHOWSEQ,
DONE_SHOWSEQ,
LEDS,
STATE
);

CLK <= not CLK after 5ns;

process
begin
wait for 20ns;
START_SHOWSEQ <= '1';
wait for 10ns;
assert STATE = S0
report "Inicio fallido"
severity failure;
wait for 5ns;
START_SHOWSEQ <= '0';
wait;
end process;

process
begin
wait until STATE = S1;
wait for 30ns;
DONE_TIMER <= '1';
wait for 5ns;
DONE_TIMER <= '0';

wait for 10ns;
assert STATE = S0
report "Timer incorrecto"
severity failure;

wait until STATE = S1;
wait for 30ns;
DONE_TIMER <= '1';
wait for 5ns;
DONE_TIMER <= '0';

wait until STATE = S1;
wait for 30ns;
DONE_TIMER <= '1';
wait for 5ns;
DONE_TIMER <= '0';

wait until STATE = S1;
wait for 30ns;
DONE_TIMER <= '1';
wait for 5ns;
DONE_TIMER <= '0';

wait for 10ns;
assert STATE = S2
report "Leds fallidos"
severity failure;
end process;

process
begin
wait for 300ns;
assert false
report "Simulacion finalizada"
severity failure;
end process;
end Behavioral;
