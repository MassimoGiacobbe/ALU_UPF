library ieee;
use ieee.std_logic_1164.all;


entity OAI21_c is
	port(IN0,IN1,IN2: in std_logic;
		O: out std_logic);
end OAI21_c;


architecture structure of OAI21_c is

begin

	O <= not((IN0 or IN1) and IN2);
	
end architecture structure;
