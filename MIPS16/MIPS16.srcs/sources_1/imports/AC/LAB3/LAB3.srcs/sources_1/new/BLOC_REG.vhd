library ieee;
use ieee.std_logic_1164.all;
use IEEe.STD_LOGIC_UNSIGNED.ALL;

entity rf is
    port(ra1,ra2,wa: in std_logic_vector(2 downto 0); 
    wd: in std_logic_vector(15 downto 0); 
    rd1,rd2: out std_logic_vector(15 downto 0); 
    regwr,clk,en: in std_logic);
end;

architecture rf_arh of rf is

type mem is array(0 to 7) of std_logic_vector(15 downto 0);
signal regf: mem :=(others => x"0000");

begin

process(clk)
begin
    if(rising_edge(clk)) then
        if(regwr='1') then
           if(en='1') then
                regf(conv_integer(wa)) <= wd;
         end if;
        end if;
    end if;
end process;

rd1<= regf(conv_integer(ra1));
rd2<=regf(conv_integer(ra2));

end;