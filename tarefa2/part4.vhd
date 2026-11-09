-- Somador BCD de 1-digito S1 S0 = X + Y + Cin
-- entradas: SW7-4 = X
--           SW3-0 = Y
--           SW8 = Cin
-- Saidas:   X é mostrado no HEX5
--           Y é mostrado no HEX3
--           S1 S0 é mostrado no HEX1 HEX0
--
-- fa (part3.vhd), mux2to1_4bit (part2.vhd) e bcd7seg (part1.vhd) sao
-- reaproveitados das partes anteriores. O "part2" desta solucao (portas V, z, M)
-- foi renomeado para part2_conv para nao colidir com a entity part2 da Parte 2.

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY part4 IS
	PORT ( SW   : IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
	       LEDG : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
	       HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 : OUT STD_LOGIC_VECTOR(0 TO 6));
END part4;

ARCHITECTURE Structure OF part4 IS
	COMPONENT fa
		PORT ( a, b, ci : IN  STD_LOGIC;
		       s, co    : OUT STD_LOGIC);
	END COMPONENT;
	COMPONENT bcd7seg
		PORT ( B : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		       H : OUT STD_LOGIC_VECTOR(0 TO 6));
	END COMPONENT;
	COMPONENT part2_conv
		PORT ( V : IN     STD_LOGIC_VECTOR(3 DOWNTO 0);
		       z : BUFFER STD_LOGIC;
		       M : OUT    STD_LOGIC_VECTOR(3 DOWNTO 0));
	END COMPONENT;
	COMPONENT mux2to1_4bit
		PORT ( X, Y : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		       s    : IN  STD_LOGIC;
		       M    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
	END COMPONENT;
	SIGNAL X, Y, S : STD_LOGIC_VECTOR(3 DOWNTO 0);   -- S é o resultado (saida) do somador
	SIGNAL Cin     : STD_LOGIC;                      -- carry de entrada
	SIGNAL C       : STD_LOGIC_VECTOR(4 DOWNTO 1);   -- carries internos
	SIGNAL M       : STD_LOGIC_VECTOR(3 DOWNTO 0);   -- usado para soma 0 até 15
	SIGNAL B, S0   : STD_LOGIC_VECTOR(3 DOWNTO 0);   -- usado para soma 16 - 19
	SIGNAL z, S1   : STD_LOGIC;
	SIGNAL d1      : STD_LOGIC_VECTOR(3 DOWNTO 0);   -- VHDL-93 nao aceita expressao no PORT MAP
BEGIN
	X <= SW(7 DOWNTO 4);
	Y <= SW(3 DOWNTO 0);
	Cin <= SW(8);

	bit0: fa PORT MAP (X(0), Y(0), Cin, S(0), C(1));
	bit1: fa PORT MAP (X(1), Y(1), C(1), S(1), C(2));
	bit2: fa PORT MAP (X(2), Y(2), C(2), S(2), C(3));
	bit3: fa PORT MAP (X(3), Y(3), C(3), S(3), C(4));
	LEDG(4 DOWNTO 0) <= (C(4) & S);

	-- Display as entradas
	H_5: bcd7seg PORT MAP (X, HEX5);
	HEX4 <= "1111111";   -- display em branco (apagado)

	H_3: bcd7seg PORT MAP (Y, HEX3);
	HEX2 <= "1111111";   -- display em branco

	-- Detecta entradas ilegais, mostra no LEDG(9)
	LEDG(9) <= (X(3) AND X(2)) OR (X(3) AND X(1)) OR
		(Y(3) AND Y(2)) OR (Y(3) AND Y(1));
	LEDG(8 DOWNTO 5) <= "0000";

	-- Mostra a soma
	-- parte2 (V, z, M);
	U1: part2_conv PORT MAP (S, z, M);
	B(3) <= M(1);
	B(2) <= NOT(M(1));
	B(1) <= NOT(M(1));
	B(0) <= M(0);
	U2: mux2to1_4bit PORT MAP (M, B, C(4), S0);

	H0: bcd7seg PORT MAP (S0, HEX0);
	-- HEX1 mostra 1 quando z é 1 (soma 10-15), e também quando C[4] is 1 (soma 16-19)
	S1 <= z OR C(4);
	d1 <= "000" & S1;
	H1: bcd7seg PORT MAP (d1, HEX1);
END Structure;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY part2_conv IS
	PORT ( V : IN     STD_LOGIC_VECTOR(3 DOWNTO 0);
	       z : BUFFER STD_LOGIC;
	       M : OUT    STD_LOGIC_VECTOR(3 DOWNTO 0));
END part2_conv;

ARCHITECTURE Structure OF part2_conv IS
	SIGNAL A : STD_LOGIC_VECTOR(3 DOWNTO 0);
	COMPONENT mux2to1_4bit
		PORT ( X, Y : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		       s    : IN  STD_LOGIC;
		       M    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
	END COMPONENT;
BEGIN
	-- circuito comparador para V > 9
	z <= (V(3) AND V(2)) OR (V(3) AND V(1));

	-- Circuito A: quando V > 9, este circuito permite o display d0 mostrar os valores
	-- de 0 - 5 (para valores de V = 10 até V = 15). Note que V3 = 1 para todo esses
	-- valores e V3 não é necessário no circuito A.
	-- O circuito implementa a seguinte tabela verdade:
	--
	-- V2 V1 V0 | A2 A1 A0
	-- -------------------
	-- 0  1  0  | 0  0  0      V = 1010 -> 0
	-- 0  1  1  | 0  0  1      V = 1011 -> 1
	-- 1  0  0  | 0  1  0      V = 1100 -> 2
	-- 1  0  1  | 0  1  1      V = 1101 -> 3
	-- 1  1  0  | 1  0  0      V = 1110 -> 4
	-- 1  1  1  | 1  0  1      V = 1111 -> 5
	A(3) <= '0';
	A(2) <= V(2) AND V(1);
	A(1) <= V(2) AND NOT(V(1));
	A(0) <= (V(1) AND V(0)) OR (V(2) AND V(0));

	-- multiplexadores
	U1: mux2to1_4bit PORT MAP (V, A, z, M);
END Structure;
