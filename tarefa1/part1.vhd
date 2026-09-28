LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- chaves e leds

ENTITY part1 IS
PORT (SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		LEDG : OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
END part1;

-- atribuicao corrente direta

ARCHITECTURE hardware OF part1 IS
BEGIN LEDG <= SW;
END hardware;