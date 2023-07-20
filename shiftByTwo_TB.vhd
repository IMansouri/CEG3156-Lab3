library ieee;
use ieee.std_logic_1164.all;

entity shiftByTwo_TB is -- testbenches NEVER have ports!
end shiftByTwo_TB;

architecture testbench of shiftByTwo_TB is

        signal CLK_TB, RST_TB, LD_TB : std_logic; -- control signal for testbench
        signal in_bit_TB, leftShift_TB : std_logic;
        signal out_n_TB, shift_TB : std_logic;
        signal in_n_TB, out_vector_TB : std_logic_vector(7 downto 0);
        signal sim_end : boolean := false;
        
        component shiftByTwo is
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
        end component shiftByTwo;
        
        constant period: time := 50 ns; -- used to set the time period for our clock
        
        begin
          bdSR : shiftByTwo
                      port map(
	                         
	                         in_n => in_n_TB,
	                         in_bit => in_bit_TB,
	                         shift => shift_TB,
	                         leftShift => leftShift_TB,
	                         load => LD_TB,
	                         reset => RST_TB,
	                         clock => CLK_TB,
	                         out_vector => out_vector_TB,
	                         out_n => out_n_TB
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
                  LD_TB <= '0', '1' after period;
                  shift_TB <= '0';
                  in_n_TB <= "00000001";
                  in_bit_TB <= '0';
                  leftShift_TB <= '1';
                  wait for period; -- we let the clock and reset signal stabilize
                  
                  wait for period;
                  shift_TB <= '1';
                  wait for period;
                  wait for period;
                  wait for period;
                  wait for period;
                  wait for period;
                  wait for period;
                  wait for period;
                  wait for period;
                  
                  in_bit_TB <= '1';
                  leftShift_TB <= '0';
                  
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



