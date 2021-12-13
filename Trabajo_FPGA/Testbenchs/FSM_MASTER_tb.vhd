
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.tipos_esp.all;


entity FSM_MASTER_tb is
end FSM_MASTER_tb;

architecture Behavioral of FSM_MASTER_tb is
component FSM_MASTER
port (
        -- General MASTER interface
        CLK         : in std_logic;
        RST_N       : in std_logic;
        OK_BUTTON   : in std_logic;
        ROUND       : out natural;
        OUT_MESSAGE : out natural; -- 1: START ANIMATION; 2: GO INPUT ANIMATION; 3: INPUT OK ANIMATION; 4: GAME OVER ANIMATION
        STATE_MASTER: out STATE_MASTER_T;
        GAME_SEQ    : out natural_vector;
        GAME_SIZE   : out natural;
       
        -- MASTER-SLAVE WAIT interface
        START_WAITLED   : out std_logic;
        PARAM_WAITLED   : out natural;
        DONE_WAITLED    : in std_logic;
        
        -- MASTER-SLAVE SHOWSEQ interface
        START_SHOWSEQ           : out std_logic;
        PARAM_SHOWSEQ_seq       : out natural_vector;
        PARAM_SHOWSEQ_size      : out natural;
        DONE_SHOWSEQ            : in std_logic;
        
        -- MASTER-SLAVE INCHECK interface
        START_INCHECK       : out std_logic;
        PARAM_INCHECK_size  : out natural;
        PARAM_INCHECK_seq   : out natural_vector;
        DONE_INCHECK        : in natural; -- 0: none; 1: NO OK; 2: OK
        
        -- MASTER-SLAVE TIMER interface
        START_TIMER : out std_logic;
        PARAM_TIMER : out natural;
        RST_COUNT   : out std_logic;
        DONE_TIMER  : in std_logic
    );
    end component;

signal CLK         :  std_logic:='0';
signal RST_N       :  std_logic;
signal OK_BUTTON   :  std_logic;
signal ROUND       :  natural;
signal OUT_MESSAGE :  natural; -- 1: START ANIMATION; 2: GO INPUT ANIMATION; 3: INPUT OK ANIMATION; 4: GAME OVER ANIMATION
signal STATE_MASTER:  STATE_MASTER_T;  
signal GAME_SEQ    :  natural_vector;
signal GAME_SIZE   :  natural;      
        -- MASTER-SLAVE WAIT interface
signal START_WAITLED   :  std_logic;
signal PARAM_WAITLED   :  natural;
signal DONE_WAITLED    :  std_logic;
        
        -- MASTER-SLAVE SHOWSEQ interface
signal START_SHOWSEQ           :  std_logic;
signal PARAM_SHOWSEQ_seq       :  natural_vector;
signal PARAM_SHOWSEQ_size      :  natural;
signal DONE_SHOWSEQ            :  std_logic;
        
        -- MASTER-SLAVE INCHECK interface
signal START_INCHECK       :  std_logic;
signal PARAM_INCHECK_size  :  natural;
signal PARAM_INCHECK_seq   :  natural_vector;
signal DONE_INCHECK        :  natural; -- 0: none; 1: NO OK; 2: OK
        
        -- MASTER-SLAVE TIMER interface
signal START_TIMER :  std_logic;
signal PARAM_TIMER :  natural;
signal RST_COUNT   :  std_logic;
signal DONE_TIMER  : std_logic;

begin

uut: FSM_MASTER port map(
        CLK,         
        RST_N,       
        OK_BUTTON,   
        ROUND,       
        OUT_MESSAGE,  -- 1: START ANIMATION; 2: GO INPUT ANIMATION; 3: INPUT OK ANIMATION; 4: GAME OVER ANIMATION
        STATE_MASTER,
        GAME_SEQ,
        GAME_SIZE,
        
        -- MASTER-SLAVE WAIT interface
        START_WAITLED,   
        PARAM_WAITLED,   
        DONE_WAITLED,    
        
        -- MASTER-SLAVE SHOWSEQ interface
        START_SHOWSEQ,          
        PARAM_SHOWSEQ_seq,      
        PARAM_SHOWSEQ_size,     
        DONE_SHOWSEQ,           
        
        -- MASTER-SLAVE INCHECK interface
        START_INCHECK,       
        PARAM_INCHECK_size,  
        PARAM_INCHECK_seq,   
        DONE_INCHECK,         -- 0: none; 1: NO OK; 2: OK
        
        -- MASTER-SLAVE TIMER interface
        START_TIMER, 
        PARAM_TIMER, 
        RST_COUNT,   
        DONE_TIMER  
        );
        
  CLK <= not CLK after 5ns; 

process --Control de estados
begin
wait until RST_N = '1';
if STATE_MASTER=S0_STBY then
wait for 10ns;
OK_BUTTON<='1';
wait for 5ns;
OK_BUTTON<='0';
end if;

wait until START_WAITLED='1';
wait until START_WAITLED='0';
wait for 5ns;
if STATE_MASTER=S0_WT then
wait for 10ns;
DONE_WAITLED<='1';

elsif STATE_MASTER=S3_WT then
wait for 10ns;
DONE_WAITLED<='1';

elsif STATE_MASTER=S5_WT then
wait for 10ns;
DONE_WAITLED<='1';
wait for 10ns;
assert STATE_MASTER=S1
report "Secuencia incorrecta"
severity failure;
end if;


wait until START_SHOWSEQ='1';
wait until START_SHOWSEQ='0';
wait for 5ns;
if STATE_MASTER=S2_WT then
wait for 10ns;
DONE_SHOWSEQ<='1';
end if;


wait until START_INCHECK='1';
wait until START_INCHECK='0';
wait for 5ns;
if STATE_MASTER=S4_WT then
wait for 10ns;
DONE_INCHECK<=2; --Para control de errores poner DONE_INCHECK<=1
wait for 10ns;
assert STATE_MASTER=S5 --S6
report "INCHECK incorrecto"
severity failure;
end if; 

end process;

process --Control de mensajes
begin
wait until STATE_MASTER=S0_STBY;
assert OUT_MESSAGE=1
report "Mensaje incorrecto"
severity failure;

wait until STATE_MASTER=S3;
assert OUT_MESSAGE=2
report "Mensaje incorrecto"
severity failure;


wait until STATE_MASTER=S5;
assert OUT_MESSAGE=3
report "Mensaje incorrecto"
severity failure;


wait until STATE_MASTER=S6;
assert OUT_MESSAGE=4
report "Mensaje incorrecto"
severity failure;

end process;

process
begin
RST_N<='0';

		wait for 10ns;
		RST_N<=not RST_N;

wait for 400ns;
RST_N<='0';

		assert false
		report "Simulacion finalizada"
		severity failure;

wait;
		  
end process;

end Behavioral;
