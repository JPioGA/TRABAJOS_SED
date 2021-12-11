package tipos_esp is
type natural_vector is array (0 to 98) of natural;
 type STATE_T is (
	    S2_STBY,  -- S2_STBY: Estado de STANDBY. Cuando la máquian de estados no está en uso.
		S2_0,	-- S2_0: COMPROBACIÓN de valor de la secuancia a encender.
		S2_1,   -- S2_1: Disparo de WAITLED para LED 1 ON
		S2_1WT, -- S2_1WT: Mantenimiento de LED 1 ON
		S2_2,   -- S2_2: Disparo de WAITLED para LED 2 ON
		S2_2WT, -- S2_2WT: Mantenimiento de LED 2 ON
		S2_3,	-- S2_3: Disparo de WAITLED para LED 3 ON
		S2_3WT, -- S2_3WT: Mantenimiento de LED 3 ON
		S2_4,   -- S2_4: Disparo de WAITLED para LED 4 ON
		S2_4WT, -- S2_4WT: Mantenimiento de LED 4 ON
		S2_5,   -- S2_5: COMPROBACIÓN si se ha completado la secuencai
		S2_6	-- S2_6: END SHOW SEQUENCE.
	);
end tipos_esp;

package body tipos_esp is
end tipos_esp;