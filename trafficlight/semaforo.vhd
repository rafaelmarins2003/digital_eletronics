-- Semaforo de 3 vias (A, B, C) como maquina de estados de Moore - Parte 1.
-- Segue a estrutura do VHDL que o State Machine Editor do Quartus gera
-- (diagrama em semaforo.smf): reset sincrono ativo em alto e, se a condicao de
-- transicao nao for satisfeita, a maquina permanece no estado atual.
--
-- Bit 2 = semaforo A, bit 1 = semaforo B, bit 0 = semaforo C.
-- A entrada counter conta segundos; as transicoes ocorrem em 5, 7, 12, 14,
-- 19 e 21. Ao voltar para o state1 com counter = 21, reset_counter zera o
-- contador e o ciclo recomeca.
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY semaforo IS
	PORT (
		reset         : IN STD_LOGIC := '0';
		clock         : IN STD_LOGIC;
		counter       : IN STD_LOGIC_VECTOR(4 DOWNTO 0) := "00000";
		red           : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		yellow        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		green         : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		reset_counter : OUT STD_LOGIC
	);
END semaforo;

ARCHITECTURE BEHAVIOR OF semaforo IS
	TYPE type_fstate IS (state1, state2, state3, state4, state5, state6);
	SIGNAL fstate     : type_fstate;
	SIGNAL reg_fstate : type_fstate;
BEGIN
	-- registrador de estado
	PROCESS (clock, reg_fstate)
	BEGIN
		IF (clock = '1' AND clock'EVENT) THEN
			fstate <= reg_fstate;
		END IF;
	END PROCESS;

	-- proximo estado e saidas
	PROCESS (fstate, reset, counter)
	BEGIN
		IF (reset = '1') THEN
			reg_fstate <= state1;
			red <= "000";
			yellow <= "000";
			green <= "000";
			reset_counter <= '0';
		ELSE
			red <= "000";
			yellow <= "000";
			green <= "000";
			reset_counter <= '0';
			CASE fstate IS
				WHEN state1 =>  -- A verde
					IF (counter = "00101") THEN  -- counter == 5
						reg_fstate <= state2;
					ELSE
						reg_fstate <= state1;
					END IF;

					IF (counter = "10101") THEN  -- counter == 21: fim do ciclo
						reset_counter <= '1';
					ELSE
						reset_counter <= '0';
					END IF;

					red <= "011";
					yellow <= "000";
					green <= "100";
				WHEN state2 =>  -- A amarelo
					IF (counter = "00111") THEN  -- counter == 7
						reg_fstate <= state3;
					ELSE
						reg_fstate <= state2;
					END IF;

					red <= "011";
					yellow <= "100";
					green <= "000";
				WHEN state3 =>  -- B verde
					IF (counter = "01100") THEN  -- counter == 12
						reg_fstate <= state4;
					ELSE
						reg_fstate <= state3;
					END IF;

					red <= "101";
					yellow <= "000";
					green <= "010";
				WHEN state4 =>  -- B amarelo
					IF (counter = "01110") THEN  -- counter == 14
						reg_fstate <= state5;
					ELSE
						reg_fstate <= state4;
					END IF;

					red <= "101";
					yellow <= "010";
					green <= "000";
				WHEN state5 =>  -- C verde
					IF (counter = "10011") THEN  -- counter == 19
						reg_fstate <= state6;
					ELSE
						reg_fstate <= state5;
					END IF;

					red <= "110";
					yellow <= "000";
					green <= "001";
				WHEN state6 =>  -- C amarelo
					IF (counter = "10101") THEN  -- counter == 21
						reg_fstate <= state1;
					ELSE
						reg_fstate <= state6;
					END IF;

					red <= "110";
					yellow <= "001";
					green <= "000";
				WHEN OTHERS =>
					reg_fstate <= state1;
			END CASE;
		END IF;
	END PROCESS;
END BEHAVIOR;
