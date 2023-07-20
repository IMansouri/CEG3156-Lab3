library ieee;
use ieee.std_logic_1164.all;

entity MEMWBbuffer_TB is -- testbenches NEVER have ports!
end MEMWBbuffer_TB;

architecture testbench of MEMWBbuffer_TB is

        signal CLK_TB, RST_TB : std_logic; -- control signal for testbench
        signal MemToReg_in_TB,MemToReg_out_TB,RegWrite_in_TB,RegWrite_out_TB : std_logic;
        signal aluResult_out_TB,aluResult_in_TB, data_in_TB,data_out_TB : std_logic_vector(7 downto 0);
        signal writeReg_in_TB,writeReg_out_TB : std_logic_vector(2 downto 0);
        signal sim_end : boolean := false;
        
component MEMWBbuffer is
	port(
	
		MemToReg_in : in std_logic;
		RegWrite_in : in std_logic;
		
		aluResult_in : in std_logic_vector(7 downto 0);
    data_in : in std_logic_vector(7 downto 0);
		writeReg_in : in std_logic_vector(2 downto 0);
		
		clock : in std_logic;
		reset : in std_logic;
    
    MemToReg_out : out std_logic;
		RegWrite_out : out std_logic;
    
    aluResult_out : out std_logic_vector(7 downto 0);
    data_out : out std_logic_vector(7 downto 0);
		writeReg_out : out std_logic_vector(2 downto 0)
	);
end component MEMWBbuffer;
        
        constant period: time := 50 ns; -- used to set the time period for our clock
        
        begin
          buff : MEMWBbuffer
                      port map(
	                         
		MemToReg_in => MemToReg_in_TB,
		RegWrite_in => RegWrite_in_TB,
		
		aluResult_in => aluResult_in_TB,
		data_in => data_in_TB,
		writeReg_in => writeReg_in_TB,
		
		clock => CLK_TB,
		reset => RST_TB,
    
    MemToReg_out => MemToReg_out_TB,
		RegWrite_out => RegWrite_out_TB,
    
    aluResult_out => aluResult_out_TB,
    data_out => data_out_TB,
		writeReg_out => writeReg_out_TB
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
		
		              aluResult_in_TB <= "01010101";
		              data_in_TB <= "11110000";
		              writeReg_in_TB <= "001";
                
                  wait for period;
                  
                  MemToReg_in_TB <= '0';
		              RegWrite_in_TB <= '1';
		
		              aluResult_in_TB <= "11111111";
		              data_in_TB <= "01010101";
		              writeReg_in_TB <= "110";
                
                  wait for period;
                  
                  MemToReg_in_TB <= '1';
		              RegWrite_in_TB <= '0';
		
		              aluResult_in_TB <= "10101010";
		              data_in_TB <= "10010011";
		              writeReg_in_TB <= "000";
                
                  wait for period;
                  sim_end <= true; -- signal the end of the stimuli
                  wait;
          end process;

end testbench;
