library ieee;
use ieee.std_logic_1164.all;

entity mux8x1_8bits_TB is -- testbenches NEVER have ports!
end mux8x1_8bits_TB;

architecture testbench of mux8x1_8bits_TB is
        
        signal x0_TB,x1_TB,x2_TB,x3_TB,x4_TB,x5_TB,x6_TB,x7_TB, o_TB : std_logic_vector(7 downto 0);
        signal s_TB : std_logic_vector(2 downto 0);
        signal sim_end : boolean := false;
        
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
        
        constant period: time := 50 ns; -- used to set the time period for our clock
        
        begin
          cu : mux8x1_8bits
                      port map(
	                         
	                        x0 => x0_TB,
                          x1 => x1_TB,
                          x2 => x2_TB,
                          x3 => x3_TB,
                          x4 => x4_TB,
                          x5 => x5_TB,
                          x6 => x6_TB,
                          x7 => x7_TB,
    
                          s => s_TB,
    
                          o => o_TB
	                     );
         

          testbench_process : process
                begin
                  
                  x0_TB <= "00000000";
                  x1_TB <= "00100000";
                  x2_TB <= "01000000";
                  x3_TB <= "01100000";
                  x4_TB <= "10000000";
                  x5_TB <= "10100000";
                  x6_TB <= "11000000";
                  x7_TB <= "11100000";
                  
                  s_TB <= "000";
                  wait for period;
                  s_TB <= "001";
                  wait for period;
                  s_TB <= "010";
                  wait for period;
                  s_TB <= "011";
                  wait for period;
                  s_TB <= "100";
                  wait for period;
                  s_TB <= "101";
                  wait for period;
                  s_TB <= "110";
                  wait for period;
                  s_TB <= "111";
                  wait for period;
                  
                  sim_end <= true; -- signal the end of the stimuli
                  wait;
          end process;

end testbench;
