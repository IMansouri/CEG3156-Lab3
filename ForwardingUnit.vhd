LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity ForwardingUnit is
	port(
	
      IDEXrs : in std_logic_vector(2 downto 0);
      IDEXrt : in std_logic_vector(2 downto 0);
      
      EXMEMrd : in std_logic_vector(2 downto 0);
      EXMEMregDst : in std_logic;
      
      MEMWBrd : in std_logic_vector(2 downto 0);
      MEMWBregDst : in std_logic;
      
      ALUSrc : in std_logic;
      
      aluAmux : out std_logic_vector(1 downto 0);
      aluBmux : out std_logic_vector(1 downto 0)

	);
end entity ForwardingUnit;

architecture rtl of ForwardingUnit is
  
  signal MEMWBrdIDEXrs, MEMWBrdIDEXrt, EXMEMrdIDEXrs, EXMEMrdIDEXrt: std_logic;
  
  component compare3bits is
	 port(
	
		x : in std_logic_vector(2 downto 0);
		y : in std_logic_vector(2 downto 0);
		
		eq : out std_logic
    
	);
  end component compare3bits;
  
  begin
    
    --000 <- read data 1
    --001 <- WB alu result
    --010 <- MEM alu result
    
    --000 <- read data 2
    --001 <- WB alu result
    --010 <- MEM alu result
    
    comp1 : entity work.compare3bits(rtl)
              port map(MEMWBrd, IDEXrs, MEMWBrdIDEXrs);
    
    comp2 : entity work.compare3bits(rtl)
              port map(MEMWBrd, IDEXrt, MEMWBrdIDEXrt);
    
    comp3 : entity work.compare3bits(rtl)
              port map(EXMEMrd, IDEXrs, EXMEMrdIDEXrs);
                
    comp4 : entity work.compare3bits(rtl)
              port map(EXMEMrd, IDEXrt, EXMEMrdIDEXrt);
                          
    aluAmux(0) <= (not(EXMEMregDst) and MEMWBregDst and (MEMWBrdIDEXrs)) or ALUSrc;
    aluAmux(1) <= (EXMEMregDst and (EXMEMrdIDEXrs)) or ALUSrc;
    
    aluBmux(0) <= (not(EXMEMregDst) and MEMWBregDst and (MEMWBrdIDEXrt)) or ALUSrc;
    aluBmux(1) <= (EXMEMregDst and (EXMEMrdIDEXrt))or ALUSrc;
       
end rtl;
