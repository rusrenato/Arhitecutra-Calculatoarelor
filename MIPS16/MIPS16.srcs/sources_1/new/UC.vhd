library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity ControlUnit is
  Port ( 
    instruction: in std_logic_vector(15 downto 0);
    regDst: out std_logic;
    extOp: out std_logic;
    branch: out std_logic;
    jump: out std_logic;
    memWrite: out std_logic;
    aluOp: out std_logic_vector(2 downto 0);
    memToReg: out std_logic;
    regWrite: out std_logic;
    ALUsrc : out std_logic
  );
end ControlUnit;

architecture Behavioral of ControlUnit is

begin
     p1: process(instruction)
     begin
        regDst <= '0';
        regWrite <= '0';
        branch<= '0';
        extOp <='0';
        jump<= '0';
        memWrite <= '0';
        memToReg <= '0';
        alusrc <= '0';
        aluOp<= "000";
        
        case instruction(15 downto 13) is
            when "000" => 
                regWrite <= '1';
                regDst <= '1';
                aluOp <= "000";
            when "001" =>
                regWrite <= '1';
                aluSrc <= '1';
                extOp <= '1';
                aluOp <= "010"; -- addi
            when "010" =>
                regWrite <= '1';
                aluSrc <= '1';
                extOp <= '1';
                memToReg <= '1';
                aluOp <= "010"; --lw
            when "011" =>
                aluSrc <= '1';
                memWrite <= '1';
                aluOp <= "010"; --sw
            when "100" =>
                branch <= '1';
                extOp  <= '1';
                aluOp <= "100"; -- beq
            when "101" => 
                jump <= '1'; --j
                
            when others => 
        end case;
     end process;
   
end Behavioral;