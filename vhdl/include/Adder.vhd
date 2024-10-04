library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.configpkg.all;

entity Adder is
	generic(nbit: integer := columns);
	port(
  		A: in std_logic_vector(nbit-1 downto 0);
		B: in std_logic_vector(nbit-1 downto 0);
		AS: in std_logic;
		SUM: out std_logic_vector(nbit-1 downto 0)
		);
end Adder;

architecture structure of Adder is

signal COUT: std_logic_vector(nbit downto 0);
signal out_xor: std_logic_vector(nbit-1 downto 0);

component FA is
	port(A: in std_logic;
	B: in std_logic;
	C: in std_logic;
	S: out std_logic;
	CO: out std_logic);
end component;

component XOR2_c is
	port(IN0,IN1: in std_logic;
	o: out std_logic);
end component;

begin
	COUT(0) <= AS;
	generate_xor_gates: for i in 0 to nbit-1 generate
		EXOR: XOR2_c
		PORT MAP(B(i), COUT(0), out_xor(i));
	end generate generate_xor_gates;
	FullAdder_0: FA
	PORT MAP(A(0), out_xor(0), COUT(0), SUM(0), COUT(1));
	generate_full_adders: for i in 1 to nbit-1 generate
		FullAdder:FA
		port map(A(i),out_xor(i),COUT(i),SUM(i),COUT(i+1));
	end generate generate_full_adders;
	
end architecture structure;