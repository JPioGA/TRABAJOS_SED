----------------------------------------------------------------------------------
-- ENTIDAD TOP DEL JUEGO COMPLETO
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity DESCIFRA_EL_CODIGO_TOP is
    port (  CLK100MHZ   : in std_logic;
            CPU_RESETN  : in std_logic;
            BTN         : in std_logic_vector(4 downto 0);
            anode       : out std_logic_vector(7 downto 0);
            segment     : out std_logic_vector(6 downto 0);
            JA          : out std_logic_vector(3 downto 0)
    
    );
end DESCIFRA_EL_CODIGO_TOP;

architecture STRUCTURAL of DESCIFRA_EL_CODIGO_TOP is
    -- COMPONENTES DEL SISTEMA GENERAL
    component BOTON_TOP is
        port(
            Button_in	:in  std_logic_vector(4 downto 0);
            Button_out  :out std_logic_vector(4 downto 0);
            CLK		    :in  std_logic);
    end component;
    
    component FSM_TOP is
        port (  CLK : in std_logic;
                RST_N : in std_logic;
                BUTTON   : in std_logic_vector(4 downto 0); -- ( 0 OK - 1 UP -  2 DOWN - 3 LEFT -  4 RIGHT)
                LED      : out std_logic_vector(3 downto 0); -- 
                ATTEMPS : out natural range 0 to 9;
                OUT_MESSAGE : out std_logic_vector(2 downto 0));
    end component;
    
    component VISUALIZER_TOP is
        port (  CLK : in std_logic;
                round      : in natural range 0 to 99;
                selector   : std_logic_vector(2 downto 0);
                segments   : out std_logic_vector(6 downto 0);
                anode      : out std_logic_vector(7 downto 0));
                --ATTEMPS : in natural range 0 to 9;
                --OUT_MESSAGE : in std_logic_vector(2 downto 0));
    end component;
    
    -- SEÑALES DE INTERCONEXIÓN ENTRE BLOQUES
    signal sig_botones  : std_logic_vector(4 downto 0);
    signal sig_intentos : natural range 0 to 9;
    signal sig_mensajes : std_logic_vector(2 downto 0);
    --signal sig_mensajes : natural range 0 to 4;
    
begin
    inst_botones: BOTON_TOP
        port map(   CLK => CLK100MHZ,
                    Button_in => BTN,
                    Button_out => sig_botones);
    
    inst_fsm: FSM_TOP
        port map(   CLK => CLK100MHZ,
                    RST_N => CPU_RESETN,
                    BUTTON => sig_botones,
                    LED => JA,
                    ATTEMPS => sig_intentos,
                    OUT_MESSAGE => sig_mensajes);
                    
    inst_visualizer: VISUALIZER_TOP
        port map(   CLK=> CLK100MHZ,
                    round => sig_intentos,
                    selector => sig_mensajes,
                    segments => segment,
                    anode => anode);
                    --ATTEMPS => sig_intentos,
                    --OUT_MESSAGE => sig_mensajes);
end STRUCTURAL;
