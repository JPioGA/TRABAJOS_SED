----------------------------------------------------------------------------------
-- Máquina de estado de control de las fases del juego Simón Dice.
-- Compuesta por:
-- 		FSM_1_MASTER: Evolución general del juego
--      FSM_1_WAITLED: Contador para realizar esperas de encendido de leds y mensajes
--		FSM_1_SLAVE_SHOWSEQ_TOP: Componente encargado de mostrar por los leds la secuencia a introducir.
--      FSM_1_SLAVE_INCHECK_TOP: Componente encargado de la comprobación de los inputs del jugador
--      FSM_1_SLAVE_TIMER: Temporizador que marca el tiempo restante para introducir el input del jugador en cada ronda.
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.tipos_esp.ALL;

entity FSM_1_TOP is
    generic(
        COLORS      : natural := 4
    );
    port(
        CLK              : in  std_logic;
		RST_N            : in  std_logic;
		-- Entradas botones
		OK_BUTTON_top    : in std_logic;
		UP_BUTTON_top    : in std_logic;
		DOWN_BUTTON_top  : in std_logic;
		RIGHT_BUTTON_top : in std_logic;
		LEFT_BUTTON_top  : in std_logic;
		-- Salidas ha visualizer
		--LED_VALUE_top    : out LED_T;
		LIGHT_top        : out std_logic_vector(COLORS-1 downto 0);
		OUT_MESSAGE_top  : out MESSAGE_T;
		CUR_TIME_top     : out natural;
		ROUND_top        : out ROUND_T
	
    );
end FSM_1_TOP;


architecture structural of FSM_1_TOP is

	component FSM_1_MASTER is
		port (
		  CLK                 : in  std_logic;
		  RST_N               : in  std_logic;
		  OK_BUTTON           : in std_logic;
          ROUND               : out ROUND_T;
          OUT_MESSAGE         : out MESSAGE_T; -- 1: START ANIMATION; 2: GO INPUT ANIMATION; 3: INPUT OK ANIMATION; 4: GAME OVER ANIMATION
        
          -- MASTER-SLAVE WAIT interface
          START_WAITLED       : out std_logic;
          PARAM_WAITLED       : out natural;
          DONE_WAITLED        : in std_logic;
        
          -- MASTER-SLAVE SHOWSEQ interface
          START_SHOWSEQ       : out std_logic;
          PARAM_SHOWSEQ_seq   : out natural_vector;
          PARAM_SHOWSEQ_size  : out ROUND_T;
          DONE_SHOWSEQ        : in std_logic;
        
          -- MASTER-SLAVE INCHECK interface
          START_INCHECK       : out std_logic;
          PARAM_INCHECK_size  : out ROUND_T;
          PARAM_INCHECK_seq   : out natural_vector;
          DONE_INCHECK        : in LED_T; -- 0: none; 1: NO OK; 2: OK. Utilizo WAITLED para disminuir uso de memo

          
          -- MASTER-SLAVE LFSR interface
          RAND_VALUE          : in LED_T;
          
          -- SLAVES SHOWSEQ INCHECK - MUX LEDS interface
          SELECTOR     : out std_logic 
             
		);
	end component;
	
    component FSM_1_SLAVE_WAITLED is
		port(
          CLK		    : in std_logic; -- Entrada de RELOJ
          RST_N	        : in std_logic; -- Entrada de RESET
          START_WAITLED : in std_logic;
          PARAM_WAITLED : in natural; -- NÃºmero de ciclos de reloj a esperar
          DONE_WAITLED  : out std_logic
        );
	end component;
	
	component FSM_1_SLAVE_SHOWSEQ_TOP is
		port(
          CLK                : in  std_logic;
          RST_N              : in  std_logic;
		  --LED_VALUE          : out LED_T; --LED a bit
		  LIGHT              : out std_logic_vector(COLORS-1 downto 0);
          --STATE_TOP          : out STATE_SHOWSEQ_T;
          -- MASTER-SLAVE SHOWSEQ interface
          START_SHOWSEQ      : in std_logic;
          PARAM_SHOWSEQ_seq  : in natural_vector;
          PARAM_SHOWSEQ_size : in natural;
          DONE_SHOWSEQ       : out std_logic
		);
	end component;

	component FSM_1_SLAVE_INCHECK_TOP is
		port (
		  CLK                : in  std_logic;
		  RST_N              : in  std_logic;
		  UP_BUTTON          : in std_logic;
          DOWN_BUTTON        : in std_logic;
          RIGHT_BUTTON       : in std_logic;
          LEFT_BUTTON        : in std_logic;
          --LED_VALUE          : out LED_T; --LED a encender
          LIGHT              : out std_logic_vector(COLORS-1 downto 0);
          -- MASTER-SLAVE INCHECK interfece
          START_INCHECK      : in std_logic;
          PARAM_INCHECK_size : in natural; -- SIZE. Tamaño de la secuencia actual
          PARAM_INCHECK_seq  : in natural_vector; -- SEQ. Secuencia actual
          DONE_INCHECK       : out LED_T -- 0: none; 1: NO OK; 2: name
		);
	end component;
	
	component FSM_1_SLAVE_LFSR is
		port (
		  CLK          : in  std_logic;
		  RST_N        : in  std_logic;
		  RETURN_LFSR : out LED_T
		);
	end component;
	
	component MUX_LEDS is
        port (
            SELECTOR     : in std_logic;
            LEDS_SHOWSEQ : in std_logic_vector(3 downto 0);
            LEDS_INCHECK : in std_logic_vector(3 downto 0);
            OUTPUT_MUX   : out std_logic_vector(3 downto 0)
        );
    end component;
	-- SEÑALES DE INTERCONEXIÓN ENTRE COMPONENTES
	   --Señales MASTER-WAITLED
	signal wait_start : std_logic;
    signal wait_done  : std_logic;
    signal wait_param : natural;
        -- Señales MASTER-SHOWSEQ
    signal showseq_start      : std_logic;
    signal showseq_done       : std_logic;
    signal showseq_param_size : ROUND_T;
    signal showseq_param_seq  : natural_vector;
        --Señales MASTER-INCHECK
    signal incheck_start      : std_logic;
    signal incheck_done       : LED_T;
    signal incheck_param_size : natural;
    signal incheck_param_seq  : natural_vector;

        -- Señales MASTER-LFSR
    signal random_value : LED_T;
        --
    signal mux_select : std_logic;
    signal leds_showseq : std_logic_vector(COLORS-1 downto 0);
    signal leds_incheck : std_logic_vector(COLORS-1 downto 0);
