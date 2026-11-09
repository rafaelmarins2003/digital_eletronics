-- Somador BCD de 1 digito S1 S0 = X + Y + cin - versao alternativa.
-- Usa o metodo classico de correcao "soma 6": quando a soma binaria passa de 9,
-- um segundo somador de 4 bits soma 0110 para ajustar o digito das unidades,
-- e o digito das dezenas vira 1.
-- Entradas: SW7-4 = X, SW3-0 = Y, SW8 = cin
-- Saidas:   X em HEX3, Y em HEX2 (a DE0 nao tem HEX5/HEX4),
--           S1 S0 em HEX1 HEX0,
--           LEDG4-0 = soma binaria (cout & S), LEDG9 = erro (X ou Y > 9)

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY part4_alt IS
	PORT (
		SW                     : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		LEDG                   : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
		HEX3, HEX2, HEX1, HEX0 : OUT STD_LOGIC_VECTOR(0 TO 6)
	);
END part4_alt;

ARCHITECTURE Structure OF part4_alt IS
	COMPONENT adder4_alt
		PORT (
			a, b : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			cin  : IN STD_LOGIC;
			s    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			cout : OUT STD_LOGIC
		);
	END COMPONENT;
	-- bcd7seg_alt definido em part1_alt.vhd
	COMPONENT bcd7seg_alt
		PORT (
			B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			H : OUT STD_LOGIC_VECTOR(0 TO 6)
		);
	END COMPONENT;
	SIGNAL X, Y, S, corr, S0, d1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL cin, cout, k, cout2  : STD_LOGIC;
BEGIN
	X <= SW(7 DOWNTO 4);
	Y <= SW(3 DOWNTO 0);
	cin <= SW(8);

	-- 1o somador: soma binaria X + Y + cin (0 a 19 para entradas validas)
	add1 : adder4_alt PORT MAP (X, Y, cin, S, cout);
	LEDG(4 DOWNTO 0) <= cout & S;

	-- k = 1 quando a soma binaria passa de 9: houve carry (16-19) ou S > 9 (10-15)
	k <= '1' WHEN cout = '1' OR unsigned(S) > 9 ELSE '0';

	-- 2o somador: S + 6 corrige o digito das unidades; o carry dele e descartado
	corr <= "0110" WHEN k = '1' ELSE "0000";
	add2 : adder4_alt PORT MAP (S, corr, '0', S0, cout2);

	d1 <= "000" & k;
	H1 : bcd7seg_alt PORT MAP (d1, HEX1);
	H0 : bcd7seg_alt PORT MAP (S0, HEX0);

	-- entradas nos displays e deteccao de digito BCD invalido
	H3 : bcd7seg_alt PORT MAP (X, HEX3);
	H2 : bcd7seg_alt PORT MAP (Y, HEX2);
	LEDG(9) <= '1' WHEN unsigned(X) > 9 OR unsigned(Y) > 9 ELSE '0';
	LEDG(8 DOWNTO 5) <= "0000";
END Structure;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Somador ripple-carry de 4 bits com o fa_alt da Parte 3 (part3_alt.vhd).
ENTITY adder4_alt IS
	PORT (
		a, b : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		cin  : IN STD_LOGIC;
		s    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		cout : OUT STD_LOGIC
	);
END adder4_alt;

ARCHITECTURE Structure OF adder4_alt IS
	COMPONENT fa_alt
		PORT (
			a, b, ci : IN STD_LOGIC;
			s, co    : OUT STD_LOGIC
		);
	END COMPONENT;
	SIGNAL C : STD_LOGIC_VECTOR(4 DOWNTO 0);
BEGIN
	C(0) <= cin;
	adders : FOR i IN 0 TO 3 GENERATE
		fa_i : fa_alt PORT MAP (a(i), b(i), C(i), s(i), C(i + 1));
	END GENERATE;
	cout <= C(4);
END Structure;
