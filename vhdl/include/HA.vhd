library ieee;
use ieee.std_logic_1164.all;


entity HA is
	port(A: in std_logic;
	B: in std_logic;
	S: out std_logic;
	CO: out std_logic);
end HA;

architecture structure of HA is

begin
	S <= A xor B;
	CO <= A and B;

end structure;
