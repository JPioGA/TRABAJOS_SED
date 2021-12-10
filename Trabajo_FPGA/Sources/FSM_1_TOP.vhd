----------------------------------------------------------------------------------
-- Máquina de estado de control de las fases del juego Simón Dice.
-- Compuesta por:
-- 		FSM_1_MASTER: que irá evolucionando según las interacción con el ususario
--      FSM_1_WAITLED: 
--		FSM_1_SLAVE_SHOWSEQ_TOP:
--      FSM_1_SLAVE_INCHECK_TOP:
--      FSM_1_SLAVE_TIMER:
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity FSM_1_TOP is
end FSM_1_TOP;


architecture structural of FSM_1_TOP is

	component FSM_1_MASTER is
		port (
		  CLK     : in  std_logic;
		  RST_N   : in  std_logic;
		  
		  
		);
	end component;
	
    component FSM_1_SLAVE_WAITLED is
		port (
		  CLK     : in  std_logic;
		  RST_N   : in  std_logic;
		  
		);
	end component;
	
	component FSM_1_SLAVE_SHOWSEQ_TOP is
		port (
		  CLK     : in  std_logic;
		  RST_N   : in  std_logic;
		  
		);
	end component;

	component FSM_1_SLAVE_INCHECK_TOP is
		port (
		  CLK     : in  std_logic;
		  RST_N   : in  std_logic;
		  
		);
	end component;
	
	component FSM_1_SLAVE_TIMER is
		port (
		  CLK     : in  std_logic;
		  RST_N   : in  std_logic;
		  
		);
	end component;
begin
	master: FSM_1_MASTER
		port map (
		  CLK     => ,
		  RST_N   => ,
		  
		);
	
	showseq: FSM_1_SLAVE_SHOWSEQ_TOP
		port map (
		  CLK     => ,
		  RST_N   => ,
		  
		);
	
	incheck: FSM_1_SLAVE_INCHECK_TOP
		port map (
		  CLK     => ,
		  RST_N   => ,
		  
		);

	timer: FSM_1_SLAVE_TIMER
		port map (
		  CLK     => ,
		  RST_N   => ,
		  
		);
	
end structural;
