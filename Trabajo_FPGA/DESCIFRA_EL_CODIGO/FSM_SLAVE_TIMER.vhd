----------------------------------------------------------------------------------
-- FSM_SLAVE_TIMER
-- Temporizador. Utilizado para realizar esperas a la hora de mostrar mensajes por los displays.
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity FSM_SLAVE_TIMER is
    generic( DELAY : natural := 200000000); -- Pulsos de reloj a esperar (100 MHz)
    
    port (  CLK         : in std_logic;
            RST_N       : in std_logic;
            START_TIMER : in std_logic;
            DONE_TIMER  : out std_logic);
            
end FSM_SLAVE_TIMER;

architecture Behavioral of FSM_SLAVE_TIMER is
    signal count : natural;
begin
  DONE_TIMER <= '1' when count = 0 else '0';

  process (CLK, RST_N)
  begin
    if RST_N = '0' then
      count <= 0;
    elsif rising_edge(CLK) then
      if START_TIMER = '1' then
        count <= DELAY;
      elsif count /= 0 then
        count <= count - 1;
      end if;
    end if;
  end process;
  
end Behavioral;
