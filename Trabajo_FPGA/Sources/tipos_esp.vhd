package tipos_esp is
     subtype MESSAGE_T is natural range 0 to 5; -- Subtipo creado para ahorrar recursos, cada numero represente un mensaje a mostrar por los displays
     subtype BUTTON_T is natural range 0 to 4; -- 1: UP_BUTTON	2: DOWN_BUTTON	3: RIGHT_BUTTON	4: LEFT_BUTTON	  (El subtipo está hecho para ahorrar recursos en la síntesis)
     subtype LED_T is natural range 0 to 4; -- Subtipo para indicar los LEDS
     type natural_vector is array (0 to 98) of BUTTON_T;
     type STATE_MASTER_T is (
            S0_STBY,-- S0_STBY: ESPERA INICIO DE JUEGO. Hasta que no se pulse OK_BUTTON no se pasa al estado S0.
            S0,		-- S0: START GAME. Se muestra una animación que indica el inicio del juego.
            S0_WT,  -- S0_WT: Estado de espera de muestra del mensaje GO ANIMATION
            S1,		-- S1: ADD VALUE. Adición de un nuevo valor a la secuencia
            S2,		-- S2: SHOW SEQUENCE. Activación de la FSM SLAVE SHOWSEQ. Muestra por los LEDS la secuencia que tendrá que introducir el jugador.
            S2_WT,  -- S2_WT: Estado de espera hasta la terminación de la muestra de la secuencia por SHOWSEQ
            S3,     -- S3: GO ANIMATION: Animación que indica que el jugador comience a introducir sus inputs.
            S3_WT,  -- S3_WT :Estado de espera de muestra del mensaje GO ANIMATION
            S4,		-- S3: START INCHECK Y TIMER. Disparo del temporizador tras mostrar la secuencia, Y activación de la comprobación de los inputs del jugador.
            S4_WT,  -- S4_WT: Estado de espera en el que se realiza la interacción con el jugador
            S5,		-- S4: INPUTS OK: El jugador ha introducido todos los valores correctamente.
            S5_WT,  -- S5_WT: Estado de espera de muestra del mensaje OK INPUT SEQUENCE
            S6,		-- S5: GAME OVER. El jugador ha perdido por fin del tiempo o por error en el input. Se muestra animación de fin de juego
            S6_WT   -- S6_WT: Estado de espera de muestra del mensaje GAME OVER
        );
     type STATE_SHOWSEQ_T is (
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
        type STATE_INCHECK_T is (
            S3_STBY,  -- S3_STBY: Estado de STANDBY. Cuando la máquian de estados no está en uso.
            S3_0,	-- S3_0: ESPERA al INPUT. Hasta que no se pulse un botón no se comprueba si es correcto o no.
            S3_1,   -- S2_1: Disparo de WAITLED para LED 1 ON
            S3_1WT, -- S2_1WT: Mantenimiento de LED 1 ON
            S3_2,   -- S2_2: Disparo de WAITLED para LED 2 ON
            S3_2WT, -- S2_2WT: Mantenimiento de LED 2 ON
            S3_3,	-- S2_3: Disparo de WAITLED para LED 3 ON
            S3_3WT, -- S2_3WT: Mantenimiento de LED 3 ON
            S3_4,   -- S2_4: Disparo de WAITLED para LED 4 ON
            S3_4WT, -- S2_4WT: Mantenimiento de LED 4 ON
            S3_5,   -- S3_5: COMPROBACIÓN del INPUT
            S3_6,	-- S3_6: INPUTS OK: El jugador ha introducido todos los valores correctamente.
            S3_7	-- S3_7: GAME OVER. El jugador ha perdido por fin del tiempo o por error en el input. Se muestra animación de fin de juego
        );
end tipos_esp;

package body tipos_esp is
end tipos_esp;