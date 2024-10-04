library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
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
end top_level;

architecture structure of top_level is

component Multiplier
	generic (nbit: integer := 8);
	port(
	A : in std_logic_vector(7 downto 0);
	B : in std_logic_vector(7 downto 0);
	O : out std_logic_vector(15 downto 0)
	);
end component;

component Adder
	generic (nbit: integer := 8);
	port(
	A: in std_logic_vector(nbit-1 downto 0);
	B: in std_logic_vector(nbit-1 downto 0);
	AS: in std_logic;
	SUM: out std_logic_vector(nbit-1 downto 0)
	);
end component;

component Reg 
  generic(nbit: integer := 8);
  port(
  CK : in std_logic;
  EN : in std_logic;
  R : in std_logic;
  D : in std_logic_vector(nbit-1 downto 0);
  Q : out std_logic_vector(nbit-1 downto 0)
  );
end component;

component FLIPFLOP
  port(
  CK: in std_logic;
  RN: in std_logic;
  WR: in std_logic;
  RD: out std_logic;
  RDN: out std_logic
  );
end component;

component LUT_3bit is
    port (
        input : in std_logic_vector(2 downto 0);
        program : in std_logic_vector(7 downto 0);
        output : out std_logic
    );
end component;

component LogicFunction is
    port (      
        inA : in std_logic_vector(7 downto 0);
	inB : in std_logic_vector(7 downto 0);
        FuncL: in std_logic_vector(1 downto 0);
        output : out std_logic_vector(7 downto 0)
    );
end component;

-- ALU inputs
signal A_sum_in_s : std_logic_vector(7 downto 0);
signal B_sum_in_s : std_logic_vector(7 downto 0);
signal A_mul_in_s : std_logic_vector(7 downto 0);
signal B_mul_in_s : std_logic_vector(7 downto 0);
signal A_Log_in : std_logic_vector(7 downto 0);
signal B_log_in : std_logic_vector(7 downto 0);
signal Func_L_in : std_logic_vector(1 downto 0);
signal A_Lut_in : std_logic_vector(2 downto 0);
signal Prog_Lut_in : std_logic_vector(7 downto 0);

-- ALU outputs
signal Multiplier_O : std_logic_vector(15 downto 0);
signal Adder_O : std_logic_vector(7 downto 0);
signal Log_O : std_logic_vector(7 downto 0);
signal LUT_O : std_logic;

-- OUTPUT management signals
signal O_s
 : std_logic_vector(15 downto 0);
signal d_OP_CODE: std_logic_vector(1 downto 0);

-- ENABLE SIGNALS
signal sum_en : std_logic;
signal mul_en : std_logic;
signal lut_en : std_logic;
signal log_en : std_logic;



begin

-- COMPONENTS/ALU
Multiplier_1 : Multiplier generic map(8) port map(A_mul_in_s, B_mul_in_s, Multiplier_O);
Adder_1 : Adder generic map(8) port map(A_sum_in_s, B_sum_in_s,'0', Adder_O);
Logica : LogicFunction PORT MAP (A_Log_in,B_log_in,Func_L_in,Log_O);        
LukAp : LUT_3bit PORT MAP(A_Lut_in,Prog_Lut_in,LUT_O);

-- FF OPCODE
ff_opcode : reg generic map(2) port map(clk,'1',rst_n,OP_CODE, d_OP_CODE);
-- INPUT FFs / mul
ff_mul_in_a : reg generic map(8) port map(clk, mul_en, rst_n, A, A_mul_in_s); 
ff_mul_in_b : reg generic map(8) port map(clk, mul_en, rst_n, B, B_mul_in_s);
-- INPUT FFs / add
ff_sum_in_a : reg generic map(8) port map(clk, sum_en , rst_n, A, A_sum_in_s);
ff_sum_in_b : reg generic map(8) port map(clk, sum_en , rst_n, B, B_sum_in_s); 
-- INPUT FFs / lut
ff_lut_in_a : reg generic map(3) port map(clk, lut_en , rst_n, A(2 downto 0), A_Lut_in);	    
ff_lut_in_prog : reg generic map(8) port map(clk, lut_en , rst_n, Lut_Prog, Prog_Lut_in);
-- INPUT FFs / log 
ff_log_in_a : reg generic map(8) port map(clk, log_en , rst_n, A, A_Log_in);
ff_log_in_b : reg generic map(8) port map(clk, log_en , rst_n, B, B_Log_in);
ff_log_in_s : reg generic map(2) port map(clk, log_en , rst_n, Func_L, Func_L_in);
-- OUT FF
ff_out : reg generic map(16) port map(clk, '1', rst_n, O_s, O);  

-- OPCODE DECODER
mul_en <= NOT(OP_CODE(0)) AND NOT(OP_CODE(1));
sum_en <= (OP_CODE(0)) AND NOT(OP_CODE(1));
lut_en <= NOT(OP_CODE(0)) AND (OP_CODE(1));
log_en <= (OP_CODE(0)) AND (OP_CODE(1));
--decoder : process(OP_CODE) 
--begin 
--	sum_en<='0';
--	mul_en<='0';
--	log_en<='0';
--	lut_en<='0';
--	if(OP_CODE="00") THEN
--		mul_en<='1';
--	elsif(OP_CODE="01") THEN
--		sum_en<='1';
--	elsif(OP_CODE="10") THEN
--		lut_en<='1';
--	else
--		log_en<='1';
--	end if;
--end process;

-- OUTPUT MUX
out_mux : process(d_OP_CODE,Multiplier_O,Adder_O,LUT_O,Log_O) 
begin 
	if(d_OP_CODE="00") THEN
		O_s<=Multiplier_O;
	elsif(d_OP_CODE="01") THEN
		O_s <= Adder_O&"00000000";
	elsif(d_OP_CODE="10") THEN
		O_s <= LUT_O&"000000000000000";
	else
		O_s <= log_O&"00000000";
	end if;
end process;		
	        
end structure;
