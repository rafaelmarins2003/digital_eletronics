library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ula_full is
	port (
		A, B: in integer range 0 to 255;
		operacao: in std_logic_vector(2 downto 0);
		resultadoL, resultadoH: out std_logic_vector(7 downto 0);
		overflow: out std_logic
	);
end ula_full;

architecture Behavioral of ula_full is
begin
	process(A, B, operacao)
		variable temp_16bits: integer range 0 to 65535 := 0;
		variable SOME_VECTOR: std_logic_vector(15 downto 0) := x"0000";
	begin
		resultadoH <= x"00";
		case operacao is
		
			when "000" => -- SOMA
				temp_16bits := A + B;
				SOME_VECTOR := std_logic_vector(to_unsigned(temp_16bits, SOME_VECTOR'length));
				resultadoL <= SOME_VECTOR(7 downto 0);
				resultadoH <= SOME_VECTOR(15 downto 8);
				overflow <= SOME_VECTOR(8);
				
			when "001" => -- SUB
				temp_16bits := A - B;
				if A < B then
					overflow <= '1';
					temp_16bits := 256 - temp_16bits;
					SOME_VECTOR := std_logic_vector(to_unsigned(temp_16bits, SOME_VECTOR'length));
					resultadoL <= SOME_VECTOR(7 downto 0);
				
				else
					overflow <= '0';
					SOME_VECTOR := std_logic_vector(to_unsigned(temp_16bits, SOME_VECTOR'length));
					resultadoL <= SOME_VECTOR(7 downto 0);
				end if;
				
			when "010" => -- MUL
				temp_16bits := A * B;
				SOME_VECTOR := std_logic_vector(to_unsigned(temp_16bits, SOME_VECTOR'length));
				resultadoL <= SOME_VECTOR(7 downto 0);
				resultadoH <= SOME_VECTOR(15 downto 8);
				overflow <= '0';
				
			when "011" => -- DIV
				if B = 0 then
					overflow <= '1';
				else
					temp_16bits := A / B;
					SOME_VECTOR := std_logic_vector(to_unsigned(temp_16bits, SOME_VECTOR'length));
					resultadoL <= SOME_VECTOR(7 downto 0);
					resultadoH <= SOME_VECTOR(15 downto 8);
					overflow <= '0';
				end if;
			
			when "100" => --AND
				SOME_VECTOR(7 downto 0) := std_logic_vector(to_unsigned(A, SOME_VECTOR(7 downto 0)'length));
				SOME_VECTOR(15 downto 8) := std_logic_vector(to_unsigned(A, SOME_VECTOR(15 downto 8)'length));
				resultadoL <= SOME_VECTOR(7 downto 0) and SOME_VECTOR(15 downto 8);
				
			when "101" => -- OR
				SOME_VECTOR(7 downto 0) := std_logic_vector(to_unsigned(A, SOME_VECTOR(7 downto 0)'length));
				SOME_VECTOR(15 downto 8) := std_logic_vector(to_unsigned(A, SOME_VECTOR(15 downto 8)'length));
				resultadoL <= SOME_VECTOR(7 downto 0) or SOME_VECTOR(15 downto 8);
				
			when "110" => -- XOR
				SOME_VECTOR(7 downto 0) := std_logic_vector(to_unsigned(A, SOME_VECTOR(7 downto 0)'length));
				SOME_VECTOR(15 downto 8) := std_logic_vector(to_unsigned(A, SOME_VECTOR(15 downto 8)'length));
				resultadoL <= SOME_VECTOR(7 downto 0) xor SOME_VECTOR(15 downto 8);
				
			when "111" => -- NOT
				SOME_VECTOR(7 downto 0) := std_logic_vector(to_unsigned(A, SOME_VECTOR(7 downto 0)'length));
				resultadoL <= not SOME_VECTOR(7 downto 0);
			
			when others =>
				temp_16bits:= 0;
				overflow <= '0';
		end case;
		
	end process;
	
end Behavioral;
			
			
			