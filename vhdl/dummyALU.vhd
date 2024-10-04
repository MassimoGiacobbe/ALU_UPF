library ieee;
use ieee.std_logic_1164.all;

entity dummyALU is
port(
        clk : in std_logic;
        rst_n : in std_logic;  	
        O : out std_logic_vector(15 downto 0);
	    B : in std_logic_vector(7 downto 0);
	    A : in std_logic_vector(7 downto 0);
		go_sleep : in std_logic;
        OP_CODE, FuncL : in std_logic_vector(1 downto 0);
	Lut_prog : in std_logic_vector(7 downto 0)
	);
end dummyALU;


architecture structure of dummyALU is
	
component PMU is
	port (
	opcode : in std_logic_vector(1 downto 0);
	go_sleep, clk: in std_logic;
	turn_off_add, turn_off_mul, turn_off_lut, turn_off_logic,
	iso_add, iso_mul, iso_lut, iso_logic,
	ret_reg_rest_in, ret_reg_rest_out : out std_logic
	);
end component;

component top_level is
	port(
        clk : in std_logic;
        rst_n : in std_logic;  	
        O : out std_logic_vector(15 downto 0);
	    B : in std_logic_vector(7 downto 0);
	    A : in std_logic_vector(7 downto 0);
		turn_off_add,turn_off_mul,turn_off_lut,turn_off_logic,
		iso_add, iso_mul, iso_lut, iso_logic,
		ret_reg_rest_in, ret_reg_rest_out : in std_logic;
        OP_CODE : in std_logic_vector (1 downto 0);
	Func_L : in std_logic_vector(1 downto 0);
	Lut_Prog : in std_logic_vector(7 downto 0)
	);
end component;



signal s_turn_off_add,s_turn_off_mul,s_iso_add,s_iso_mul,s_ret_reg_rest_in,s_ret_reg_rest_out,s_turn_off_lut,s_turn_off_logic,s_iso_lut,s_iso_logic  : std_logic;

begin

comp_PMU : PMU port map (OP_CODE,go_sleep,clk,s_turn_off_add,s_turn_off_mul, s_turn_off_lut, s_turn_off_logic,s_iso_add,s_iso_mul,s_iso_lut,s_iso_logic,s_ret_reg_rest_in,s_ret_reg_rest_out);	
	
comp_top_level : top_level port map(clk,rst_n,O,B,A,s_turn_off_add,s_turn_off_mul,s_turn_off_lut,s_turn_off_logic,
	s_iso_add,s_iso_mul,s_iso_lut,s_iso_logic,s_ret_reg_rest_in,s_ret_reg_rest_out,OP_CODE,FuncL,Lut_prog);

end structure;
