library ieee;
use ieee.std_logic_1164.all;

entity RegisterFile_TB is -- testbenches NEVER have ports!
end RegisterFile_TB;

architecture testbench of RegisterFile_TB is

        signal CLK_TB, RST_TB : std_logic; -- control signal for testbench
        signal RegWrite_TB : std_logic;
        signal readReg1_TB, readReg2_TB, writeReg_TB, writeData_TB, readData1_TB, readData2_TB : std_logic_vector(7 downto 0);
        signal sim_end : boolean := false;
        
        component RegisterFile is
	         port(
	
		          readReg1 : in std_logic_vector(7 downto 0);
		          readReg2 : in std_logic_vector(7 downto 0);
		
		          writeReg : in std_logic_vector(7 downto 0);
		          writeData : in std_logic_vector(7 downto 0);
		          RegWrite : in std_logic;
		
		          reset : in std_logic;
		          clock : in std_logic;

              readData1 : out std_logic_vector(7 downto 0);
              readData2 : out std_logic_vector(7 downto 0)
      
	         );
        end component RegisterFile;
        
        constant period: time := 50 ns; -- used to set the time period for our clock
        
        begin
          regFile : RegisterFile
                      port map(
	                         
	                         readReg1 => readReg1_TB,
		                       readReg2 => readReg2_TB,
		
		                       writeReg => writeReg_TB,
		                       writeData => writeData_TB,
		                       RegWrite => RegWrite_TB,
		
		                       reset => RST_TB,
		                       clock => CLK_TB,

                          readData1 => readData1_TB,
                          readData2 => readData2_TB
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
                  RegWrite_TB <= '1';
                  writeReg_TB <= "00000000";
                  writeData_TB <= "00000000";
                  wait for period; -- we let the clock and reset signal stabilize
                  
                  writeReg_TB <= "00000001";
                  writeData_TB <= "00000001";
                  
                  wait for period;
                  
                  readReg1_TB <= "00000000";
                  readReg2_TB <= "00000001";
                  
                  writeReg_TB <= "00000010";
                  writeData_TB <= "00000010";
                  
                  wait for period;
                  
                  writeReg_TB <= "00000011";
                  writeData_TB <= "00000011";
                  
                  wait for period;
                  
                  readReg1_TB <= "00000010";
                  readReg2_TB <= "00000011";
                  
                  writeReg_TB <= "00000100";
                  writeData_TB <= "00000100";
                  
                  wait for period;
                  
                  writeReg_TB <= "00000101";
                  writeData_TB <= "00000101";
                  
                  wait for period;
                  
                  readReg1_TB <= "00000100";
                  readReg2_TB <= "00000101";
                  
                  writeReg_TB <= "00000110";
                  writeData_TB <= "00000110";
                  
                  wait for period;
                  
                  writeReg_TB <= "00000111";
                  writeData_TB <= "00000111";
                  
                  wait for period;
                  
                  readReg1_TB <= "00000110";
                  readReg2_TB <= "00000111";
                  
                  wait for period;
                  wait for period;
                  
                  
                  wait for period;
                  wait for period;
                  wait for period;
                  wait for period;
                  wait for period;
                  wait for period;
                  wait for period;
                  wait for period;
                  sim_end <= true; -- signal the end of the stimuli
                  wait;
          end process;

end testbench;



