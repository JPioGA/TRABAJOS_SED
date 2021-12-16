----------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
use work.tipos_esp.ALL;


entity FSM_1_MASTER is
    generic(
        MAX_ROUND   : natural := 99;
        COLORS      : natural := 4;
        TIME_WAIT   : natural := 200000000
        );
    port (
        -- General MASTER interface
        CLK         : in std_logic;
        RST_N       : in std_logic;
        OK_BUTTON   : in std_logic;
        ROUND       : out natural;
        OUT_MESSAGE : out MESSAGE_T; -- 1: START ANIMATION; 2: GO INPUT ANIMATION; 3: INPUT OK ANIMATION; 4: GAME OVER ANIMATION
        
        -- MASTER-SLAVE WAIT interface
        START_WAITLED   : out std_logic;
        PARAM_WAITLED   : out natural;
        DONE_WAITLED    : in std_logic;
        
        -- MASTER-SLAVE SHOWSEQ interface
        START_SHOWSEQ           : out std_logic;
        PARAM_SHOWSEQ_seq  : out natural_vector;
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
        DONE_TIMER  : in std_logic;
        
        -- MASTER-SLAVE LFSR interface
        RAND_VALUE          : in LED_T;
        
        -- SLAVES SHOWSEQ INCHECK - MUX LEDS interface
        SELECTOR     : out std_logic
    );
end FSM_1_MASTER;


architecture Behavioral of FSM_1_MASTER is
    -- Declaración de señales utilizadas	
	signal cur_state	 : STATE_MASTER_T;				-- Estado actual
	signal nxt_state	 : STATE_MASTER_T;				-- Estado siguiente
	signal game_sequence : natural_vector;	-- Vector que contendrá en sus elementos los valores aleatorios a adivinar por el jugador.
	signal size          : natural := 0;	
	
