LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity IFIDbuffer is
	port(
	
		pc_in : in std_logic_vector(7 downto 0);
		instruction_in : in std_logic_vector(31 downto 0);
		
		clock : in std_logic;
		reset : in std_logic;
		en : in std_logic;
		Flush : in std_logic;
    
    pc_out : out std_logic_vector(7 downto 0);
		instruction_out : out std_logic_vector(31 downto 0) 
	);
end entity IFIDbuffer;

architecture rtl of IFIDbuffer is
  
  signal rst : std_logic;
  
  component bidirectional_shift_register_8bits is
	 port(
	
		  in_n : in std_logic_vector(7 downto 0);
		  in_bit : in std_logic;
		
		  shift : in std_logic;
		  leftShift : in std_logic;
		
		  load : in std_logic;
		  reset : in std_logic;
		  clock : in std_logic;
		
		  out_vector : out std_logic_vector(7 downto 0);
	    out_n : out std_logic
	  
	 );
  end component bidirectional_shift_register_8bits;
  
  begin
    
    rst <= reset or Flush;
    
    pcBuffer : entity work.bidirectional_shift_register_8bits(rtl)
            port map(pc_in, '0', '0', '0', '1', rst, clock, pc_out);
              
    -- Instruction --
              
    instructionBuffer8 : entity work.bidirectional_shift_register_8bits(rtl)
            port map(instruction_in(7 downto 0), '0', '0', '0', en, rst, clock, instruction_out(7 downto 0));
              
    instructionBuffer16 : entity work.bidirectional_shift_register_8bits(rtl)
            port map(instruction_in(15 downto 8), '0', '0', '0', en, rst, clock, instruction_out(15 downto 8));
              
    instructionBuffer24 : entity work.bidirectional_shift_register_8bits(rtl)
            port map(instruction_in(23 downto 16), '0', '0', '0', en, rst, clock, instruction_out(23 downto 16));
              
    instructionBuffer32 : entity work.bidirectional_shift_register_8bits(rtl)
            port map(instruction_in(31 downto 24), '0', '0', '0', en, rst, clock, instruction_out(31 downto 24));
   
   
end rtl;
