library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.configpkg.all;
entity Reg is
  generic(nbit: integer := columns);
  port(
  CK : in std_logic;
  EN : in std_logic;
  R : in std_logic;
  D : in std_logic_vector(nbit-1 downto 0);
  Q : out std_logic_vector(nbit-1 downto 0)
  );
end Reg;

architecture behavior of Reg is
  

  component Memory is
  port(
  CK: in std_logic;
  EN: in std_logic;
  RN: in std_logic;
  WR: in std_logic;
  RD: out std_logic);
  end component;

  begin

  generate_flip_flops: for i in 0 to nbit-1 generate
    CELL: Memory
    port map(CK,EN,R,D(i),Q(i));
  end generate generate_flip_flops;
end behavior;

