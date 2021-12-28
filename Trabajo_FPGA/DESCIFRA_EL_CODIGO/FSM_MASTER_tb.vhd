library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use work.tipos_especiales.ALL;

entity FSM_MASTER_tb is
end entity;

architecture tb of FSM_MASTER_tb is

	component FSM_MASTER  port (  
	    CLK : in std_logic;
        RST_N : in std_logic;
        OK_BUTTON   : in std_logic;
        OUT_MESSAGE : out std_logic_vector(2 downto 0); -- "000" si nada // "001" si START // "010" si GO // "011" si GAME OVER // "100" si WIN
            
        -- Interfez entre MASTER y TIMER
        START_TIMER : out std_logic;
        DONE_TIMER  : in std_logic;
            
        -- Interfaz entre MASTER y LFSR
        RAND_SEQ    : in SEQUENCE2_T;
        DONE_LFSR   : in std_logic;
            
        -- Interfaz entre MASTER e INCHECK
        START_INCHECK : out std_logic;
        PARAM_SEQ_incheck     : out SEQUENCE2_T;
        DONE_INCHECK  : in std_logic_vector(1 downto 0); -- "00" si NOT DONE // "01" si WIN // "10" si GAME OVER
       
        START_SHOWSEQ : out std_logic;
        PARAM_SEQ_showseq : out SEQUENCE2_T;
        DONE_SHOWSEQ : in std_logic;
        STATE : out STATE_MASTER_T --Necesario añadir esta salida en el diseño y actualizar con STATE <= cur_state
        );
	end component;

signal  CLK         : std_logic := '0';
signal  RST_N       : std_logic;
signal  OK_BUTTON   : std_logic;
signal  OUT_MESSAGE : std_logic_vector(2 downto 0); -- "000" si nada // "001" si START // "010" si GO // "011" si GAME OVER // "100" si WIN
            
        -- Interfez entre MASTER y TIMER
signal  START_TIMER : std_logic;
signal  DONE_TIMER  : std_logic;
            
        -- Interfaz entre MASTER y LFSR
signal  RAND_SEQ    : SEQUENCE2_T;
signal  DONE_LFSR   : std_logic;
            
        -- Interfaz entre MASTER e INCHECK
signal  START_INCHECK : std_logic;
signal  PARAM_SEQ_incheck     : SEQUENCE2_T;
signal  DONE_INCHECK  : std_logic_vector(1 downto 0);
signal  START_SHOWSEQ : std_logic;
signal  PARAM_SEQ_showseq     : SEQUENCE2_T;
signal  DONE_SHOWSEQ  : std_logic;
signal  STATE		  : STATE_MASTER_T;

begin

tb : FSM_MASTER port map (
CLK => CLK,
RST_N => RST_N,
OK_BUTTON => OK_BUTTON,
OUT_MESSAGE => OUT_MESSAGE,
START_TIMER => START_TIMER,
DONE_TIMER => DONE_TIMER,
RAND_SEQ => RAND_SEQ,
DONE_LFSR => DONE_LFSR,
START_INCHECK => START_INCHECK,
PARAM_SEQ_incheck => PARAM_SEQ_incheck,
DONE_INCHECK => DONE_INCHECK,
START_SHOWSEQ => START_SHOWSEQ,
PARAM_SEQ_showseq => PARAM_SEQ_showseq,
DONE_SHOWSEQ => DONE_SHOWSEQ,
STATE => STATE);

CLK <= not CLK after 5ns;

process
begin

wait for 10ns;

OK_BUTTON <= '1';
wait for 10ns;
OK_BUTTON <= '0';

wait;

end process;

process
begin
wait for 10ns;

if STATE = S0 then

wait for 20ns;
DONE_LFSR <= '1';



elsif STATE = S1_WT then

DONE_LFSR <= '0';
wait for 40ns;
DONE_TIMER <= '1';
wait for 10ns;
DONE_TIMER <= '0';


elsif STATE = S2_WT then
wait for 50ns;
DONE_INCHECK <= "01";

elsif STATE = S3_WT then  --Para comprobar el fallo se pasa a S4_WT

wait for 50ns;
DONE_TIMER <= '1';
wait for 10ns;
DONE_TIMER <= '0';

elsif STATE = S5_WT then

wait for 50ns;
DONE_SHOWSEQ <= '1';
wait for 10ns;
DONE_SHOWSEQ <= '0';

end if;

end process;

process
begin
wait until STATE = S0;
if DONE_LFSR = '1' then
wait for 5ns;
assert STATE = S1
report "LFSR fallido"
severity failure;
end if;
end process;

process
begin
wait until DONE_INCHECK = "01";  --Para comprobar el fallo se pasa a S4 y DONE_INCHECK = "10"
wait for 20ns;
assert STATE = S3_WT
report "INCHECK fallido"
severity failure;
end process;

process
begin
wait for 400ns;
assert false
report "Simulacion finalizada"
severity failure;
end process;

end;