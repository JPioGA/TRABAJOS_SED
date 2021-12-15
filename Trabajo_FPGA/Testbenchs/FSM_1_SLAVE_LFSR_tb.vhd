----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2021 00:42:46
-- Design Name: 
-- Module Name: FSM_1_SLAVE_LFSR_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.tipos_esp.ALL;

entity FSM_1_SLAVE_LFSR_tb is
end FSM_1_SLAVE_LFSR_tb;

architecture Behavioral of FSM_1_SLAVE_LFSR_tb is
    component FSM_1_SLAVE_LFSR is
        port(
            CLK         : in std_logic; -- Se�al de reloj
            RST_N       : in std_logic; -- Se�al de reset as�ncrona. OJO! Nunca reinicial el valor del registro de estados con TODO 0. Se bloquea. 
            --START_LFSR  : in std_logic;  -- Se�al de petici�n de un nuevo valor pseudo-aleatorio
            --DONE_LFSR   : out std_logic; -- Se�al de fin de devoluci�n de un par de bit pseudo-aleatorios
            RETURN_LFSR : out LED_T     -- Valor de 1 a 4 devuelto por el componente
        );
    end component;
    
    signal clock : std_logic := '0';
    signal reset : std_logic;
    signal output : LED_T;
    
    constant K: time := 10 ns; -- 
    
begin
    uut : FSM_1_SLAVE_LFSR
        port map(
            CLK => clock,
            RST_N => reset,
            RETURN_LFSR => output
        );
        
    clock <= not clock after 0.5*K; -- Se�al de reloj
    reset <= '0' after 0.25*K, '1' after 0.75*K; -- Se�al de reset
    
    LFSR_tb: process
    begin
        for i in 1 to 100 loop
            wait until output'event;
        end loop;
        
        -- Fin de la simualci�n
        assert false
            report "Fin de la simulaci�n OK"
            severity failure;
    end process;
end Behavioral;
