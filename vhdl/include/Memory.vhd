library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Memory is
port(
CK: in std_logic;
EN: in std_logic;
RN: in std_logic;
WR: in std_logic;
RD: out std_logic);
end Memory;

architecture behavior of Memory is
signal net3: std_logic;
signal net1: std_logic;
signal net2: std_logic;

component NAND2_c is
port(IN0,IN1: in std_logic;
o: out std_logic);
end component NAND2_c;

component OAI21_c is
  port(IN0,IN1,IN2: in std_logic;
    O: out std_logic);
end component OAI21_c;

component FLIPFLOP is
port(
CK: in std_logic;
RN: in std_logic;
WR: in std_logic;
RD: out std_logic;
RDN: out std_logic);
end component;


begin

  FLIPFLOP_0: FLIPFLOP
  port map(CK,RN,net1,RD,net3);

  NAND_1: NAND2_c
  port map(EN, WR, net2);

  OAI21_2: OAI21_c
  port map(net3, EN, net2, net1);

end behavior;
