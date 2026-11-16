-- Semaforo com contador interno - Parte 2 (topo da simulacao).
-- Liga o contador de segundos a maquina de estados, como no diagrama do
-- roteiro: o contador avanca a cada pulso de clk_1s e a maquina de estados
-- (no clock rapido) zera o contador ao fim do ciclo via reset_counter.
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY trafficlight IS
	PORT (
		clk_1s      : IN STD_LOGIC;
		reset       : IN STD_LOGIC;
		clock       : IN STD_LOGIC;
		counter     : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		red         : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		yellow      : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		green       : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		rst_counter : OUT STD_LOGIC
	);
END trafficlight;

ARCHITECTURE Structure OF trafficlight IS
	COMPONENT contador_5bit
		PORT (
			clk   : IN STD_LOGIC;
			reset : IN STD_LOGIC;
			q     : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT semaforo
		PORT (
			reset         : IN STD_LOGIC;
			clock         : IN STD_LOGIC;
			counter       : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			red           : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			yellow        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			green         : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			reset_counter : OUT STD_LOGIC
		);
	END COMPONENT;
	-- q: contagem de segundos; zera: pedido de reset vindo da maquina de estados
	SIGNAL q    : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL zera : STD_LOGIC;
BEGIN
	inst : contador_5bit
		PORT MAP (clk => clk_1s, reset => zera, q => q);

	inst2 : semaforo
		PORT MAP (
			reset         => reset,
			clock         => clock,
			counter       => q,
			red           => red,
			yellow        => yellow,
			green         => green,
			reset_counter => zera
		);

	counter     <= q;
	rst_counter <= zera;
END Structure;
