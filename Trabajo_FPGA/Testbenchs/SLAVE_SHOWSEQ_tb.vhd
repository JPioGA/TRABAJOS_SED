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
        START_SHOWSEQ           : in std_logic;
        PARAM_SHOWSEQ_sequence  : in natural_vector;
        PARAM_SHOWSEQ_size      : in natural;
        DONE_SHOWSEQ            : out std_logic;
        LED_VALUE               : out natural --LED a encender
    );
end component;
signal  CLK_tb                  :  STD_LOGIC:='0';
signal  RSTN_tb                 :  STD_LOGIC;
signal  START_tb                :  std_logic;
signal  SEQ_tb                  :  natural_vector:=(1,4,2,3,others=>0);
signal  SIZE_tb                 :  natural:=4;
signal  DONE_tb                 :  std_logic;
signal  LED_tb                  :  natural; --LED a encender

begin
uut : FSM_1_SLAVE_SHOWSEQ port map (CLK_tb, RSTN_tb, START_tb, SEQ_tb, SIZE_tb, DONE_tb, LED_tb);

CLK_tb<=not CLK_tb after 5ns;

process
begin
RSTN_tb<='0';
START_tb<='0';
		wait for 10ns;
		RSTN_tb<=not RSTN_tb;
		wait for 20ns;
		START_tb<=not START_tb;
		
wait for 200ns;
RSTN_tb<='0';
START_tb<='0';

wait;
		  
end process;
end;