begin
	master: FSM_1_MASTER
		port map (
		  CLK                => CLK,
		  RST_N              => RST_N,
		  OK_BUTTON          => OK_BUTTON_top,
          ROUND              => ROUND_top,
          OUT_MESSAGE        => OUT_MESSAGE_top,
          -- MASTER-SLAVE WAIT interface
          START_WAITLED      => wait_start,
          PARAM_WAITLED      => wait_param,
          DONE_WAITLED       => wait_done,
          -- MASTER-SLAVE SHOWSEQ interface
          START_SHOWSEQ      => showseq_start,
          PARAM_SHOWSEQ_seq  => showseq_param_seq,
          PARAM_SHOWSEQ_size => showseq_param_size,
          DONE_SHOWSEQ       => showseq_done,
          -- MASTER-SLAVE INCHECK interface
          START_INCHECK      => incheck_start,
          PARAM_INCHECK_size => incheck_param_size,
          PARAM_INCHECK_seq  => incheck_param_seq,
          DONE_INCHECK       => incheck_done,

          -- MASTER-SLAVE LFSR interface
          RAND_VALUE         => random_value,
          -- SLAVES SHOWSEQ INCHECK - MUX LEDS interface
          SELECTOR     => mux_select
      
		);
		
	waitled: FSM_1_SLAVE_WAITLED
		port map (
		  CLK           => CLK,
		  RST_N         => RST_N,
		  START_WAITLED => wait_start,
          PARAM_WAITLED => wait_param,
          DONE_WAITLED  => wait_done
		);
		
	showseq: FSM_1_SLAVE_SHOWSEQ_TOP
		port map (
		  CLK                => CLK,
		  RST_N              => RST_N,
		  --LED_VALUE          => LED_VALUE_top,
		  LIGHT              => leds_showseq,
          --STATE_TOP          => ,
          -- MASTER-SLAVE SHOWSEQ interface
          START_SHOWSEQ      => showseq_start,
          PARAM_SHOWSEQ_seq  => showseq_param_seq,
          PARAM_SHOWSEQ_size => showseq_param_size,
          DONE_SHOWSEQ       => showseq_done
		);
	
	incheck: FSM_1_SLAVE_INCHECK_TOP
		port map (
		  CLK                => CLK,
		  RST_N              => RST_N,
		  UP_BUTTON          => UP_BUTTON_top,
          DOWN_BUTTON        => DOWN_BUTTON_top,
          RIGHT_BUTTON       => RIGHT_BUTTON_top,
          LEFT_BUTTON        => LEFT_BUTTON_top,
          --LED_VALUE          => LED_VALUE_top,
          LIGHT              => leds_incheck,
          -- MASTER-SLAVE INCHECK interfece
          START_INCHECK      => incheck_start,
          PARAM_INCHECK_size => incheck_param_size,
          PARAM_INCHECK_seq  => incheck_param_seq,
          DONE_INCHECK       => incheck_done		  
		);

	lfsr: FSM_1_SLAVE_LFSR
	   port map(
	       CLK => CLK,
	       RST_N => RST_N,
	       RETURN_LFSR => random_value
	   );
	   
	mux_led: MUX_LEDS
	   port map(
	       SELECTOR => mux_select,
           LEDS_SHOWSEQ => leds_showseq,
           LEDS_INCHECK => leds_incheck,
           OUTPUT_MUX => LIGHT_top
	   );
	
end structural;
