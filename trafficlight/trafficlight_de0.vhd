-- Semaforo na placa DE0 (topo do projeto para gravar na FPGA).
-- Gera o clk_1s a partir do CLOCK_50, inverte o botao de reset (ativo em 0)
-- e leva as 9 luzes para os LEDs da protoboard no conector J4 (GPIO 0),
-- conforme docs/av3/traffic_light/img.jpeg. LEDG repete as mesmas luzes
-- nos LEDs da propria placa.
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY trafficlight_de0 IS
	GENERIC (
		-- ciclos de CLOCK_50 em meio periodo de clk_1s (50 MHz -> 1 Hz)
		MEIO_PERIODO : NATURAL := 25000000
	);
	PORT (
		CLOCK_50  : IN STD_LOGIC;
		BUTTON2   : IN STD_LOGIC;
		-- semaforo 1 (A): vermelho, amarelo, verde
		GPIO0_D2, GPIO0_D4, GPIO0_D6    : OUT STD_LOGIC;
		-- semaforo 2 (B)
		GPIO0_D12, GPIO0_D18, GPIO0_D20 : OUT STD_LOGIC;
		-- semaforo 3 (C)
		GPIO0_D22, GPIO0_D24, GPIO0_D26 : OUT STD_LOGIC;
		LEDG      : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
	);
END trafficlight_de0;

ARCHITECTURE Structure OF trafficlight_de0 IS
	COMPONENT trafficlight
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
	END COMPONENT;
	SIGNAL divisor            : NATURAL RANGE 0 TO MEIO_PERIODO - 1 := 0;
	SIGNAL clk_1s             : STD_LOGIC := '0';
	SIGNAL reset              : STD_LOGIC;
	SIGNAL red, yellow, green : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN
	-- Divisor de clock: inverte clk_1s a cada MEIO_PERIODO ciclos.
	PROCESS (CLOCK_50)
	BEGIN
		IF (CLOCK_50'EVENT AND CLOCK_50 = '1') THEN
			IF (divisor = MEIO_PERIODO - 1) THEN
				divisor <= 0;
				clk_1s  <= NOT clk_1s;
			ELSE
				divisor <= divisor + 1;
			END IF;
		END IF;
	END PROCESS;

	reset <= NOT BUTTON2;

	inst : trafficlight
		PORT MAP (
			clk_1s      => clk_1s,
			reset       => reset,
			clock       => CLOCK_50,
			counter     => OPEN,
			red         => red,
			yellow      => yellow,
			green       => green,
			rst_counter => OPEN
		);

	-- bit 2 = semaforo 1 (A), bit 1 = semaforo 2 (B), bit 0 = semaforo 3 (C)
	GPIO0_D2  <= red(2);
	GPIO0_D4  <= yellow(2);
	GPIO0_D6  <= green(2);
	GPIO0_D12 <= red(1);
	GPIO0_D18 <= yellow(1);
	GPIO0_D20 <= green(1);
	GPIO0_D22 <= red(0);
	GPIO0_D24 <= yellow(0);
	GPIO0_D26 <= green(0);

	LEDG <= green(0) & yellow(0) & red(0)
	      & green(1) & yellow(1) & red(1)
	      & green(2) & yellow(2) & red(2);
END Structure;
