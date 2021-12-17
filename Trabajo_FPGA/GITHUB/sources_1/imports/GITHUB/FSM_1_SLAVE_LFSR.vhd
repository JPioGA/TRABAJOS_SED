----------------------------------------------------------------------------------
-- FSM_1_SLAE_LFSR
-- Componenete encargado de la generación de números aleatorios de 1 a 4 para la ejecución del jugo.
-- Este compoente está basado en un Linear Feedback Shift Register (LFSR). Se genera una serie de bits
-- de forma pseudo-aleatoria. 
-- En este caso se tomarán bits del registro de 2 en 2, de forma que representan números de 0 a 3 (00 01 10 11)
-- El valor de retorno del componente será este valor en forma de entero + 1.
-- La idea es que este componente esté continuamente actualizando el registro de desplazamiento, generenado el valor
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.tipos_esp.ALL;

entity FSM_1_SLAVE_LFSR is
    generic(
        WIDTH : positive := 10 -- Elementos del registro de desplazamiento (Aplicar los TRAPS en 10 y 7)
    );
    port (
        CLK         : in std_logic; -- Señal de reloj
        RST_N       : in std_logic; -- Señal de reset asíncrona. OJO! Nunca reinicial el valor del registro de estados con TODO 0. Se bloquea. 
        --START_LFSR  : in std_logic;  -- Señal de petición de un nuevo valor pseudo-aleatorio
        --DONE_LFSR   : out std_logic; -- Señal de fin de devolución de un par de bit pseudo-aleatorios
        RETURN_LFSR : out LED_T     -- Valor de 1 a 4 devuelto por el componente
    );
end FSM_1_SLAVE_LFSR;

architecture Behavioral of FSM_1_SLAVE_LFSR is
    constant SEED   : std_logic_vector(1 to WIDTH) := "1010110101";--(1 => '1', others => '0'); --Semilla inicial del registro
    signal cur_reg  : std_logic_vector(1 to WIDTH) := SEED; -- Registro de desplazamiento actual
    signal nxt_reg  : std_logic_vector(1 to WIDTH); -- Registro auxiliar para generar el siguiente estad del registro
    signal feedback : std_logic; -- Valor asignado al inicio del registro de desplazamiento.
    signal aux_val : LED_T;
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
    
    aux_val <= to_integer(unsigned(cur_reg(WIDTH - 1 to WIDTH))); -- Se generan valores de 0 a 3
    RETURN_LFSR <= aux_val + 1; --Actualizo valor de la salida con un valor de 1 a 4
    feedback <= cur_reg(10) XOR cur_reg(7); --Cálculo del nuevo valor de la entrada al registro
    nxt_reg <= feedback & cur_reg(1 to WIDTH - 1); -- Creación del nuevo estado del registro
    
end Behavioral;
