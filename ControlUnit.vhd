LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity ControlUnit is 
	port(

		instruction : in std_logic_vector(5 downto 0);
		
		RegDst : out std_logic;
		BranchEQ : out std_logic;
		BranchNotEQ : out std_logic;
		Jump : out std_logic;
		MemRead : out std_logic;
		MemtoReg : out std_logic;
		ALUOp : out std_logic_vector(1 downto 0);
		MemWrite : out std_logic;
		ALUSrc : out std_logic;
		RegWrite : out std_logic

	);

end entity ControlUnit;

architecture rtl of ControlUnit is
  
  signal Rtype, branchS, bne, jumpS, load, store : std_logic;
  
  begin
    
    Rtype <= not(instruction(5)) and not(instruction(4)) and not(instruction(3)) and not(instruction(2)) and not(instruction(1)) and not(instruction(0));
        
    branchS <= not(instruction(5)) and not(instruction(4)) and not(instruction(3)) and instruction(2) and not(instruction(1)) and not(instruction(0));
  
    bne <= not(instruction(5)) and not(instruction(4)) and not(instruction(3)) and instruction(2) and not(instruction(1)) and instruction(0);
    
    jumpS <= not(instruction(5)) and not(instruction(4)) and not(instruction(3)) and not(instruction(2)) and instruction(1) and not(instruction(0));
  
    load <= instruction(5) and not(instruction(4)) and not(instruction(3)) and not(instruction(2)) and instruction(1) and instruction(0);
    
    store <= instruction(5) and not(instruction(4)) and instruction(3) and not(instruction(2)) and instruction(1) and instruction(0);
   
    
    RegDst <= Rtype;
		BranchEQ <= branchS;
		BranchNotEQ <= bne;
		Jump <= jumpS;
		MemRead <= load;
		MemtoReg <= load;
		ALUOp(0) <= branchS or bne;
		ALUOp(1) <= Rtype;
		MemWrite <= store;
		ALUSrc <= load or store;
		RegWrite <= load or Rtype;
   
  
end rtl;
