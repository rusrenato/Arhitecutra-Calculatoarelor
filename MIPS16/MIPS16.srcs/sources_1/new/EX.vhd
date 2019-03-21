----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2018 05:48:14 PM
-- Design Name: 
-- Module Name: EX - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EX is
port ( adresa_urmat : in STD_LOGIC_VECTOR(15 downto 0 );
       rd1 : in STD_LOGIC_VECTOR(15 downto 0);
       rd2 : in STD_LOGIC_VECTOR(15 downto 0);
       clk : in STD_LOGIC;
       extImm : in std_logic_vector(15 downto 0);
       func: in std_logic_vector(15 downto 0);
       sa: in std_logic_vector(15 downto 0);
       AluSrc : in std_logic;
       AluOP : in std_logic_vector(2 downto 0) :="000";
       branch_adress : out std_logic_vector(15 downto 0);
       AluRez : out std_logic_vector(15 downto 0);
       zero : out std_logic := '0';
       aluC : out std_logic_vector(2 downto 0)
       
);
end EX;

architecture Behavioral of EX is

signal op1,op2,extAUX,AluRezAux : std_logic_vector(15 downto 0) := x"0000";
signal ALuCOntrol : std_logic_vector(2 downto 0) := "000";
begin

op1 <= rd1;
with AluSRc select
op2 <= extImm when '1', RD2 when '0';
 
--extAUX <= extImm(13 downto 0) & "00";
 
branch_adress <= extImm + adresa_urmat;

process(func,ALUop) 
begin 
case ALUop is 
  when "010" => ALuControl <= "000"; -- add
  when "100" => ALuControl <= "001"; --sub
  when "110" => ALUControl <= "010"; --or
  when "111" => ALUCOntrol <= "011"; --and
  when "000" => case func(2 downto 0) is 
               when "000" => ALUCOntrol <= "000" ;--add
               when "010" => ALuControl <= "001" ;--sub
               when "011" => ALUCOntrol <= "101" ; --sll
               when "001" => ALUControl <= "100" ; --srl
               when "100" => ALUControl <= "011"; -- and
               when "101" => ALUControl <= "010"; -- or 
               when "110" => ALUControl <= "110"; -- xor
               when "111" => ALUCOntrol <= "111"; --sra
               end case;
    when others => NULL;
    end case;
end process;
AluC <= AluControl;

process(ALUControl) 
begin 
case AluControl is 
when "000" => ALuRezAux <= op1 + op2 ;
when "001" => AluRezAux <= op1 - op2;
when "101" => ALuRezAux <= op2(14 downto 0) & sa(0); 
when "100" => ALURezAux <= sa(0) & op2(15 downto 1) ; 
when "011" => ALuRezAux <= op1 and op2;
when "010" => AluREzAux <= op1 or op2;
when "110" => ALuREzAux <= op1 xor op2;

when others => NULL;

end case;
AluRez <= AluRezAux;
end process;

zero <= '1' when AluRezAux = x"0000" else '0';


end Behavioral;
