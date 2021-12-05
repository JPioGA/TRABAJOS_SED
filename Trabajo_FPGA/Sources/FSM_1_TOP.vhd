-- Máquina de estado de control de las fases del juego Simón Dice.
-- Compuesta por:
-- 		FSM_1_MASTER: que irá evolucionando según las interacción con el ususario
--		FSM_1_SLAVE: temporizador que se dispará cada vez que se pase por el estado S3 de la master (Límite de tiempo de introducción de la secuencia por el usuario)



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FSM_1_TOP is
  port (
    CLK     : in  std_logic;
    RST_N   : in  std_logic;
	
    EXECUTE : in  std_logic;
    LEDS    : out std_logic_vector(1 downto 0)
  );
end FSM_1_TOP;



architecture structural of TOP is

  component MASTER_FSM is
    port (
      CLK     : in  std_logic;
      RST_N   : in  std_logic;
      EXECUTE : in  std_logic;
      DONE    : in  std_logic;
      START   : out std_logic;
      DELAY   : out unsigned(7 downto 0);
      
    );
  end component;

  component SLAVE_FSM is
    port (
      CLK     : in  std_logic;
      RST_N   : in  std_logic;
      START   : in  std_logic;
      DELAY   : in  unsigned(7 downto 0);
      DONE    : out std_logic
    );
  end component;

  signal start, done : std_logic;
  signal delay : unsigned(7 downto 0);

begin
  control: FSM_1_MASTER
    port map (
      CLK     => CLK,
      RST_N   => RST_N,
      
    );

  timer: FSM_1_SLAVE
    port map (
      CLK     => CLK,
      RST_N   => RST_N,
      
    );
end structural;




