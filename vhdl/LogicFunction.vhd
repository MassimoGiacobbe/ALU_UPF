library ieee;
use ieee.std_logic_1164.all;

entity LogicFunction is
    port (
        inA : in std_logic_vector(7 downto 0);
	inB : in std_logic_vector(7 downto 0);
        FuncL: in std_logic_vector(1 downto 0);
        output : out std_logic_vector(7 downto 0)
    );
end entity LogicFunction;

architecture Behavioral of LogicFunction is
begin
	process(FuncL,inA,inB)
	begin
		if FuncL = "01" then
			output <= inA and inB;
		elsif FuncL ="10" then
			output <= inA or inB;
		else
			output <= inA xor inB;    
		end if;
	end process;
end architecture Behavioral;
