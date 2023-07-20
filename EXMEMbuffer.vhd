LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity EXMEMbuffer is
	port(
	
		MemToReg_in : in std_logic;
		RegWrite_in : in std_logic;
		MemRead_in : in std_logic;
		MemWrite_in : in std_logic;
		
		aluResult_in : in std_logic_vector(7 downto 0);
		writeReg_in : in std_logic_vector(2 downto 0);
		
		clock : in std_logic;
		reset : in std_logic;
    
    MemToReg_out : out std_logic;
		RegWrite_out : out std_logic;
		MemRead_out : out std_logic;
		MemWrite_out : out std_logic;
    
    aluResult_out : out std_logic_vector(7 downto 0);
		writeReg_out : out std_logic_vector(2 downto 0)
	);
end entity EXMEMbuffer;

architecture rtl of EXMEMbuffer is
  
  signal reg_in, reg_out : std_logic_vector(7 downto 0) := "00000000";
  
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
    
    reg_in(2 downto 0) <= writeReg_in;
    reg_in(3) <= MemToReg_in;
    reg_in(4) <= RegWrite_in;
    reg_in(5) <= MemRead_in;
    reg_in(6) <= MemWrite_in;
              
    aluR : entity work.bidirectional_shift_register_8bits(rtl)
            port map(aluResult_in, '0', '0', '0', '1', reset, clock, aluResult_out);
        
    reg : entity work.bidirectional_shift_register_8bits(rtl)
            port map(reg_in, '0', '0', '0', '1', reset, clock, reg_out);
              
    writeReg_out <= reg_out(2 downto 0);
    MemToReg_out <= reg_out(3);
    RegWrite_out <= reg_out(4);
    MemRead_out <= reg_out(5);
    MemWrite_out <= reg_out(6);
   
end rtl;



