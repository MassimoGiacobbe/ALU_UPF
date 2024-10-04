library ieee;
use ieee.std_logic_1164.all;


entity FA is
	port(A: in std_logic;
	B: in std_logic;
	C: in std_logic;
	S: out std_logic;
	CO: out std_logic);
end FA;

architecture structure of FA is
signal out_xor_1: std_logic;
signal out_and_1, out_and_2: std_logic;

begin
	out_xor_1 <= A xor B;
	out_and_1 <= out_xor_1 and C;
	S <= out_xor_1 xor C;
	out_and_2 <= A and B;
	CO <= out_and_1 or out_and_2;
end structure;
