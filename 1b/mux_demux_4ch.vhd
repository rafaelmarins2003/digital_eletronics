entity mux_demux_4ch is 
 port (SW   :  in  bit_vector (0 to 9);
		 LEDG :  out bit_vector (0 to 3));
end mux_demux_4ch;

architecture hardware of mux_demux_4ch is

component mux_4_1
 port (in0, in1, in2, in3  :  in  bit;
						s0, s1   :  in  bit;
						y        :  out bit);
end component;

component demux_1_4
 port (input               :  in  bit;
		 s0, s1              :  in  bit;
		 y0,y1,y2,y3         :  out bit);
end component;

signal v :  bit;

 begin
 mux: mux_4_1 port map (SW(0), SW(1), SW(2), SW(3), SW(8), SW(9), v);
 demux: demux_1_4 port map (v, SW(8), SW(9), LEDG(0), LEDG(1), LEDG(2), LEDG(3));
 
end hardware;