LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity HazardUnit is
	port(
	
      instruction : in std_logic_vector(31 downto 0);
      IDEXrt : in std_logic_vector(2 downto 0);
      IDEXmemRead : in std_logic;
      ReadDataEQ : in std_logic;
      branchEQ : in std_logic;
      branchNEQ : in std_logic;
      jump : in std_logic;
      
      controlMux : out std_logic;
      IFIDen : out std_logic;
      IFIDflush : out std_logic;
      addrSelect : out std_logic_vector(1 downto 0)
      

	);
end entity HazardUnit;

architecture rtl of HazardUnit is

  signal rs, rt : std_logic_vector(2 downto 0);
  signal eq1,eq2,stall : std_logic;
  
  component compare3bits is
	 port(
	
		x : in std_logic_vector(2 downto 0);
		y : in std_logic_vector(2 downto 0);
		
		eq : out std_logic
    
	);
  end component compare3bits;
  
  begin
    
    rs <= instruction(23 downto 21);
    rt <= instruction(18 downto 16);
    
    comp1 : entity work.compare3bits(rtl)
              port map(IDEXrt, rs, eq1);
                
    comp2 : entity work.compare3bits(rtl)
              port map(IDEXrt, rt, eq2);
                
    stall <= (IDEXmemRead and (eq1 or eq2)) or (branchEQ and ReadDataEQ) or (branchNEQ and not(ReadDataEQ)) or jump;
    IFIDen <= not(stall);
    
    IFIDflush <= (branchEQ and ReadDataEQ) or (branchNEQ and not(ReadDataEQ)) or jump;
    
    controlMux <= stall;
    
    addrSelect(1) <= (branchEQ and ReadDataEQ) or (branchNEQ and not(ReadDataEQ));
    addrSelect(0) <= jump;
       
end rtl;

