----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.tipos_especiales.all;


entity FSM_SHOWSEQ is

port (
       CLK         : in std_logic;
       RST_N       : in std_logic;
       PARAM_SEQ   : in SEQUENCE2_T; -- Secuencia aleatoria a adivinar por el jugador
      
       START_TIMER : out std_logic;
       DONE_TIMER  : in std_logic; 
             
       START_SHOWSEQ : in std_logic;      
       DONE_SHOWSEQ  : out std_logic;
       
       LEDS        : out std_logic_vector(3 downto 0)
       --STATE       : out STATE_SHOWSEQ_T
);
end entity;

architecture Behavioral of FSM_SHOWSEQ is
    signal cur_state	 : STATE_SHOWSEQ_T := S_STBY;				-- Estado actual
    signal nxt_state	 : STATE_SHOWSEQ_T;
    signal cur_size : natural := 4;
    signal nxt_size : natural;
    
    begin
        -- Actualización de los estados
        state_register: process(CLK, RST_N)
        begin
            if RST_N = '0' then -- Si entra un reset, mandar a reposo la máquina de estados
                cur_state <= S_STBY;
                cur_size <= 4;
                
            elsif rising_edge(CLK) then
                cur_state <= nxt_state;
                cur_size <= nxt_size;	
            end if;
        end process;
        
        nxt_state_decod : process(cur_state,START_SHOWSEQ,DONE_TIMER,cur_size)
        begin
            nxt_state <= cur_state;
            nxt_size <= cur_size;
            LEDS <= (others => '0');
            START_TIMER <= '0';
            DONE_SHOWSEQ <= '0';
            
            case cur_state is
                when S_STBY =>
                    if START_SHOWSEQ = '1' then
                        nxt_size <= 4;                
                        nxt_state <= S0;
                    end if;
                    
                when S0 =>
                    START_TIMER <= '1';
                    nxt_state <= S1;
                
                when S1 =>
                    
                    if PARAM_SEQ(cur_size-1) = "00" then
                        LEDS <= "0001"; -- UP
                    elsif PARAM_SEQ(cur_size-1) = "01" then -- Paso a esperar DOWN_BTN
                        LEDS <= "0010"; -- DOWN
                    elsif PARAM_SEQ(cur_size-1) = "10" then -- Paso a esperar LEFT_BTN
                        LEDS <= "0100"; -- LEFT
                    elsif PARAM_SEQ(cur_size-1) = "11" then -- Paso a esperar RIGHT_BTN
                        LEDS <= "1000"; -- RIGHT
                    end if;
                    
                    if cur_size > 1 then
                       if DONE_TIMER = '1' then
                            nxt_size <= cur_size - 1;
                            nxt_state <= S0;
                       end if;
                    elsif cur_size = 1 then
                       if DONE_TIMER = '1' then
                           nxt_size <= cur_size - 1;
                           nxt_state <= S2;
                        end if;
                     end if;
                     
                when S2 =>
                    DONE_SHOWSEQ <= '1';
                    nxt_state <= S_STBY;
                    
                when others =>
                    LEDS <= (others => '0');
                    START_TIMER <= '0';
                    DONE_SHOWSEQ <= '0';
                    nxt_state <= S_STBY;
            end case;
            --STATE <= cur_state;
        end process;

end Behavioral;

