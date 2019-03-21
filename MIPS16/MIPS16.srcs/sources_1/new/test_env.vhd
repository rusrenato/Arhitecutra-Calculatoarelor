library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity TestInstructionDecode is
  Port (clk: in std_logic;
      btn : in STD_LOGIC_VECTOR (4 downto 0);
      sw: in std_logic_vector(15 downto 0);
      an: out std_logic_vector(3 downto 0);
      cat: out std_logic_vector(6 downto 0);
      led: out std_logic_vector(15 downto 0)
 );
end TestInstructionDecode;

architecture Behavioral of TestInstructionDecode is


component Unitate_IF is
    Port ( clk,en,res : in STD_LOGIC;
           branch_adr,jump_adr : in STD_LOGIC_VECTOR(15 downto 0);
           adresa,adresa_urmat : out STD_LOGIC_VECTOR(15 downto 0);
           jump,PCSrc : in std_logic );
 
end component;

component MPG is
 Port  ( en : out STD_LOGIC;
         clk : in STD_LOGIC;
         input : in STD_LOGIC
  );
 end component;
 component InstructionDecode is
   Port (
   clk: in std_logic;
   instruction: in std_logic_vector(15 downto 0);
   wd: in std_logic_vector(15 downto 0);
   regWrite: in std_logic;
   regDst: in std_logic;
   waIN : in std_logic_vector(2 downto 0);
   expOp: in std_logic;
   rd1: out std_logic_vector(15 downto 0);
   rd2: out std_logic_vector(15 downto 0);
   extImm: out std_logic_vector(15 downto 0);
   func: out std_logic_vector(15 downto 0);
   wa : out std_logic_vector(2 downto 0);
   sa: out std_logic_vector(15 downto 0);
   en : in std_logic
  );
 end component;
 component ControlUnit is
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
   aluSrc : out std_logic
 );
 
 end component;
 
 component EX is
 port ( adresa_urmat : in STD_LOGIC_VECTOR(15 downto 0 );
        rd1 : in STD_LOGIC_VECTOR(15 downto 0);
        rd2 : in STD_LOGIC_VECTOR(15 downto 0);
        clk : in STD_LOGIC;
        extImm : in std_logic_vector(15 downto 0);
        func: in std_logic_vector(15 downto 0);
        sa: in std_logic_vector(15 downto 0);
        AluSrc : in std_logic;
        AluOP : in std_logic_vector(2 downto 0);
        branch_adress : out std_logic_vector(15 downto 0);
        AluRez : out std_logic_vector(15 downto 0);
        zero : out std_logic;
        aluC : out std_logic_vector(2 downto 0)
        
 );
 end component;
 
component MEM is
  Port (clk,en : in STD_LOGIC;
        AluRezIn : in STD_LOGIC_VECTOR(15 downto 0);
        rd2 : in std_logic_vector (15 downto 0);
        memWrite : in std_logic;
        memData : out std_logic_vector (15 downto 0);
        AluRezOut : out STD_LOGIC_VECTOR(15 downto 0)
 
   );
 end component;
 
 
 component SSD is
    Port ( clk : in STD_LOGIC;
             an : out STD_LOGIC_VECTOR (3 downto 0);
             cat : out STD_LOGIC_VECTOR (6 downto 0);
             digit : in STD_LOGIC_VECTOR (15 downto 0) 
 );
 end component;
signal instruction,pc,branch_adress,jump_adress,alu_rez,mem_data: std_logic_vector(15 downto 0);
signal enable,reset,jump,pcSrc,branch:  std_logic;
signal rd1,rd2,extImm,func,sa,suma,writeDataAux: std_logic_vector(15 downto 0):= (others => '0');
signal regWrite,regDst,extOp,memWrite,memToReg,AluSrc:std_logic:= '0';
signal segAux,instructionAux: std_logic_vector(15 downto 0):= (others => '0');
signal aluOp,aluC,wa:std_logic_vector(2 downto 0);
signal adresa, adresa_urmat, DOUT: std_logic_vector(15 downto 0);
signal aux,branch2,zero : std_logic;

signal IF_ID : std_logic_vector(31 downto 0);
signal ID_EX : std_logic_vector(78 downto 0);
signal EX_MEM : std_logic_vector(55 downto 0);
signal MEM_WB : std_logic_vector (36 downto 0);

