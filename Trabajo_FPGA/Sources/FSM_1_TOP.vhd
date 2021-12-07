-- Máquina de estado de control de las fases del juego Simón Dice.
-- Compuesta por:
-- 		FSM_1_MASTER: que irá evolucionando según las interacción con el ususario
--		FSM_1_SLAVE_SHOWSEQ:
--      FSM_1_SLAVE_INCHECK:
--      FSM_1_SLAVE_TIMER:


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FSM_1_TOP is
end FSM_1_TOP;



architecture structural of FSM_1_TOP is

	component FSM_1_MASTER is
		port (
		  CLK     : in  std_logic;
		  RST_N   : in  std_logic;
		  
		  
		);
	end component;

	component FSM_1_SLAVE_SHOWSEQ is
		port (
		  CLK     : in  std_logic;
		  RST_N   : in  std_logic;
		  
		);
	end component;

	component FSM_1_SLAVE_INCHECK is
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
	
	incheck: FSM_1_SLAVE_SHOWSEQ
		port map (
		  CLK     => ,
		  RST_N   => ,
		  
		);
	
	incheck: FSM_1_SLAVE_INCHECK
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
