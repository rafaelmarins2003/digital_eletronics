-- implementa um somador BCD de 2-digitos S2 S1 S0 = A1 A0 + B1 B0
-- entradas: SW7-4 = A
--           SW3-0 = B
--           SW8 = Cin
-- saidas:   A é mostrado no display HEX5
--           B é mostrado no display HEX3
--           S1 S0 é mostrado no display HEX1 HEX0
--
-- O bcd7seg desta solucao (portas bcd/display, com CASE) foi renomeado para
-- bcd7seg_case para nao colidir com o bcd7seg da Parte 1.

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY part5 IS
	PORT ( SW : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
	       HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 : OUT STD_LOGIC_VECTOR(0 TO 6));
END part5;

ARCHITECTURE Behavior OF part5 IS
	COMPONENT bcd7seg_case
		PORT ( bcd     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		       display : OUT STD_LOGIC_VECTOR(0 TO 6));
	END COMPONENT;

	SIGNAL A, B : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL Cin  : STD_LOGIC;
	SIGNAL S0   : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL S1   : STD_LOGIC;
	SIGNAL C1   : STD_LOGIC;

	SIGNAL Z0 : STD_LOGIC_VECTOR(4 DOWNTO 0);   -- usado para soma BCD
	SIGNAL T0 : STD_LOGIC_VECTOR(4 DOWNTO 0);   -- usado para soma BCD
	SIGNAL d1 : STD_LOGIC_VECTOR(3 DOWNTO 0);   -- VHDL-93 nao aceita expressao no PORT MAP
BEGIN
	A <= SW(7 DOWNTO 4);
	B <= SW(3 DOWNTO 0);
	Cin <= SW(8);

	-- soma os dois digitos BCD mais baixos. Resultado possue 5 bits: C1,S0
	T0 <= ('0' & A) + ('0' & B) + Cin;
	PROCESS (T0)
	BEGIN
		IF (T0 > "01001") THEN
			Z0 <= "01010";   -- necessário para subtrair 10 para conseguir o
			C1 <= '1';       -- digito menos significativo
		ELSE
			Z0 <= "00000";   -- não é necessário subtrair algo quando soma <= 9
			C1 <= '0';
		END IF;
	END PROCESS;
	S0 <= T0 - Z0;   -- subtract 10 ou 0
	S1 <= C1;

	-- mostra nos displays de 7-seg
	digit3: bcd7seg_case PORT MAP (A, HEX5);
	digit2: bcd7seg_case PORT MAP (B, HEX3);
	d1 <= "000" & S1;
	digit1: bcd7seg_case PORT MAP (d1, HEX1);
	digit0: bcd7seg_case PORT MAP (S0(3 DOWNTO 0), HEX0);

	HEX4 <= "1111111";
	HEX2 <= "1111111";
END Behavior;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY bcd7seg_case IS
	PORT ( bcd     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
	       display : OUT STD_LOGIC_VECTOR(0 TO 6));
END bcd7seg_case;

ARCHITECTURE Behavior OF bcd7seg_case IS
BEGIN
	--
	--       0
	--      ---
	--     |   |
	--    5|   |1
	--     | 6 |
	--      ---
	--     |   |
	--    4|   |2
	--     |   |
	--      ---
	--       3
	--
	PROCESS (bcd)
	BEGIN
		CASE bcd IS
			WHEN "0000" => display <= "0000001";
			WHEN "0001" => display <= "1001111";
			WHEN "0010" => display <= "0010010";
			WHEN "0011" => display <= "0000110";
			WHEN "0100" => display <= "1001100";
			WHEN "0101" => display <= "0100100";
			WHEN "0110" => display <= "0100000";
			WHEN "0111" => display <= "0001111";
			WHEN "1000" => display <= "0000000";
			WHEN "1001" => display <= "0000100";
			WHEN OTHERS => display <= "1111111";
		END CASE;
	END PROCESS;
END Behavior;
