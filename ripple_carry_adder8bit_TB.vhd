library ieee;
use ieee.std_logic_1164.all;

entity ripple_carry_adder8bit_TB is -- testbenches NEVER have ports!
end ripple_carry_adder8bit_TB;

architecture testbench of ripple_carry_adder8bit_TB is
        
        signal x_vector_TB, y_vector_TB, s_vector_TB : std_logic_vector(7 downto 0);
        signal c_in_TB, overflowFlag_TB, c_out_TB : std_logic;
        signal sim_end : boolean := false;
        
        component ripple_carry_adder8bit is 
	       port(

		          c_in : in std_logic;
		          x_vector : in std_logic_vector(7 downto 0);
		          y_vector : in std_logic_vector(7 downto 0);
		
		          s_vector : out std_logic_vector(7 downto 0);
		          overflowFlag : out std_logic;
		          c_out : out std_logic

	       );

        end component ripple_carry_adder8bit;
        
        constant period: time := 50 ns; -- used to set the time period for our clock
        
        begin
          alu : ripple_carry_adder8bit
                      port map(
	                         
	                         c_in => c_in_TB,
		                       x_vector => x_vector_TB,
		                       y_vector => y_vector_TB,
		
		                       s_vector => s_vector_TB,
		                       overflowFlag => overflowFlag_TB,
		                       c_out => c_out_TB
	                         
	                     );
         

          testbench_process : process
                begin
    
                  c_in_TB <= '1';
                  x_vector_TB <= "00110000";
                  y_vector_TB <= "11001111";
                  
                  wait for period;
                  sim_end <= true; -- signal the end of the stimuli
                  wait;
          end process;
end testbench;

