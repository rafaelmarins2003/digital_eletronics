entity muxdemux1a is
 port (in0, in1, in2, in3  :  in  bit;
						    s0, s1  :  in  bit;
							 y       :  out  bit);
end muxdemux1a;

architecture hardware of muxdemux1a is
 begin
 y <= (in0 and not s1 and not s0) or
			(in1 and not s1 and s0) or
			(in2 and s1 and not s0) or
			(in3 and s1 and s0);
end hardware;
