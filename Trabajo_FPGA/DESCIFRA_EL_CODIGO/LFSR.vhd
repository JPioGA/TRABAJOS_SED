----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.tipos_especiales.ALL;

entity LFSR is
    generic( WIDTH : positive := 10); -- Elementos del registro de desplazamiento (Aplicar los TRAPS en 10 y 7)
             
    port (  CLK         : in std_logic;
            RST_N       : in std_logic;
            NEW_SEQ     : out std_logic;   -- Señal de salida que indica cuando se ha generado una nueva secuencia ()
            RETURN_LFSR : out SEQUENCE2_T); -- Señal de reset asíncrona. OJO! Nunca reinicial el valor del registro de estados con TODO 0. Se bloquea.
end LFSR;

architecture Behavioral of LFSR is
    constant SEED       : std_logic_vector(1 to WIDTH) := "1010110101";--(1 => '1', others => '0'); --Semilla inicial del registro
    signal cur_reg      : std_logic_vector(1 to WIDTH) := SEED; -- Registro de desplazamiento actual
    signal nxt_reg      : std_logic_vector(1 to WIDTH); -- Registro auxiliar para generar el siguiente estad del registro
    signal feedback     : std_logic; -- Valor asignado al inicio del registro de desplazamiento.
    signal aux_return   : SEQUENCE2_T;
    signal aux_val      : std_logic_vector(0 to 1);
    signal cur_size     : natural range 0 to 4 := 4;
	signal nxt_size     : natural range 0 to 4;
begin
    -- Proceso SECUENCIAL: El registro de desplazamiento está continuamente actualizandose con los ciclos de reloj
    register_updater: process(CLK, RST_N)
    begin
            if RST_N = '0' then
                cur_reg <= SEED; -- Actualizo con la semilla inicial
                cur_size <= 4;
            elsif rising_edge(CLK) then -- elsif (CLK = '1' AND CLK'event)
                cur_reg <= nxt_reg; -- Actualización del nuevo registro
                cur_size <= nxt_size;
            end if;
    end process;
    
    -- Actualización del registro de despalamiento
    feedback <= cur_reg(10) XOR cur_reg(7); --Cálculo del nuevo valor de la entrada al registro
    nxt_reg <= feedback & cur_reg(1 to WIDTH - 1); -- Creación del nuevo estado del registro
    aux_val <= cur_reg(WIDTH - 1 to WIDTH); -- Tomo los 2 ultimos elementos del registro de desplazamiento
    
    
    -- Proceso SECUENCIAL: Se va creando una secuencia de salida en función de los valores generados aleatoriamente.
    output_updater: process(cur_size, CLK, RST_N)
    begin
        if RST_N = '0' then
            aux_return <= ((others => '0'), (others => '0'), (others => '0'), (others => '0')); -- Salida nula si RST_N
        elsif rising_edge(CLK) then -- Cada ciclo de reloj compruebo si el nuevo valor de aux_val es distinto que los que ya están en la secuencia
            nxt_size <= cur_size;
            RETURN_LFSR <= ((others => '0'), (others => '0'), (others => '0'), (others => '0'));
            NEW_SEQ <= '0';
            
            case cur_size is
                when 4 => -- Ningun elemento de la secuencia rellenado.
                    aux_return(cur_size-1) <= aux_val;
                    nxt_size <= 3;
                when 3 => -- 1 Elemento de la secuencia rellenado. Buscando el segundo
                    if (aux_val /= aux_return(cur_size-1)) then
                        aux_return(cur_size-2) <= aux_val;
                        nxt_size <= 2;
                    end if;
                    
                when 2 => -- 2 Elementos de la secuencia rellenado. Buscando el tercero
                    if (aux_val /= aux_return(cur_size-1)) OR (aux_val /= aux_return(cur_size-2)) then
                        aux_return(cur_size-3) <= aux_val;
                        nxt_size <= 1;
                    end if;
                    
                when 1 => -- 3 Elementos de la secuencia rellenado. Buscando el cuarto
                    if (aux_val /= aux_return(cur_size-1)) OR (aux_val /= aux_return(cur_size-2)) OR (aux_val /= aux_return(cur_size-3)) then
                        aux_return(cur_size-4) <= aux_val;
                        nxt_size <= 0;
                    end if;
                when 0 => -- SECEUNCIA RELLENADA. SACO EL RESULTADO Y VUELTA A EMPEZAR
                    RETURN_LFSR <= aux_return;
                    NEW_SEQ <= '1';
                    nxt_size <= 4; -- Vuleta a empezar
            end case;
        end if;
    end process;

end Behavioral;
