library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity XOR2_c is
	port(IN0,IN1: in std_logic;
	o: out std_logic);
end XOR2_c;

architecture behavior of XOR2_c is
begin
	o <= IN0 xor IN1;
end behavior;

