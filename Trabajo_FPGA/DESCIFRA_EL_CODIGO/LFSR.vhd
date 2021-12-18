----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.tipos_especiales.ALL;

entity LFSR is
    generic( WIDTH : positive := 10; -- Elementos del registro de desplazamiento (Aplicar los TRAPS en 10 y 7)
             UP    : std_logic_vector(3 downto 0) := "1000";
             DOWN  : std_logic_vector(3 downto 0) := "0100";
             LEFT  : std_logic_vector(3 downto 0) := "0010";
             RIGHT : std_logic_vector(3 downto 0) := "0001");
             
    port (  CLK         : in std_logic;
            RST_N       : in std_logic;
            NEW_SEQ     : out std_logic;   -- Señal de salida que indica cuando se ha generado una nueva secuencia ()
            RETURN_LFSR : out SEQUENCE_T); -- Señal de reset asíncrona. OJO! Nunca reinicial el valor del registro de estados con TODO 0. Se bloquea.
end LFSR;

architecture Behavioral of LFSR is
    constant SEED       : std_logic_vector(1 to WIDTH) := "1010110101";--(1 => '1', others => '0'); --Semilla inicial del registro
    signal cur_reg      : std_logic_vector(1 to WIDTH) := SEED; -- Registro de desplazamiento actual
    signal nxt_reg      : std_logic_vector(1 to WIDTH); -- Registro auxiliar para generar el siguiente estad del registro
    signal feedback     : std_logic; -- Valor asignado al inicio del registro de desplazamiento.
    signal aux_return   : SEQUENCE_T;
    signal aux_val      : std_logic_vector(0 to 1); 
begin
    -- Proceso SECUENCIAL: El registro de desplazamiento está continuamente actualizandose con los ciclos de reloj
    register_updater: process(CLK, RST_N)
    begin
            if RST_N = '0' then
                cur_reg <= SEED; -- Actualizo con la semilla inicial
            elsif rising_edge(CLK) then -- elsif (CLK = '1' AND CLK'event)
                cur_reg <= nxt_reg; -- Actualización del nuevo registro
            end if;
    end process;
    
    -- Actualización del registro de despalamiento
    feedback <= cur_reg(10) XOR cur_reg(7); --Cálculo del nuevo valor de la entrada al registro
    nxt_reg <= feedback & cur_reg(1 to WIDTH - 1); -- Creación del nuevo estado del registro
    aux_val <= cur_reg(WIDTH - 1 to WIDTH);
    
    
    -- Proceso SECUENCIAL: Se va creando una secuencia de salida en función de los valores generados aleatoriamente.
    output_updater: process(CLK, RST_N)
        variable count      : std_logic_vector(2 downto 0) := "100"; -- Valor inicial de la cuenta de elementos que hay en la secuencia que se está creando
    begin
        if RST_N = '0' then
            aux_return <= ((others => '0'), (others => '0'), (others => '0'), (others => '0')); -- Salida nula si RST_N
        elsif rising_edge(CLK) then -- Cada ciclo de reloj compruebo si el nuevo valor de aux_val es distinto que los que ya están en la secuencia
            
        end if;
    end process;
    
    RETURN_LFSR <= aux_return;

end Behavioral;
