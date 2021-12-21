-----------------------------------------------------------------------------------
-- FSM_TOP
-- 
-----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use work.tipos_especiales.ALL;

entity FSM_TOP is
    port (  CLK : in std_logic;
            RST_N : in std_logic;
            BUTTON   : in std_logic_vector(4 downto 0); -- ( 0 OK - 1 UP -  2 DOWN - 3 LEFT -  4 RIGHT)
            --LED      : out std_logic_vector(3 downto 0); -- 
            ATTEMPS : out natural range 0 to 10;
            OUT_MESSAGE : out std_logic_vector(2 downto 0)); -- "000" si nada // "001" si START // "010" si GO // "011" si GAME OVER // "100" si WIN
end FSM_TOP;

architecture Behavioral of FSM_TOP is
    -- SEÑALES de INTERCONEXIÖN de COMPONENTES
        -- Interfaz entre MASTER e INCHECK
    signal incheck_start : std_logic;
    signal incheck_param : SEQUENCE2_T;
    signal incheck_done : std_logic_vector(1 downto 0);
    signal incheck_trys : natural range 0 to 10;
        -- Interfez entre MASTER y TIMER
    signal timer_start : std_logic;
    signal timer_done  : std_logic;
        -- Interfaz entre MASTER y LFSR
    signal lfsr_seq    : SEQUENCE2_T;
    signal lfsr_done   : std_logic;
    
    
begin
    inst_master: FSM_MASTER
        port map(   CLK           => CLK,
                    RST_N         => RST_N,
                    OK_BUTTON     => BUTTON(0), -- OK_BUTTON
                    OUT_MESSAGE   => OUT_MESSAGE,
                    -- Interfez entre MASTER y TIMER
                    START_TIMER   => timer_start,
                    DONE_TIMER    => timer_done,
                    -- Interfaz entre MASTER y LFSR
                    RAND_SEQ      => lfsr_seq,
                    DONE_LFSR     => lfsr_done,
                    -- Interfaz entre MASTER e INCHECK
                    START_INCHECK => incheck_start,
                    PARAM_SEQ     => incheck_param,
                    DONE_INCHECK  => incheck_done);
                    
    inst_timer: FSM_SLAVE_TIMER
        port map(   CLK         => CLK,
                    RST_N       => RST_N,
                    START_TIMER => timer_start,
                    DONE_TIMER  => timer_done);
                    
    inst_lfsr: LFSR
        port map(   CLK   => CLK,
                    RST_N => RST_N,
                    NEW_SEQ => lfsr_done,
                    RETURN_LFSR => lfsr_seq);
                    
    --inst_incheck: FSM_SLAVE_INCHECK
    inst_incheck: FSM_INCHECK
        port map(   CLK           => CLK,
                    RST_N         => RST_N,
                    START_INCHECK => incheck_start,
                    PARAM_SEQ     => incheck_param,
                    --BTN => BUTTON(4 downto 1),
                    UP_BTN        => BUTTON(1), -- Todos los botones menos el OK_BUTTON
                    DOWN_BTN        => BUTTON(2),
                    LEFT_BTN        => BUTTON(3),
                    RIGHT_BTN        => BUTTON(4),                    
                    --LED           => LED,
                    DONE_INCHECK  => incheck_done,
                    INTENTOS => ATTEMPS);
end Behavioral;