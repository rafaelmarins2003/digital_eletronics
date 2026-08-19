library IEEE;
use IEEE.std_logic_1164.all;

entity mux_4_1 is
 generic (N : integer := 8);
 
 port (in0, in1, in2, in3 : in STD_LOGIC_VECTOR (N-1 downto 0);
							 se1 : in STD_LOGIC_VECTOR (1 downto 0);
							 ot  : out STD_LOGIC_VECTOR (N-1 downto 0));
							 
end mux_4_1;

architecture rtl of mux_4_1 is
 begin
 ot <= in0 when se1 = "00" else
		 in1 when se1 = "01" else
		 in2 when se1 = "10" else
		 in3;
end rtl;


architecture rtl_with_select of mux_4_1 is
 begin
 with se1 select
 ot <= in0 when "00",
       in1 when "01",
		 in2 when "10",
		 in3 when "11",
		 null when others;
end rtl_with_select; 