begin
    -- Actualización de los estados
	state_register: process(CLK, RST_N)
	begin
		if RST_N = '0' then -- Si entra un reset, mandar a reposo la máquina de estados
			cur_state <= S0_WT;
		elsif rising_edge(CLK) then
			cur_state <= nxt_state;
		end if;
	end process;
	
	
	-- Control de transición entre estados
	nxt_state_decoder: process(cur_state, OK_BUTTON, DONE_SHOWSEQ, DONE_INCHECK, DONE_TIMER, DONE_WAITLED) -- Proceso COMBINACIONAL: Solo introducir las entradas.
	   variable i : natural := 0;
	begin
		-- Asegurar que el proceso sea combinacional
		nxt_state <= cur_state;
		
		-- Transiciones de estado y cambio de variables internas para el funcionamiento del juego
		case cur_state is
			when S0_STBY =>
				if OK_BUTTON = '1' then
					nxt_state <= S0;
				end if;
				-- Reinicio todas las variables internas para una nueva partida
				i := 0;
				size <= 0;
				
			when S0 =>
				nxt_state <= S0_WT;
			when S0_WT =>
			     if DONE_WAITLED = '1' then
			         nxt_state <= S1;
			     end if;
			     
			when S1 =>
				-- Adición de un nuevo elemento a la secuencia
				size <= size + 1;
				game_sequence(size-1) <= RAND_VALUE;
				i := 0;
				nxt_state <= S2;
				
			when S2 => 
			     nxt_state <= S2_WT;	
			when S2_WT =>
				if DONE_SHOWSEQ = '1' then -- Tras terminar de mostrar la secuencia, paso al siguiente estado
				   nxt_state <= S3; 
				end if;
				
			when S3 =>
				nxt_state <= S4; -- Activación de animación GO ANIMATION	
			when S3_WT =>
			    if DONE_WAITLED = '1' then
			         nxt_state <= S4;
			     end if;
				
					
			when S4 =>
				nxt_state <= S4_WT; -- Activación de las SLAVES INCHECK y TIMER
			when S4_WT => 
			     if (DONE_INCHECK = 1) OR (DONE_TIMER = '1') then
				   nxt_state <= S6; -- GAME OVER
				elsif DONE_INCHECK = 2 then
				   nxt_state <= S5; --INPUT SEQUENCE OK
				end if;
				
			when S5 =>
				nxt_state <= S5_WT; -- Activación de animación OK INPUT SEQUENCE
			when S5_WT =>
			     if DONE_WAITLED = '1' then
			         nxt_state <= S1;
			     end if;
				
			when S6 =>
				nxt_state <= S6_WT;
			when S6_WT =>
			     if DONE_WAITLED = '1' then
			         nxt_state <= S0_STBY;
			     end if;
				
			when others =>
				nxt_state <= S0_STBY; -- En caso de fallo, volver al estado de espera.	
		end case;	
	end process;
	
	
	--Salidas de cada estad
	output_decoder: process(cur_state) -- Esta parte es COMBINACIONAL. Solo cambia en caso de cambiar el estado
	begin
		-- Asegurar que el proceso sea combiancional
		-- General MASTER interface
		ROUND                   <= 0;
		OUT_MESSAGE             <= 0;
		 -- MASTER-SLAVE WAIT interface
        START_WAITLED           <= '0';
        PARAM_WAITLED           <= 0;
		-- MASTER-SLAVE SHOWSEQ interface
		START_SHOWSEQ           <= '0';
        PARAM_SHOWSEQ_seq       <= (others => 0);
        PARAM_SHOWSEQ_size      <= 0;
        -- MASTER-SLAVE INCHECK interface
        START_INCHECK           <= '0';
        PARAM_INCHECK_size      <= 0;
        PARAM_INCHECK_seq       <= (others => 0);
        -- MASTER-SLAVE TIMER interface
        START_TIMER             <= '0';
        PARAM_TIMER             <= 0;
        RST_COUNT               <= '0';
		SELECTOR                <= 'Z';
		case cur_state is
			when S0_STBY =>
				-- General MASTER interface
                ROUND                   <= 0;
                OUT_MESSAGE             <= 1; --START ANIMATION
                -- MASTER-SLAVE WAIT interface
                START_WAITLED           <= '0';
                PARAM_WAITLED           <= 0;
                -- MASTER-SLAVE SHOWSEQ interface
                START_SHOWSEQ           <= '0';
                PARAM_SHOWSEQ_seq  <= (others => 0);
                PARAM_SHOWSEQ_size      <= 0;
                -- MASTER-SLAVE INCHECK interface
                START_INCHECK           <= '0';
                PARAM_INCHECK_size      <= 0;
                PARAM_INCHECK_seq       <= (others => 0);
                -- MASTER-SLAVE TIMER interface
                START_TIMER             <= '0';
                PARAM_TIMER             <= 0;
                RST_COUNT               <= '0';
				SELECTOR                <= 'Z';
				
			when S0 =>
				-- General MASTER interface
                ROUND                   <= 0;
                OUT_MESSAGE             <= 0;
                -- MASTER-SLAVE WAIT interface
                START_WAITLED           <= '1';
                PARAM_WAITLED           <= TIME_WAIT;
                -- MASTER-SLAVE SHOWSEQ interface
                START_SHOWSEQ           <= '0';
                PARAM_SHOWSEQ_seq  <= (others => 0);
                PARAM_SHOWSEQ_size      <= 0;
                -- MASTER-SLAVE INCHECK interface
                START_INCHECK           <= '0';
                PARAM_INCHECK_size      <= 0;
                PARAM_INCHECK_seq       <= (others => 0);
                -- MASTER-SLAVE TIMER interface
                START_TIMER             <= '0';
                PARAM_TIMER             <= 0;
                RST_COUNT               <= '0';
			    SELECTOR                <= 'Z';
			when S0_WT =>
				-- General MASTER interface
                ROUND                   <= 0;
                OUT_MESSAGE             <= 0;
                -- MASTER-SLAVE WAIT interface
                START_WAITLED           <= '0';
                PARAM_WAITLED           <= 0;
                -- MASTER-SLAVE SHOWSEQ interface
                START_SHOWSEQ           <= '0';
                PARAM_SHOWSEQ_seq  <= (others => 0);
                PARAM_SHOWSEQ_size      <= 0;
                -- MASTER-SLAVE INCHECK interface
                START_INCHECK           <= '0';
                PARAM_INCHECK_size      <= 0;
                PARAM_INCHECK_seq       <= (others => 0);
                -- MASTER-SLAVE TIMER interface
                START_TIMER             <= '0';
                PARAM_TIMER             <= 0;
                RST_COUNT               <= '0';
                SELECTOR                <= 'Z';
                
			when S1 =>
				-- General MASTER interface
                ROUND                   <= 0;
                OUT_MESSAGE             <= 0;
                -- MASTER-SLAVE WAIT interface
                START_WAITLED           <= '0';
                PARAM_WAITLED           <= 0;
                -- MASTER-SLAVE SHOWSEQ interface
                START_SHOWSEQ           <= '0';
                PARAM_SHOWSEQ_seq  <= (others => 0);
                PARAM_SHOWSEQ_size      <= 0;
                -- MASTER-SLAVE INCHECK interface
                START_INCHECK           <= '0';
                PARAM_INCHECK_size      <= 0;
                PARAM_INCHECK_seq       <= (others => 0);
                -- MASTER-SLAVE TIMER interface
                START_TIMER             <= '0';
                PARAM_TIMER             <= 0;
                RST_COUNT               <= '0';
                SELECTOR                <= 'Z';
				
			when S2 =>
				-- General MASTER interface
                ROUND                   <= size;
                OUT_MESSAGE             <= 0;
                -- MASTER-SLAVE WAIT interface
                START_WAITLED           <= '0';
                PARAM_WAITLED           <= 0;
                -- MASTER-SLAVE SHOWSEQ interface
                START_SHOWSEQ           <= '1'; -- Se inicia el esclavo de muestra de la secuencia
                PARAM_SHOWSEQ_seq       <= game_sequence;
                PARAM_SHOWSEQ_size      <= size;
                -- MASTER-SLAVE INCHECK interface
                START_INCHECK           <= '0';
                PARAM_INCHECK_size      <= 0;
                PARAM_INCHECK_seq       <= (others => 0);
                -- MASTER-SLAVE TIMER interface
                START_TIMER             <= '0';
                PARAM_TIMER             <= 0;
                RST_COUNT               <= '0';
                SELECTOR                <= 'Z';
			
			when S2_WT =>
			    -- General MASTER interface
                ROUND                   <= size;
                OUT_MESSAGE             <= 0;
                 -- MASTER-SLAVE WAIT interface
                START_WAITLED           <= '0';
                PARAM_WAITLED           <= 0;
                -- MASTER-SLAVE SHOWSEQ interface
                START_SHOWSEQ           <= '0';
                PARAM_SHOWSEQ_seq       <= game_sequence;
                PARAM_SHOWSEQ_size      <= size;
                -- MASTER-SLAVE INCHECK interface
                START_INCHECK           <= '0';
                PARAM_INCHECK_size      <= 0;
                PARAM_INCHECK_seq       <= (others => 0);
                -- MASTER-SLAVE TIMER interface
                START_TIMER             <= '0';
                PARAM_TIMER             <= 0;
                RST_COUNT               <= '0';
                SELECTOR                <= '0';

			when S3 =>
				-- General MASTER interface
                ROUND                   <= size;
                OUT_MESSAGE             <= 2; -- GO ANIMATION
                -- MASTER-SLAVE WAIT interface
                START_WAITLED           <= '1';
                PARAM_WAITLED           <= TIME_WAIT;
                -- MASTER-SLAVE SHOWSEQ interface
                START_SHOWSEQ           <= '0';
                PARAM_SHOWSEQ_seq  <= (others => 0);
                PARAM_SHOWSEQ_size      <= 0;
                -- MASTER-SLAVE INCHECK interface
                START_INCHECK           <= '0';
                PARAM_INCHECK_size      <= 0;
                PARAM_INCHECK_seq       <= (others => 0);
                -- MASTER-SLAVE TIMER interface
                START_TIMER             <= '0';
                PARAM_TIMER             <= 0;
                RST_COUNT               <= '0';
                SELECTOR                <= 'Z';
            
            when S3_WT =>
                -- General MASTER interface
                ROUND                   <= size;
                OUT_MESSAGE             <= 2;
                 -- MASTER-SLAVE WAIT interface
                START_WAITLED           <= '0';
                PARAM_WAITLED           <= 0;
                -- MASTER-SLAVE SHOWSEQ interface
                START_SHOWSEQ           <= '0';
                PARAM_SHOWSEQ_seq  <= (others => 0);
                PARAM_SHOWSEQ_size      <= 0;
                -- MASTER-SLAVE INCHECK interface
                START_INCHECK           <= '0';
                PARAM_INCHECK_size      <= 0;
                PARAM_INCHECK_seq       <= (others => 0);
                -- MASTER-SLAVE TIMER interface
                START_TIMER             <= '0';
                PARAM_TIMER             <= 0;
                RST_COUNT               <= '0';
                SELECTOR                <= 'Z';
            	
			when S4 =>
				-- General MASTER interface
                ROUND                   <= size;
                OUT_MESSAGE             <= 0;
                -- MASTER-SLAVE WAIT interface
                START_WAITLED           <= '0';
                PARAM_WAITLED           <= 0;
                -- MASTER-SLAVE SHOWSEQ interface
                START_SHOWSEQ           <= '0';
                PARAM_SHOWSEQ_seq  <= (others => 0);
                PARAM_SHOWSEQ_size      <= 0;
                -- MASTER-SLAVE INCHECK interface
                START_INCHECK           <= '1';
                PARAM_INCHECK_size      <= size;
                PARAM_INCHECK_seq       <= game_sequence;
                -- MASTER-SLAVE TIMER interface
                START_TIMER             <= '1';
                PARAM_TIMER             <= size; --Según numero de rondas, varía el tiempo
                RST_COUNT               <= '0';
                SELECTOR                <= 'Z';
			
			when S4_WT =>
                -- General MASTER interface
                ROUND                   <= size;
                OUT_MESSAGE             <= 0;
                 -- MASTER-SLAVE WAIT interface
                START_WAITLED           <= '0';
                PARAM_WAITLED           <= 0;
                -- MASTER-SLAVE SHOWSEQ interface
                START_SHOWSEQ           <= '0';
                PARAM_SHOWSEQ_seq  <= (others => 0);
                PARAM_SHOWSEQ_size      <= 0;
                -- MASTER-SLAVE INCHECK interface
                START_INCHECK           <= '0';
                PARAM_INCHECK_size      <= size;
                PARAM_INCHECK_seq       <= game_sequence;
                -- MASTER-SLAVE TIMER interface
                START_TIMER             <= '0';
                PARAM_TIMER             <= size;
                RST_COUNT               <= '0';
                SELECTOR                <= '1';		
			
			when S5 =>
				-- General MASTER interface
                ROUND                   <= size;
                OUT_MESSAGE             <= 3; --OK INPUT ANIMATION
                -- MASTER-SLAVE WAIT interface
                START_WAITLED           <= '1'; 
                PARAM_WAITLED           <= TIME_WAIT;
                -- MASTER-SLAVE SHOWSEQ interface
                START_SHOWSEQ           <= '0';
                PARAM_SHOWSEQ_seq  <= (others => 0); 
                PARAM_SHOWSEQ_size      <= 0;
                -- MASTER-SLAVE INCHECK interface
                START_INCHECK           <= '0';
                PARAM_INCHECK_size      <= 0;
                PARAM_INCHECK_seq       <= (others => 0);
                -- MASTER-SLAVE TIMER interface
                START_TIMER             <= '0';
                PARAM_TIMER             <= 0;
                RST_COUNT               <= '1';
                SELECTOR                <= 'Z';
			
			when S5_WT =>
				-- General MASTER interface
                ROUND                   <= size;
                OUT_MESSAGE             <= 3;
                 -- MASTER-SLAVE WAIT interface
                START_WAITLED           <= '0';
                PARAM_WAITLED           <= 0;
                -- MASTER-SLAVE SHOWSEQ interface
                START_SHOWSEQ           <= '0';
                PARAM_SHOWSEQ_seq  <= (others => 0);
                PARAM_SHOWSEQ_size      <= 0;
                -- MASTER-SLAVE INCHECK interface
                START_INCHECK           <= '0';
                PARAM_INCHECK_size      <= 0;
                PARAM_INCHECK_seq       <= (others => 0);
                -- MASTER-SLAVE TIMER interface
                START_TIMER             <= '0';
                PARAM_TIMER             <= 0;
                RST_COUNT               <= '0';
                SELECTOR                <= 'Z';
			
			when S6 =>
				-- General MASTER interface
                ROUND                   <= size;
                OUT_MESSAGE             <= 4; -- GAME OVER ANIMATION
                -- MASTER-SLAVE WAIT interface
                START_WAITLED           <= '1';
                PARAM_WAITLED           <= TIME_WAIT;
                -- MASTER-SLAVE SHOWSEQ interface
                START_SHOWSEQ           <= '0';
                PARAM_SHOWSEQ_seq  <= (others => 0);
                PARAM_SHOWSEQ_size      <= 0;
                -- MASTER-SLAVE INCHECK interface
                START_INCHECK           <= '0';
                PARAM_INCHECK_size      <= 0;
                PARAM_INCHECK_seq       <= (others => 0);
                -- MASTER-SLAVE TIMER interface
                START_TIMER             <= '0';
                PARAM_TIMER             <= 0;
                RST_COUNT               <= '1';
                SELECTOR                <= 'Z';
			
			when S6_WT =>	
			    -- General MASTER interface
                ROUND                   <= 0;
                OUT_MESSAGE             <= 4;
                 -- MASTER-SLAVE WAIT interface
                START_WAITLED           <= '0';
                PARAM_WAITLED           <= 0;
                -- MASTER-SLAVE SHOWSEQ interface
                START_SHOWSEQ           <= '0';
                PARAM_SHOWSEQ_seq  <= (others => 0);
                PARAM_SHOWSEQ_size      <= 0;
                -- MASTER-SLAVE INCHECK interface
                START_INCHECK           <= '0';
                PARAM_INCHECK_size      <= 0;
                PARAM_INCHECK_seq       <= (others => 0);
                -- MASTER-SLAVE TIMER interface
                START_TIMER             <= '0';
                PARAM_TIMER             <= 0;
                RST_COUNT               <= '0';
                SELECTOR                <= 'Z';
                
			when others =>
				-- General MASTER interface
                ROUND                   <= 0;
                OUT_MESSAGE             <= 0;
                -- MASTER-SLAVE WAIT interface
                START_WAITLED           <= '0';
                PARAM_WAITLED           <= 0;
                -- MASTER-SLAVE SHOWSEQ interface
                START_SHOWSEQ           <= '0';
                PARAM_SHOWSEQ_seq  <= (others => 0);
                PARAM_SHOWSEQ_size      <= 0;
                -- MASTER-SLAVE INCHECK interface
                START_INCHECK           <= '0';
                PARAM_INCHECK_size      <= 0;
                PARAM_INCHECK_seq       <= (others => 0);
                -- MASTER-SLAVE TIMER interface
                START_TIMER             <= '0';
                PARAM_TIMER             <= 0;
                RST_COUNT               <= '0';
                SELECTOR                <= 'Z';
		end case;
	end process output_decoder;

end Behavioral;
