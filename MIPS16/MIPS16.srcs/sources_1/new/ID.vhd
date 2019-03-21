library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity InstructionDecode is
  Port (
    clk: in std_logic;
    instruction: in std_logic_vector(15 downto 0);
    wd: in std_logic_vector(15 downto 0);
    btn : in STD_LOGIC_VECTOR (4 downto 0);
    waIN : in std_logic_vector(2 downto 0);
    regWrite: in std_logic;
    regDst: in std_logic;
    expOp: in std_logic;
    rd1: out std_logic_vector(15 downto 0);
    rd2: out std_logic_vector(15 downto 0);
    extImm: out std_logic_vector(15 downto 0);
    func: out std_logic_vector(15 downto 0);
    wa : out std_logic_vector(2 downto 0);
    sa: out std_logic_vector(15 downto 0);
    en : in std_logic
   );
end InstructionDecode;

architecture Behavioral of InstructionDecode is

component rf is
port(ra1,ra2,wa: in std_logic_vector(2 downto 0); 
    wd: in std_logic_vector(15 downto 0); 
    rd1,rd2: out std_logic_vector(15 downto 0); 
    regwr,clk,en: in std_logic);
end component;

component MPG is
 Port  ( en : out STD_LOGIC;
         clk : in STD_LOGIC;
         input : in STD_LOGIC
  );
  end component;


signal writeAddressOut: std_logic_vector(2 downto 0);
signal functionAux: std_logic_vector(15 downto 0) := (others => '0');
signal saAux: std_logic_vector(15 downto 0):= (others => '0');

--signal en : std_logic;
begin
    -- M1: MPG port map(en=>en,clk=> clk,input=>btn(0));
  --  p1: rf port map(clk=>clk,ra1=>instruction(12 downto 10),ra2=>instruction(9 downto 7),wa=>writeAddressOut,wd=>wd,regwr=>regWrite,rd1=>rd1,rd2=>rd2,en>=en);
    p1: rf port map( ra1 => instruction(12 downto 10), ra2 => instruction (9 downto 7), wa => WaIN, wd =>wd ,rd1 =>rd1, rd2=>rd2,regWr => regWrite,clk=>clk, en=>en);  
  
    writeAddressOut <= instruction(9 downto 7) when regDst = '0' else instruction(6 downto 4);
    wa <= writeAddressOut;
    functionAux(15 downto 13) <= instruction(15 downto 13);
    extImm <= "000000000"&instruction(6 downto 0) when expOp = '0' else instruction(6)&instruction(6)&instruction(6)&instruction(6)&instruction(6)&instruction(6)&instruction(6)&instruction(6)&instruction(6)&instruction(6 downto 0);
    saAux(0) <= instruction(3);
    sa<=saAux;
    func <= functionAux;
end Behavioral;
