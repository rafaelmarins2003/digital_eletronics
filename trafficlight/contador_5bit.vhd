-- Contador de 5 bits (0 a 31) com reset sincrono ativo em alto.
-- E o bloco "counter" da Parte 2: conta os segundos (pulsos de clk_1s) que a
-- maquina de estados do semaforo usa para decidir as transicoes.
-- O contador_4bit das praticas anteriores nao serve aqui: so vai ate 15
-- (o ciclo do semaforo precisa chegar em 21) e nao tem entrada de reset.
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY contador_5bit IS
	PORT (
		clk   : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		q     : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
	);
END contador_5bit;

ARCHITECTURE Behavior OF contador_5bit IS
	SIGNAL contagem : UNSIGNED(4 DOWNTO 0) := (OTHERS => '0');
BEGIN
	PROCESS (clk)
	BEGIN
		IF (clk'EVENT AND clk = '1') THEN
			-- reset sincrono: a contagem 21 dura um periodo inteiro de clk
			-- antes de voltar para 0, como na forma de onda do roteiro.
			IF (reset = '1') THEN
				contagem <= (OTHERS => '0');
			ELSE
				contagem <= contagem + 1;
			END IF;
		END IF;
	END PROCESS;

	q <= STD_LOGIC_VECTOR(contagem);
END Behavior;
