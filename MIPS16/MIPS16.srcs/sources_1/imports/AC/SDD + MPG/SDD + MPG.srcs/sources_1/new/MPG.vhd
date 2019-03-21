----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2018 07:54:46 PM
-- Design Name: 
-- Module Name: MPG - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MPG is
 Port  ( en : out STD_LOGIC;
         clk : in STD_LOGIC;
         input : in STD_LOGIC);
end MPG;

architecture Behavioral of MPG is
signal count : STD_LOGIC_VECTOR (15 downto 0 ) := "0000000000000000";
signal q1,q2,q3 : STD_LOGIC;

begin
process (clk)
begin 
if rising_edge(clk) then 
  count <= count + 1;
  end if ;
end process;


process(clk)
begin 
if rising_edge(clk) then 
  if count = "1111111111111111" then 
     q1 <= input;
  end if;
end if;
end process;

process(clk)
begin 
if rising_edge(clk) then 
q2 <= q1;
q3 <= q2;
end if;
end process;

EN <= NOT Q2 AND Q3;


end Behavioral;
