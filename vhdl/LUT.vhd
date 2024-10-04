library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LUT_3bit is
    port (
        input : in std_logic_vector(2 downto 0);
        program : in std_logic_vector(7 downto 0);
        output : out std_logic
    );
end entity LUT_3bit;

architecture Behavioral of LUT_3bit is
    signal lut_values : std_logic_vector(7 downto 0);
begin
    lut_values <= program;
    process(lut_values,input)
    begin
    	output <= lut_values(to_integer(unsigned(input)));
    end process;
end architecture Behavioral;
