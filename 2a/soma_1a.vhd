ENTITY soma_1a IS
	PORT (a, b, ve : IN BIT;
			s, vs		: OUT BIT);
END soma_1a;

ARCHITECTURE somador OF soma_1a IS

BEGIN
	s <= a XOR b XOR ve;
	vs <= (a AND b) OR (ve and (a xor b));
	
END somador;