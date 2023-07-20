LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity RegisterFile is
	port(
	
		readReg1 : in std_logic_vector(2 downto 0);
		readReg2 : in std_logic_vector(2 downto 0);
		
		writeReg : in std_logic_vector(2 downto 0);
		writeData : in std_logic_vector(7 downto 0);
		RegWrite : in std_logic;
		
		reset : in std_logic;
		clock : in std_logic;

    readData1 : out std_logic_vector(7 downto 0);
    readData2 : out std_logic_vector(7 downto 0)
      
	);
end entity RegisterFile;

architecture rtl of RegisterFile is
  
  signal loadReg1,loadReg2,loadReg3,loadReg4,loadReg5,loadReg6,loadReg7,loadReg8 : std_logic;
  signal outReg1,outReg2,outReg3,outReg4,outReg5,outReg6,outReg7,outReg8 : std_logic_vector(7 downto 0);
  
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
  
  component mux8x1_8bits is
	 port(
	
			x0 : in std_logic_vector(7 downto 0);
			x1 : in std_logic_vector(7 downto 0);
			x2 : in std_logic_vector(7 downto 0);
			x3 : in std_logic_vector(7 downto 0);
			x4 : in std_logic_vector(7 downto 0);
			x5 : in std_logic_vector(7 downto 0);
			x6 : in std_logic_vector(7 downto 0);
			x7 : in std_logic_vector(7 downto 0);
  
			s : in std_logic_vector(2 downto 0);
    
			o : out std_logic_vector(7 downto 0)
    
	 );
  end component mux8x1_8bits;
  
  begin
    
    
    -- Writing in register --
    
    loadReg1 <= RegWrite and not(writeReg(2)) and not(writeReg(1)) and not(writeReg(0));
    loadReg2 <= RegWrite and not(writeReg(2)) and not(writeReg(1)) and writeReg(0);
    loadReg3 <= RegWrite and not(writeReg(2)) and writeReg(1) and not(writeReg(0));
    loadReg4 <= RegWrite and not(writeReg(2)) and writeReg(1) and writeReg(0);
    loadReg5 <= RegWrite and writeReg(2) and not(writeReg(1)) and not(writeReg(0));
    loadReg6 <= RegWrite and writeReg(2) and not(writeReg(1)) and writeReg(0);
    loadReg7 <= RegWrite and writeReg(2) and writeReg(1) and not(writeReg(0));
    loadReg8 <= RegWrite and writeReg(2) and writeReg(1) and writeReg(0);
    
    
    -- Registers --
    
    reg1 : entity work.bidirectional_shift_register_8bits(rtl)
            port map(writeData, '0', '0', '0', loadReg1, reset, clock, outReg1);
              
    reg2 : entity work.bidirectional_shift_register_8bits(rtl)
            port map(writeData, '0', '0', '0', loadReg2, reset, clock, outReg2);
              
    reg3 : entity work.bidirectional_shift_register_8bits(rtl)
            port map(writeData, '0', '0', '0', loadReg3, reset, clock, outReg3);
              
    reg4 : entity work.bidirectional_shift_register_8bits(rtl)
            port map(writeData, '0', '0', '0', loadReg4, reset, clock, outReg4);
              
    reg5 : entity work.bidirectional_shift_register_8bits(rtl)
            port map(writeData, '0', '0', '0', loadReg5, reset, clock, outReg5);
              
    reg6 : entity work.bidirectional_shift_register_8bits(rtl)
            port map(writeData, '0', '0', '0', loadReg6, reset, clock, outReg6);
              
    reg7 : entity work.bidirectional_shift_register_8bits(rtl)
            port map(writeData, '0', '0', '0', loadReg7, reset, clock, outReg7);
              
    reg8 : entity work.bidirectional_shift_register_8bits(rtl)
            port map(writeData, '0', '0', '0', loadReg8, reset, clock, outReg8);
   
   
   
   -- Read data values --
    
    mux2 : entity work.mux8x1_8bits(rtl)
            port map(outReg1,outReg2,outReg3,outReg4,outReg5,outReg6,outReg7,outReg8,readReg1(2 downto 0),readData1);
    
    mux3 : entity work.mux8x1_8bits(rtl)
            port map(outReg1,outReg2,outReg3,outReg4,outReg5,outReg6,outReg7,outReg8,readReg2(2 downto 0),readData2);   
end rtl;
