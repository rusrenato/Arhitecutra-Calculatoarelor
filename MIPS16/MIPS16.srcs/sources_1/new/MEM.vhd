----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2018 08:25:37 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
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


library ieee;
use ieee.std_logic_1164.all;
use IEEe.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEM is
 Port (clk,en : in STD_LOGIC;
       AluRezIn : in STD_LOGIC_VECTOR(15 downto 0);
       rd2 : in std_logic_vector (15 downto 0);
       memWrite : in std_logic;
       memData : out std_logic_vector (15 downto 0);
       AluRezOut : out STD_LOGIC_VECTOR(15 downto 0)

  );
end MEM;

architecture Behavioral of MEM is
type mem is array(0 to 15) of std_logic_vector(15 downto 0);
signal reg: mem :=(others => "0000");
begin

AluREzOut <= AluREzIn;

process(clk)
begin
if rising_edge(clk) then 
   if en = '1' then 
   if memWrite = '1' then 
      reg(conv_integer(AluRezIn)) <= rd2;
      end if;
   
end if;   
end if;
end process;

memData <= reg(conv_integer(AluRezIn));

end Behavioral;
