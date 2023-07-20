LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity IDEXbuffer is
	port(
	
		MemToReg_in : in std_logic;
		RegWrite_in : in std_logic;
		MemRead_in : in std_logic;
		MemWrite_in : in std_logic;
		ALUSrc_in : in std_logic;
		ALUOp_in : in std_logic_vector(1 downto 0);
		RegDst_in : in std_logic;
		
		readData1_in : in std_logic_vector(7 downto 0);
		readData2_in : in std_logic_vector(7 downto 0);
		signReducedAddress_in : in std_logic_vector(7 downto 0);
		rs_in : in std_logic_vector(2 downto 0);
		rt_in : in std_logic_vector(2 downto 0);
		rd_in : in std_logic_vector(2 downto 0);
		
		clock : in std_logic;
		reset : in std_logic;
    
    MemToReg_out : out std_logic;
		RegWrite_out : out std_logic;
		MemRead_out : out std_logic;
		MemWrite_out : out std_logic;
		ALUSrc_out : out std_logic;
		ALUOp_out : out std_logic_vector(1 downto 0);
		RegDst_out : out std_logic;
    
    readData1_out : out std_logic_vector(7 downto 0);
    readData2_out : out std_logic_vector(7 downto 0);
		signReducedAddress_out : out std_logic_vector(7 downto 0);
		rs_out : out std_logic_vector(2 downto 0);
		rt_out : out std_logic_vector(2 downto 0);
		rd_out : out std_logic_vector(2 downto 0)
	);
end entity IDEXbuffer;

architecture rtl of IDEXbuffer is
  
  signal reg_in, reg_out,reg2_in, reg2_out,reg3_in, reg3_out : std_logic_vector(7 downto 0) := "00000000";
  
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
    
    reg_in(2 downto 0) <= rd_in;
    reg_in(5 downto 3) <= rt_in;
    reg_in(7 downto 6) <= ALUOp_in;
    
    reg2_in(2 downto 0) <= rs_in;
    reg2_in(3) <= MemToReg_in;
    reg2_in(4) <= RegWrite_in;
    reg2_in(5) <= MemRead_in;
    reg2_in(6) <= MemWrite_in;
    reg2_in(7) <= ALUSrc_in;
    
    reg3_in(0) <= RegDst_in;
		                          
    read1 : entity work.bidirectional_shift_register_8bits(rtl)
            port map(readData1_in(7 downto 0), '0', '0', '0', '1', reset, clock, readData1_out(7 downto 0));
              
    read2 : entity work.bidirectional_shift_register_8bits(rtl)
            port map(readData2_in(7 downto 0), '0', '0', '0', '1', reset, clock, readData2_out(7 downto 0));
              
    signReducedAddress : entity work.bidirectional_shift_register_8bits(rtl)
            port map(signReducedAddress_in(7 downto 0), '0', '0', '0', '1', reset, clock, signReducedAddress_out(7 downto 0));
              
    reg : entity work.bidirectional_shift_register_8bits(rtl)
            port map(reg_in, '0', '0', '0', '1', reset, clock, reg_out);
              
    reg2 : entity work.bidirectional_shift_register_8bits(rtl)
            port map(reg2_in, '0', '0', '0', '1', reset, clock, reg2_out);
              
    reg3 : entity work.bidirectional_shift_register_8bits(rtl)
            port map(reg3_in, '0', '0', '0', '1', reset, clock, reg3_out);
              
    rd_out <= reg_out(2 downto 0);
    rt_out <= reg_out(5 downto 3);
    ALUOp_out  <= reg_out(7 downto 6);
   
    rs_out <= reg2_out(2 downto 0);
    MemToReg_out <= reg2_out(3);
    RegWrite_out <= reg2_out(4);
    MemRead_out <= reg2_out(5);
    MemWrite_out <= reg2_out(6);
    ALUSrc_out <= reg2_out(7);
    
    RegDst_out <= reg3_out(0);
   
end rtl;


