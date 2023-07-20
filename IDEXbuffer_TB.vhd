library ieee;
use ieee.std_logic_1164.all;

entity IDEXbuffer_TB is -- testbenches NEVER have ports!
end IDEXbuffer_TB;

architecture testbench of IDEXbuffer_TB is

        signal CLK_TB, RST_TB : std_logic; -- control signal for testbench
        signal MemToReg_in_TB,MemToReg_out_TB,RegWrite_in_TB,RegWrite_out_TB,MemRead_in_TB,MemRead_out_TB : std_logic;
        signal MemWrite_in_TB, MemWrite_out_TB, ALUSrc_in_TB,ALUSrc_out_TB, RegDst_in_TB, RegDst_out_TB : std_logic;
        signal ALUOp_in_TB, ALUOp_out_TB : std_logic_vector(1 downto 0);
        signal readData1_in_TB,readData1_out_TB,readData2_in_TB,readData2_out_TB,signReducedAddress_in_TB,signReducedAddress_out_TB : std_logic_vector(7 downto 0);
        signal rd_in_TB,rd_out_TB,rt_in_TB,rt_out_TB,rs_in_TB,rs_out_TB : std_logic_vector(2 downto 0);
        signal sim_end : boolean := false;
        
component IDEXbuffer is
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
end component IDEXbuffer;
        
        constant period: time := 50 ns; -- used to set the time period for our clock
        
        begin
          buff : IDEXbuffer
                      port map(
	                         
		MemToReg_in => MemToReg_in_TB,
		RegWrite_in => RegWrite_in_TB,
		MemRead_in => MemRead_in_TB,
		MemWrite_in => MemWrite_in_TB,
		ALUSrc_in => ALUSrc_in_TB,
		ALUOp_in => ALUOp_in_TB,
		RegDst_in => RegDst_in_TB,
		
		readData1_in => readData1_in_TB,
		readData2_in => readData2_in_TB,
		signReducedAddress_in => signReducedAddress_in_TB,
		rs_in => rs_in_TB,
		rt_in => rt_in_TB,
		rd_in => rd_in_TB,
		
		clock => CLK_TB,
		reset => RST_TB,
    
    MemToReg_out => MemToReg_out_TB,
		RegWrite_out => RegWrite_out_TB,
		MemRead_out => MemRead_out_TB,
		MemWrite_out => MemWrite_out_TB,
		ALUSrc_out => ALUSrc_out_TB,
		ALUOp_out => ALUOp_out_TB,
		RegDst_out => RegDst_out_TB,
    
    readData1_out => readData1_out_TB,
    readData2_out => readData2_out_TB,
		signReducedAddress_out => signReducedAddress_out_TB,
		rs_out => rs_out_TB,
		rt_out => rt_out_TB,
		rd_out => rd_out_TB
	                     );
                      
          
          -- this is our clock process to simulate the clock. It will toggle
          -- every half period (which we defined earlier)
          
          clock_process : process
                begin
                  while (not sim_end) loop
                    CLK_TB <= '1';
                    wait for period/2;
                    CLK_TB <= '0';
                    wait for period/2;
                  end loop;
                  wait;
          end process;

          testbench_process : process
                begin
                  
                  RST_TB <= '0', '1' after period;
                  MemToReg_in_TB <= '1';
		              RegWrite_in_TB <= '1';
		              MemRead_in_TB <= '1';
		              MemWrite_in_TB <= '1';
		              ALUSrc_in_TB <= '1';
		              ALUOp_in_TB <= "11";
		              RegDst_in_TB <= '1';
		
		              readData1_in_TB <= "01010101";
		              readData2_in_TB <= "10101010";
		              signReducedAddress_in_TB <= "11111111";
		              rd_in_TB <= "010";
		              rt_in_TB <= "101";
		              rs_in_TB <= "100";
                
                  wait for period;
                  
                  MemToReg_in_TB <= '0';
		              RegWrite_in_TB <= '1';
		              MemRead_in_TB <= '0';
		              MemWrite_in_TB <= '1';
		              ALUSrc_in_TB <= '0';
		              ALUOp_in_TB <= "00";
		              RegDst_in_TB <= '1';
		
		              readData1_in_TB <= "11111111";
		              readData2_in_TB <= "00000000";
		              signReducedAddress_in_TB <= "10101010";
		              rd_in_TB <= "000";
		              rt_in_TB <= "111";
		              rs_in_TB <= "001";
                
                  wait for period;
                  
                  MemToReg_in_TB <= '1';
		              RegWrite_in_TB <= '0';
		              MemRead_in_TB <= '1';
		              MemWrite_in_TB <= '0';
		              ALUSrc_in_TB <= '1';
		              ALUOp_in_TB <= "01";
		              RegDst_in_TB <= '0';
		
		              readData1_in_TB <= "00000000";
		              readData2_in_TB <= "11111111";
		              signReducedAddress_in_TB <= "01010101";
		              rd_in_TB <= "001";
		              rt_in_TB <= "000";
		              rs_in_TB <= "100";
                
                  wait for period;
                  sim_end <= true; -- signal the end of the stimuli
                  wait;
          end process;

end testbench;
