library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.tipos_esp.ALL;

entity SLAVE_INCHECK_tb is
end SLAVE_INCHECK_tb;

architecture tb of SLAVE_INCHECK_tb is

component FSM_1_SLAVE_INCHECK
    port (
        CLK                     : in STD_LOGIC;
        RST_N                   : in STD_LOGIC;
        UP_BUTTON               : in std_logic;
        DOWN_BUTTON             : in std_logic;
        RIGHT_BUTTON            : in std_logic;
        LEFT_BUTTON             : in std_logic;
        BUTTON_PUSHED           : out natural; 
        LED_VALUE               : out natural; --LED a bit
        STATE_INCHECK           : out STATE_INCHECK_T;
        
        -- MASTER-SLAVE SHOWSEQ interface
        START_INCHECK           : in std_logic;
        PARAM_INCHECK_size      : in natural; -- SIZE. TamaÃ±o de la secuencia actual
        PARAM_INCHECK_seq       : in natural_vector; -- SEQ. Secuencia actual
        DONE_INCHECK            : out natural; -- 0: none; 1: NO OK; 2: name
        
        -- SLAVE SHOWSEQ-SLAVE WAITLED interface
        START_WAITLED   : out std_logic;
        PARAM_WAITLED   : out natural; -- Número de ciclos de reloj a esperar
        DONE_WAITLED    : in std_logic
        );
end component;
signal  CLK_tb                  :  STD_LOGIC:='0';
signal  RSTN_tb                 :  STD_LOGIC;
signal  UP_BUTTON               :  std_logic;
signal  DOWN_BUTTON             :  std_logic;
signal  RIGHT_BUTTON            :  std_logic;
signal  LEFT_BUTTON             :  std_logic;
signal  BUTTON_PUSHED_tb        :  natural;
signal  LED_tb                  :  natural; --LED a encender
signal  STATE_tb                :  STATE_INCHECK_T;
signal  START_INCHECK_tb        :  std_logic;
signal  SEQ_tb                  :  natural_vector:=(1,4,2,3,others=>0);
signal  SIZE_tb                 :  natural:=3;
signal  DONE_INCHECK_tb         :  natural;
signal  START_WAIT_tb			:  std_logic;
signal  WAITLED_tb				:  natural;
signal  DONE_WAIT_tb			:  std_logic:='0';

begin
uut : FSM_1_SLAVE_INCHECK port map (CLK_tb, RSTN_tb, UP_BUTTON, DOWN_BUTTON, RIGHT_BUTTON, LEFT_BUTTON, BUTTON_PUSHED_tb, LED_tb,STATE_tb, START_INCHECK_tb, SIZE_tb, SEQ_tb, DONE_INCHECK_tb,START_WAIT_tb,WAITLED_tb,DONE_WAIT_tb);

CLK_tb<=not CLK_tb after 5ns;

process --Control de botones
begin
--Esperar hasta el pulso de inicio
wait until START_WAIT_tb='1';
if START_WAIT_tb='1' then
wait until START_WAIT_tb='0';

if STATE_tb=S3_0 then 
if UP_BUTTON = '1' then
        assert BUTTON_PUSHED_tb=1
		report "Boton incorrecta"
		severity failure;
elsif DOWN_BUTTON = '1' then
        assert BUTTON_PUSHED_tb=2
		report "Boton incorrecta"
		severity failure;
elsif RIGHT_BUTTON = '1' then
        assert BUTTON_PUSHED_tb=3
		report "Boton incorrecta"
		severity failure;
elsif LEFT_BUTTON = '1' then
        assert BUTTON_PUSHED_tb=4
		report "Boton incorrecta"
		severity failure;
end if;
end if;
end if;

end process;

process --Control de salidas
variable i: natural :=0;
begin
--Esperar hasta el pulso de inicio
wait until START_WAIT_tb='1';
if START_WAIT_tb='1' then
wait until START_WAIT_tb='0';

if STATE_tb=S3_1WT then
wait for 10ns;
DONE_WAIT_tb<='1';
wait for 5ns;
DONE_WAIT_tb<='0';
i:=i+1;
elsif STATE_tb=S3_2WT then
wait for 10ns;
DONE_WAIT_tb<='1';
wait for 5ns;
DONE_WAIT_tb<='0';
i:=i+1;
elsif STATE_tb=S3_3WT then
wait for 20ns;
DONE_WAIT_tb<='1';
wait for 5ns;
DONE_WAIT_tb<='0';
i:=i+1;
elsif STATE_tb=S3_4WT then
wait for 10ns;
DONE_WAIT_tb<='1';
wait for 5ns;
DONE_WAIT_tb<='0';
i:=i+1;
end if;
end if;

end process;

process
begin
wait until RSTN_tb='1';
UP_BUTTON<='0';
DOWN_BUTTON<='0';
LEFT_BUTTON<='0';
RIGHT_BUTTON<='0';
--Pulsacion de botones
wait until STATE_tb=S3_0;
UP_BUTTON<='1';
wait for 10ns;
UP_BUTTON<='0';
wait until STATE_tb=S3_0;
LEFT_BUTTON<='1';
wait for 10ns;
LEFT_BUTTON<='0';
--COMPROBAR ERROR
wait until STATE_tb=S3_0; 
RIGHT_BUTTON<='1';
wait for 10ns;
RIGHT_BUTTON<='0';
wait until STATE_tb=S3_0;
DOWN_BUTTON<='1';
wait for 10ns;
DOWN_BUTTON<='0';
wait until STATE_tb=S3_0;
RIGHT_BUTTON<='1';
wait for 10ns;
RIGHT_BUTTON<='0';



end process;


process
begin
RSTN_tb<='0';
START_INCHECK_tb<='0';
		wait for 10ns;
		RSTN_tb<=not RSTN_tb;
		wait for 20ns;
		START_INCHECK_tb<=not START_INCHECK_tb;
		wait for 10ns;
		START_INCHECK_tb<='0';
		wait for 10ns;

wait for 200ns;
RSTN_tb<='0';

		assert false
		report "Simulacion finalizada"
		severity failure;

wait;
		  
end process;

end;
