library ieee;
use ieee.std_logic_1164.all;

entity IFIDbuffer_TB is -- testbenches NEVER have ports!
end IFIDbuffer_TB;

architecture testbench of IFIDbuffer_TB is

        signal CLK_TB, RST_TB, Flush_TB : std_logic; -- control signal for testbench
        signal pc_in_TB, pc_out_TB : std_logic_vector(7 downto 0);
        signal instruction_in_TB, instruction_out_TB : std_logic_vector(31 downto 0);
        signal sim_end : boolean := false;
        
        component IFIDbuffer is
	       port(
	
		        		pc_in : in std_logic_vector(7 downto 0);
		          instruction_in : in std_logic_vector(31 downto 0);
		
		          clock : in std_logic;
		          reset : in std_logic;
		          Flush : in std_logic;
    
              pc_out : out std_logic_vector(7 downto 0);
		          instruction_out : out std_logic_vector(31 downto 0) 
	  
	         );
        end component IFIDbuffer;
        
        constant period: time := 50 ns; -- used to set the time period for our clock
        
        begin
          buff : IFIDbuffer
                      port map(
	                         
	                         	pc_in => pc_in_TB,
		                        instruction_in => instruction_in_TB,
		                        clock => CLK_TB,
		                        reset => RST_TB,
		                        Flush => Flush_TB,                            
		                        pc_out => pc_out_TB,
		                        instruction_out => instruction_out_TB
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
                  pc_in_TB <= "00000000";
                  instruction_in_TB <= "10101010101010101010101010101010";
                  wait for period;
                  pc_in_TB <= "00000100";
                  instruction_in_TB <= "00000000000000000000000000000000";
                  wait for period;
                  pc_in_TB <= "00001000";
                  instruction_in_TB <= "01010101010101010101010101010101";
                  wait for period;
                  pc_in_TB <= "00001100";
                  instruction_in_TB <= "11111111111111111111111111111111";
                  wait for period;
                  Flush_TB <= '1';
                  wait for period;
                  wait for period;
                  sim_end <= true; -- signal the end of the stimuli
                  wait;
          end process;

end testbench;



