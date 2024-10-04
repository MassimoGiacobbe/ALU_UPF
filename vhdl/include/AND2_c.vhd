library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AND2_c is
	port(IN0,IN1: in std_logic;
	O: out std_logic);
end AND2_c;

architecture behavior of AND2_c is
begin
	o <= IN0 and IN1;
end behavior;

