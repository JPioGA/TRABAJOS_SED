library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.tipos_esp.ALL;

entity SLAVE_SHOWSEQ_tb is
end SLAVE_SHOWSEQ_tb;

architecture tb of SLAVE_SHOWSEQ_tb is

component FSM_1_SLAVE_SHOWSEQ
    port (
        CLK                     : in STD_LOGIC;
        RST_N                   : in STD_LOGIC;
        LED_VALUE               : out natural; --LED a bit
        STATE                   : out STATE_T;
        
        -- MASTER-SLAVE SHOWSEQ interface
        START_SHOWSEQ           : in std_logic;
        PARAM_SHOWSEQ_sequence  : in natural_vector;
        PARAM_SHOWSEQ_size      : in natural;
        DONE_SHOWSEQ            : out std_logic;

        -- SLAVE SHOWSEQ-SLAVE WAITLED interface
        START_WAITLED   : out std_logic;
        PARAM_WAITLED   : out natural; -- Número de ciclos de reloj a esperar
        DONE_WAITLED    : in std_logic
        );
end component;
signal  CLK_tb                  :  STD_LOGIC:='0';
signal  RSTN_tb                 :  STD_LOGIC;
signal  LED_tb                  :  natural; --LED a encender
signal  STATE_tb                :  STATE_T;
signal  START_SHOWSEQ_tb        :  std_logic;
signal  SEQ_tb                  :  natural_vector:=(1,4,2,3,others=>0);
signal  SIZE_tb                 :  natural:=4;
signal  DONE_SHOWSEQ_tb         :  std_logic;
signal  START_WAIT_tb			:  std_logic;
signal  WAITLED_tb				:  natural;
signal  DONE_WAIT_tb			:  std_logic:='0';

begin
uut : FSM_1_SLAVE_SHOWSEQ port map (CLK_tb, RSTN_tb, LED_tb,STATE_tb, START_SHOWSEQ_tb, SEQ_tb, SIZE_tb, DONE_SHOWSEQ_tb,START_WAIT_tb,WAITLED_tb,DONE_WAIT_tb);

CLK_tb<=not CLK_tb after 5ns;

process
variable i: natural :=0;
begin
wait until START_WAIT_tb='1';
if START_WAIT_tb='1' then
wait until START_WAIT_tb='0';
if STATE_tb=S2_1WT then
        assert LED_tb=SEQ_tb(i)
		report "Salida incorrecta"
		severity failure;
wait for 10ns;
DONE_WAIT_tb<='1';
wait for 5ns;
DONE_WAIT_tb<='0';
i:=i+1;
elsif STATE_tb=S2_2WT then
        assert LED_tb=SEQ_tb(i)
		report "Salida incorrecta"
		severity failure;
wait for 10ns;
DONE_WAIT_tb<='1';
wait for 5ns;
DONE_WAIT_tb<='0';
i:=i+1;
elsif STATE_tb=S2_3WT then
        assert LED_tb=SEQ_tb(i)
		report "Salida incorrecta"
		severity failure;
wait for 20ns;
DONE_WAIT_tb<='1';
wait for 5ns;
DONE_WAIT_tb<='0';
i:=i+1;
elsif STATE_tb=S2_4WT then
        assert LED_tb=SEQ_tb(i)
		report "Salida incorrecta"
		severity failure;
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
RSTN_tb<='0';
START_SHOWSEQ_tb<='0';
		wait for 10ns;
		RSTN_tb<=not RSTN_tb;
		wait for 20ns;
		START_SHOWSEQ_tb<=not START_SHOWSEQ_tb;
		wait for 10ns;
		START_SHOWSEQ_tb<='0';
		wait for 10ns;

wait for 200ns;
RSTN_tb<='0';

		assert false
		report "Simulacion finalizada"
		severity failure;

wait;
		  
end process;

end;

