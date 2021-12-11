----------------------------------------------------------------------------------
-- Entidad TOP del SLAVE SHOWSEQ.
-- Se conecta el otro slave WAITLED para realizar las esperas de los estados
-- en los que se encienden los LEDS durante unos segundos.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.tipos_esp.ALL;

entity FSM_1_SLAVE_SHOWSEQ_TOP is
    port (
        CLK                     : in STD_LOGIC;
        RST_N                   : in STD_LOGIC;
        LED_VALUE               : out natural; --LED a bit
        STATE_TOP               : out STATE_SHOWSEQ_T;
        
        -- MASTER-SLAVE SHOWSEQ interface
        START_SHOWSEQ           : in std_logic;
        PARAM_SHOWSEQ_sequence  : in natural_vector;
        PARAM_SHOWSEQ_size      : in natural;
        DONE_SHOWSEQ            : out std_logic
    );
end FSM_1_SLAVE_SHOWSEQ_TOP;

architecture structural of FSM_1_SLAVE_SHOWSEQ_TOP is
    component FSM_1_SLAVE_SHOWSEQ
        port(
            CLK                     : in STD_LOGIC;
            RST_N                   : in STD_LOGIC;
            LED_VALUE               : out natural; --LED a bit 
            STATE                   : out STATE_SHOWSEQ_T;    
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
    
    component FSM_1_SLAVE_WAITLED
        port(
            CLK		      :	in 	std_logic; -- Entrada de RELOJ
            RST_N	      :	in 	std_logic; -- Entrada de RESET
            START_WAITLED : in std_logic;
            PARAM_WAITLED : in natural; -- Número de ciclos de reloj a esperar
            DONE_WAITLED  : out std_logic
        );
    end component;
    
    signal start_wait : std_logic;
    signal done_wait  : std_logic;
    signal param_wait : natural;
   
    
begin
    instance_showseq: FSM_1_SLAVE_SHOWSEQ port map(
        CLK                     => CLK,
        RST_N                   => RST_N,
        LED_VALUE               => LED_VALUE,
        STATE                   => STATE_TOP,
        START_SHOWSEQ           => START_SHOWSEQ,
        PARAM_SHOWSEQ_sequence  => PARAM_SHOWSEQ_sequence,
        PARAM_SHOWSEQ_size      => PARAM_SHOWSEQ_size,
        DONE_SHOWSEQ            => DONE_SHOWSEQ,
        START_WAITLED           => start_wait,
        PARAM_WAITLED           => param_wait,
        DONE_WAITLED            => done_wait
    );
    instance_waitled: FSM_1_SLAVE_WAITLED port map(
        CLK             => CLK,
        RST_N           => RST_N,
        START_WAITLED   => start_wait,
        PARAM_WAITLED   => param_wait,
        DONE_WAITLED    => done_wait
    );
end structural;
    
