library ieee;
use ieee.std_logic_1164.all;

--opcode = 0 -> MUL
--opcode = 1 -> SUM

entity PMU is
	port (
	opcode : in std_logic_vector(1 downto 0);
	go_sleep, clk: in std_logic;
	turn_off_add, turn_off_mul, turn_off_lut, turn_off_logic,
	iso_add, iso_mul, iso_lut, iso_logic,
	ret_reg_rest_in, ret_reg_rest_out : out std_logic);
end PMU;


architecture behaviour of PMU is

signal turn_off_add_int, turn_off_mul_int, turn_off_lut_int, turn_off_logic_int,
	iso_add_int, iso_mul_int, iso_lut_int, iso_logic_int, ret_reg_rest_int: std_logic;

begin
	
	process(opcode,go_sleep)
	begin
		if go_sleep = '1' then
			if opcode = "00" then
				--MUL 
				turn_off_add_int <= '1';
				iso_add_int <= '0';
				turn_off_mul_int <= '0';
				iso_mul_int <= '1';
				turn_off_lut_int <= '1';
				iso_lut_int <= '0';
				turn_off_logic_int <= '1';
				iso_logic_int <= '0';
				ret_reg_rest_int <= '1'; -- set registers in transparent mode
			elsif opcode = "01" then
				--ADD
				turn_off_add_int <= '0'; -- ACTIVE
				iso_add_int <= '1'; -- NOT ISOLATED
				turn_off_mul_int <= '1';
				iso_mul_int <= '0';
				turn_off_lut_int <= '1';
				iso_lut_int <= '0';
				turn_off_logic_int <= '1';
				iso_logic_int <= '0';
				ret_reg_rest_int <= '1';  -- set registers in transparent mode
			elsif opcode = "10" then
				--LUT
				turn_off_add_int <= '1';
				iso_add_int <= '0';
				turn_off_mul_int <= '1';
				iso_mul_int <= '0';
				turn_off_lut_int <= '0'; -- ACTIVE
				iso_lut_int <= '1'; -- NOT ISOLATED
				turn_off_logic_int <= '1';
				iso_logic_int <= '0';
				ret_reg_rest_int <= '1';  -- set registers in transparent mode
			else
				turn_off_add_int <= '1';
				iso_add_int <= '0';
				turn_off_mul_int <= '1';
				iso_mul_int <= '0';
				turn_off_lut_int <= '1';
				iso_lut_int <= '0';
				turn_off_logic_int <= '0'; -- ACTIVE
				iso_logic_int <= '1'; -- NOT ISOLATED
				ret_reg_rest_int <= '1';  -- set registers in transparent mode
			end if;
		else
			turn_off_add_int <= '1';
			iso_add_int <= '0';
			turn_off_mul_int <= '1';
			iso_mul_int <= '0';
			turn_off_lut_int <= '1';
			iso_lut_int <= '0';
			turn_off_logic_int <= '1';
			iso_logic_int <= '0';
			ret_reg_rest_int <= '0'; -- NOT set registers in transparent mode
		end if;
	end process;

    ret_reg_rest_in <= ret_reg_rest_int;

    process(clk)
    begin
        if (rising_edge(clk)) then
			turn_off_add <= turn_off_add_int;
			iso_add <= iso_add_int;
			turn_off_mul <= turn_off_mul_int;
			iso_mul <= iso_mul_int;
			turn_off_lut <= turn_off_lut_int;
			iso_lut <= iso_lut_int;
			turn_off_logic <= turn_off_logic_int;
			iso_logic <= iso_logic_int;
			ret_reg_rest_out <= ret_reg_rest_int;
        end if;
    end process;	

end architecture;
