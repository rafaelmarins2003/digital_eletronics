LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY part1_alt_tb IS
END part1_alt_tb;

ARCHITECTURE test OF part1_alt_tb IS
    SIGNAL SW, LEDG : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL HEX1, HEX0 : STD_LOGIC_VECTOR(0 TO 6);
    TYPE patterns IS ARRAY (0 TO 9) OF STD_LOGIC_VECTOR(0 TO 6);
    CONSTANT expected : patterns := (
        "0000001", "1001111", "0010010", "0000110", "1001100",
        "0100100", "0100000", "0001111", "0000000", "0000100"
    );
BEGIN
    dut : ENTITY work.part1_alt PORT MAP (SW, LEDG, HEX1, HEX0);

    PROCESS
    BEGIN
        FOR tens IN 0 TO 9 LOOP
            FOR ones IN 0 TO 9 LOOP
                SW <= STD_LOGIC_VECTOR(TO_UNSIGNED(tens * 16 + ones, 8));
                WAIT FOR 1 ns;
                ASSERT HEX1 = expected(tens) REPORT "HEX1 incorreto" SEVERITY failure;
                ASSERT HEX0 = expected(ones) REPORT "HEX0 incorreto" SEVERITY failure;
                ASSERT LEDG = SW REPORT "LEDG incorreto" SEVERITY failure;
            END LOOP;
        END LOOP;
        REPORT "part1_alt: 100 combinacoes validas aprovadas" SEVERITY note;
        WAIT;
    END PROCESS;
END test;