begin

    P9 : process(clk) 
    begin 
    if rising_edge(clk) then 
       if enable = '1' then 
          IF_ID(15 downto 0) <= adresa_urmat;
          IF_ID(31 downto 16) <= adresa;
    end if;
    end if;
    end process;
    
    process(clk)
    begin
    if rising_edge(clk) then 
      if enable = '1' then 
          ID_EX(0) <= MemToReg;
          ID_EX(1) <= RegWrite;
          ID_EX(2) <= MemWrite ;
          ID_EX(3) <= Branch;
          ID_EX(4) <= AluSrc;
          ID_EX(7 downto 5) <= AluOp;
          ID_EX(23 downto 8) <= RD1;
          ID_EX(39 downto 24) <= RD2;
          ID_EX(55 downto 40) <=  IF_ID(15 downto 0);
          ID_EX(71 downto 56) <= extimm;
          ID_EX(74 downto 72) <=  IF_ID(18 downto 16); -- func
          ID_EX(75) <=sa(0);
          ID_EX(78 downto 76) <= wa;
     end if;
     end if;
    end process;
    
    process(clk)
    begin 
    if rising_edge(clk) then 
        if enable ='1' then     
          EX_MEM(0) <= ID_EX(0);
          EX_MEM(1) <= ID_EX(1);
          EX_MEM(2) <= ID_EX(2);
          EX_MEM(3) <= ID_EX(3);
          EX_MEM(19 downto 4) <= ID_EX(55 downto 40);
          EX_MEM(20) <= zero;
          EX_MEM(36 downto 21) <= Alu_Rez;
          EX_MEM(52 downto 37) <= ID_EX(39 downto 24);
          EX_MEM(55 downto 53) <=  ID_EX(78 downto 76);
   end if;
   end if;
   end process;
   
   process(clk)
   begin 
   if rising_edge(clk) then 
      if enable = '1' then 
          MEM_WB(0) <= ID_EX(0) ;
          MEM_WB(1) <= ID_EX(1) ;
          MEM_WB(17 downto 2) <= mem_data;
          MEM_WB(33 downto 18) <=  EX_MEM(36 downto 21);
          MEM_WB(36 downto 34) <=  EX_MEM(55 downto 53);
    end if;
    end if;
    end process;
   
    p6: process(sw)
    begin
        case sw(7 downto 5) is
            when "000" => segAux<= adresa;
            when "001" => segAux <= adresa_urmat;
            when "010" => segAux <= rd1;
            when "011" => segAux <=  RD2;
            when "100" => segAux <= extimm;
            when "101" => segAux <= Alu_rez;
            when "110" => segAux <= mem_data;
            when "111" => segAux <= writeDataAux;
            
            when others =>
         end case;
    end process;


    p1: MPG port map(en=>enable,clk=> clk,input=>btn(0));
    p2: MPG port map(en =>reset, clk=>clk,input => btn(1)); 
   
    U1: Unitate_IF port map (clk => clk, en=>enable,res => btn(1),branch_adr => branch_adress,jump_adr =>jump_adress,adresa => adresa, adresa_urmat=> adresa_urmat, jump =>jump, PCSrc => PCSrc); 

    p4: InstructionDecode port map(clk=>clk,instruction=>adresa,wd=>writeDataAux,regWrite=> MEM_WB(1),regDst=>regDst,WaIN =>MEM_WB(36 downto 34),expOp=>extOp,rd1=>rd1,rd2=>rd2,extImm=>extImm,func=>func,wa =>wa,sa=>sa,en=>enable);

    E1: EX port map (adresa_urmat => adresa_urmat,rd1=>rd1,rd2=>rd2,clk=>clk,extImm=>extImm,func=>adresa,sa=>sa,AluSrc=>ID_EX(4),AluOp=> ID_EX(7 downto 5),branch_adress=>branch_adress,AluRez =>alu_rez,zero=>zero,Aluc=>Aluc);
      
    with MEM_WB(0) select
    writeDataAux <=alu_rez when '0', mem_data when '1';
    
    p5: ControlUnit port map(instruction=>adresa,regDst=>regDst,extOp=>extOp,branch=>branch,aluOp => aluOp,jump=>jump,memWrite=>memWrite,memToReg=>memToReg,regWrite=>regWrite,ALUsrc=>AluSrc);
    M1:MEM port map (clk=>clk,en => enable ,AluRezIn => alu_rez, rd2 => rd2, memWrite => EX_MEM(2), memData => mem_data, AluREzOut =>alu_rez);
    
    jump_adress <= "000" & adresa(12 downto 0);
    PcSrc <=   EX_MEM(3) and  EX_MEM(20) ;
    
  
    instructionAux(0) <= regDst;
    instructionAux(1) <= extOp;
    instructionAux(2) <= branch;
    instructionAux(3) <= jump;
    instructionAux(4) <= memWrite;
    instructionAux(5) <= memToReg;
    instructionAux(6) <= regWrite;
    instructionAux(9 downto 7) <= aluOp;
    instructionAux(10) <= zero;
    instructionAux(11) <= PcSrc;
    instructionAux(15 downto 13)<= MEM_WB(36 downto 34);
    led <= instructionAux;
   
    S: SSD port map(clk=> clk,an => an, cat => cat,digit=>segAux);
        
    
end Behavioral;