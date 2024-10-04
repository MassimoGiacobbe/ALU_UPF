library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity NAND2_c is
	port(IN0,IN1: in std_logic;
	o: out std_logic);
end NAND2_c;

architecture behavior of NAND2_c is
begin
	o <= IN0 nand IN1;
end behavior;

