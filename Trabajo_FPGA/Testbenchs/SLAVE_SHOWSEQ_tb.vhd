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
        
        -- MASTER-SLAVE SHOWSEQ interface
        START_SHOWSEQ           : in std_logic;
        PARAM_SHOWSEQ_sequence  : in natural_vector;
        PARAM_SHOWSEQ_size      : in natural;
        DONE_SHOWSEQ            : out std_logic;

        -- SLAVE SHOWSEQ-SLAVE WAITLED interface
        START_WAITLED   : out std_logic;
        PARAM_WAITLED   : out natural; -- Número de ciclos de reloj a esperar
        DONE_WAITLED    : in std_logic
end component;
signal  CLK_tb                  :  STD_LOGIC:='0';
signal  RSTN_tb                 :  STD_LOGIC;
signal  LED_tb                  :  natural; --LED a encender
signal  START_SHOWSEQ_tb        :  std_logic;
signal  SEQ_tb                  :  natural_vector:=(1,4,2,3,others=>0);
signal  SIZE_tb                 :  natural:=3;
signal  DONE_SHOWSEQ_tb         :  std_logic;
signal  START_WAIT_tb			:  std_logic;
signal  WAITLED_tb				:  natural;
signal  DONE_WAIT_tb			:  std_logic;

begin
uut : FSM_1_SLAVE_SHOWSEQ port map (CLK_tb, RSTN_tb, LED_tb, START_SHOWSEQ_tb, SEQ_tb, SIZE_tb, DONE_SHOWSEQ_tb,START_WAIT_tb,WAITLED_tb,DONE_WAIT_tb);

CLK_tb<=not CLK_tb after 5ns;

process(START_WAIT_tb)
variable i: natural :=0;
begin
if falling_edge (START_WAIT_tb) then
DONE_WAIT_tb <= '1';
end if;
if DONE_WAIT_tb <= '1' then 
        assert LED_tb=SEQ(i)
		report "Salida incorrecta"
		severity failure;
i:=i+1;
wait for 5ns;
DONE_WAIT_tb<='0';
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

