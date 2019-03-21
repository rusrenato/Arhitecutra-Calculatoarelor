library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Unitate_IF is
    Port ( clk,en,res : in STD_LOGIC;
           branch_adr,jump_adr : in STD_LOGIC_VECTOR(15 downto 0);
           adresa,adresa_urmat : out STD_LOGIC_VECTOR(15 downto 0);
           jump,PCSrc : in std_logic );
end Unitate_IF;

architecture Behavioral of Unitate_IF is
signal m1 : STD_LOGIC_VECTOR(15 downto 0);
signal PC : STD_LOGIC_VECTOR(15 downto 0) := x"0000";
signal PC1 : STD_LOGIC_VECTOR(15 downto 0);
signal PC2 : STD_LOGIC_VECTOR(15 downto 0) := x"0000";

type memory is array (0 to 23) of std_logic_vector(15 downto 0);
signal ROM : memory:=(
B"001_000_001_0000011",
--addi $1, $0, 3 --2083
B"001_000_010_0000010",
--addi $2, $0, 2 --2102
B"000_000_000_000_0_000",
B"000_000_000_000_0_000",
B"000_000_000_000_0_000",

B"000_001_010_011_0_000",
--add $3, $1, $2 --0532
B"000_000_000_000_0_000",
B"000_000_000_000_0_000",
B"011_100_011_0000000",
--sw $3, ($4) --7180
B"000_000_000_000_0_000",
B"000_000_000_000_0_000",

B"010_100_101_0000000",
--lw $5, ($4) --5280

B"001_000_100_0000001",
--addi $4, $0,1 --2201
B"000_000_000_000_0_000",
B"000_000_000_000_0_000",

B"000_110_100_110_0_000",
--add $6, $6, $4 --1A60
B"000_000_000_000_0_000",
B"000_000_000_000_0_000",

B"100_101_110_0000001",
--beq $5, $6,1 --9701
B"101_0000000001111",
--j5 --A006
B"000_000_101_111_0_001",
--srl $7,$5,0 -- 02F1
B"000_101_111_010_0_010",
--sub $2, $5, $7 --17A2
others => x"0000");

begin

process(clk)
begin 
 if rising_edge(clk) then 
   if (en= '1') then 
      PC <= PC2;
         end if;
    if (res ='1') then 
      PC <= (others => '0');
    end if;
 end if;
 end process;
 
PC1 <= PC + 1;
 
with PCSrc select
   m1 <=   branch_adr when '1',
           PC1 when '0';

 with jump select
  PC2 <= jump_adr when '1',
          m1 when '0' ;

adresa <= ROM(conv_integer(PC));
adresa_urmat <= PC1;

end Behavioral;
