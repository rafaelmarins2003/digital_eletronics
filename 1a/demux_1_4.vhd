entity demux_1_4 is
 port (input          :  in  bit;
		 s0, s1         :  in  bit;
		 y0, y1, y2, y3 :  out  bit);
		 
end demux_1_4;

architecture rtl of demux_1_4 is
 begin
 y0 <= input and not s1 and not s0;
 y1 <= input and not s1 and s0;
 y2 <= input and s1 and not s0;
 y3 <= input and s1 and s0;
end rtl; 