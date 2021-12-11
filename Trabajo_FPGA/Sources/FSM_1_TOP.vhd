----------------------------------------------------------------------------------
-- Máquina de estado de control de las fases del juego Simón Dice.
-- Compuesta por:
-- 		FSM_1_MASTER: Evolución general del juego
--      FSM_1_WAITLED: Contador para realizar esperas de encendido de leds y mensajes
--		FSM_1_SLAVE_SHOWSEQ_TOP:
--      FSM_1_SLAVE_INCHECK_TOP:
--      FSM_1_SLAVE_TIMER:
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.tipos_esp.ALL;

entity FSM_1_TOP is
    port(
        CLK     : in  std_logic;
		RST_N   : in  std_logic;
		OK_BUTTON : in std_logic;
		LED_VALUE :out natural;
		OUT_MESSAGE : out natural;
		CUR_TIME : out natural;
		ROUND : out natural
    );
end FSM_1_TOP;


architecture structural of FSM_1_TOP is

	component FSM_1_MASTER is
		port (
		  CLK     : in  std_logic;
		  RST_N   : in  std_logic
		  
		  
		);
	end component;
	
    component FSM_1_SLAVE_WAITLED is
		port (
		  CLK     : in  std_logic;
		  RST_N   : in  std_logic
		  
		);
	end component;
	
	component FSM_1_SLAVE_SHOWSEQ_TOP is
		port (
		  CLK     : in  std_logic;
		  RST_N   : in  std_logic
		  
		);
	end component;

	component FSM_1_SLAVE_INCHECK_TOP is
		port (
		  CLK     : in  std_logic;
		  RST_N   : in  std_logic
		  
		);
	end component;
	
	component FSM_1_SLAVE_TIMER is
		port (
		  CLK     : in  std_logic;
		  RST_N   : in  std_logic
		  
		);
	end component;
begin
	master: FSM_1_MASTER
		port map (
		  CLK     => CLK,
		  RST_N   => RST_N
		  
		);
	waitled: FSM_1_SLAVE_WAITLED
		port map (
		  CLK     => CLK,
		  RST_N   => RST_N
		  
		);
		
	showseq: FSM_1_SLAVE_SHOWSEQ_TOP
		port map (
		  CLK     => CLK,
		  RST_N   => RST_N
		  
		);
	
	incheck: FSM_1_SLAVE_INCHECK_TOP
		port map (
		  CLK     => CLK,
		  RST_N   => RST_N
		  
		);

	timer: FSM_1_SLAVE_TIMER
		port map (
		  CLK     => CLK,
		  RST_N   => RST_N
		  
		);
	
end structural;
