library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.configpkg.all;
entity Multiplier is
	generic(nbit : integer := columns);
	port(
		A : in  std_logic_vector(nbit-1 downto 0);
		B : in  std_logic_vector(nbit-1 downto 0);
		O : out std_logic_vector(2*nbit-1 downto 0)
	);
end Multiplier;

architecture structure of Multiplier is
	component FA is
		port(A : in std_logic;
			B  : in  std_logic;
			C  : in  std_logic;
			S  : out std_logic;
			CO : out std_logic);
	end component;
	component HA
		port(A : in std_logic;
			B  : in  std_logic;
			S  : out std_logic;
			CO : out std_logic);
	end component;
	component AND2_c
		port(IN0,IN1 : in std_logic;
			O : out std_logic);
	end component;
	type array_out_signals is array (natural range <>) of std_logic_vector(nbit-1 downto 0);
	type array_out_add_carry is array (natural range <>) of std_logic_vector(nbit-2 downto 0);
	signal AND_OUT : array_out_signals(nbit-1 downto 0);
	signal OUT_S: array_out_add_carry(nbit-2 downto 0);
	signal OUT_CO: array_out_add_carry(nbit-2 downto 0);
	signal RCA_CARRY: std_logic_vector(nbit-1 downto 0);
begin

	--ands

	AND_I: for i in 0 to nbit-1 generate
		J: for j in 0 to nbit-1 generate
			ANDI: AND2_c port map(A(j),B(i), AND_OUT(i)(j));
		end generate; 
	end generate;

	O(0) <= AND_OUT(0)(0);

	-- HA

	HAp: for i in 0 to nbit-2 generate
		HALFADDER: HA port map(AND_OUT(0)(i+1), AND_OUT(1)(i), OUT_S(0)(i), OUT_CO(0)(i));
	end generate;
	O(1) <= OUT_S(0)(0);

	-- FA

	check_nbit: if nbit /= 2 generate
		FA_ROW: for i in 0 to nbit-3 generate
			FA_COL: for j in 0 to nbit-2 generate
				if_j_not_nbit: if j /= nbit-2 generate
					FAp: FA port map(AND_OUT(2+i)(j), OUT_CO(i)(j), OUT_S(i)(j+1), OUT_S(i+1)(j), OUT_CO(i+1)(j));
				end generate;
				if_j_nbit: if j = nbit-2 generate
					FAp: FA port map(AND_OUT(2+i)(j), OUT_CO(i)(j), AND_OUT(i+1)(nbit-1), OUT_S(i+1)(j), OUT_CO(i+1)(j));
				end generate;
			end generate;
			O(i+2) <= OUT_S(i+1)(0);
		end generate;
	end generate;

	--RCA
	RCA_CARRY(0) <= '0';

	RCA_GEN: for i in 0 to nbit-2 generate
		if_i_nbit_2: if i=nbit-2 generate
			RCA: FA port map(RCA_CARRY(i), OUT_CO(nbit-2)(i),AND_OUT(nbit-1)(nbit-1),O(nbit+i),RCA_CARRY(i+1));
		end generate;
		if_i_not_nbit_2: if i/=nbit-2 generate
			RCA: FA port map(RCA_CARRY(i), OUT_CO(nbit-2)(i),OUT_S(nbit-2)(i+1),O(nbit+i),RCA_CARRY(i+1));
		end generate;
	end generate;

	O(2*nbit-1) <= RCA_CARRY(nbit-1);


end architecture structure;
