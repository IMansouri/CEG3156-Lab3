library ieee;
use ieee.std_logic_1164.all;

entity HazardUnit_TB is -- testbenches NEVER have ports!
end HazardUnit_TB;

architecture testbench of HazardUnit_TB is
        
        signal instruction_TB : std_logic_vector(31 downto 0);
        signal addrSelect_TB : std_logic_vector(1 downto 0);
        signal IDEXrt_TB : std_logic_vector(2 downto 0);
        signal IDEXmemRead_TB,ReadDataEQ_TB,branchEQ_TB,branchNEQ_TB,controlMux_TB,IFIDen_TB,IFIDflush_TB,jump_TB : std_logic;
        signal sim_end : boolean := false;
        
        component HazardUnit is 
	       port(

      instruction : in std_logic_vector(31 downto 0);
      IDEXrt : in std_logic_vector(2 downto 0);
      IDEXmemRead : in std_logic;
      ReadDataEQ : in std_logic;
      branchEQ : in std_logic;
      branchNEQ : in std_logic;
      jump : in std_logic;
      
      controlMux : out std_logic;
      IFIDen : out std_logic;
      IFIDflush : out std_logic;
      addrSelect : out std_logic_vector(1 downto 0)

	       );

        end component HazardUnit;
        
        constant period: time := 50 ns; -- used to set the time period for our clock
        
        begin
          forwUnit : HazardUnit
                      port map(
	                         
      instruction => instruction_TB,
      IDEXrt => IDEXrt_TB,
      IDEXmemRead => IDEXmemRead_TB,
      ReadDataEQ => ReadDataEQ_TB,
      branchEQ => branchEQ_TB,
      branchNEQ => branchNEQ_TB,
      jump => jump_TB,
      
      controlMux => controlMux_TB,
      IFIDen => IFIDen_TB,
      IFIDflush => IFIDflush_TB,
      addrSelect => addrSelect_TB
	                     );
         

          testbench_process : process
                begin
                  
                  instruction_TB <= "00010011111111111111111111111111"; --Branch equal taken
                  IDEXrt_TB <= "000";
                  IDEXmemRead_TB <= '0';
                  branchEQ_TB <= '1';
                  branchNEQ_TB <= '0';
                  ReadDataEQ_TB <= '1';
                  jump_TB <= '0';
                  wait for period;
                  
                  instruction_TB <= "00010011101111111111111111111111"; --Branch equal not taken
                  ReadDataEQ_TB <= '0';
                  wait for period;
                  
                  instruction_TB <= "00010100100000000000000000000000"; --Branch not equal not taken
                  branchEQ_TB <= '0';
                  branchNEQ_TB <= '1';
                  ReadDataEQ_TB <= '1';
                  wait for period;
                  
                  instruction_TB <= "00010100000000000000000000000000"; --Branch not equal taken
                  ReadDataEQ_TB <= '0';
                  wait for period;
                  
                  instruction_TB <= "10001100010111111111111111111111"; --stall with lw : IDEXrt = rs
                  IDEXrt_TB <= "010";
                  IDEXmemRead_TB <= '1';
                  branchEQ_TB <= '0';
                  branchNEQ_TB <= '0';
                  ReadDataEQ_TB <= '1';
                  wait for period;
                  
                  instruction_TB <= "10001100000001101111111111111111"; --stall with lw : IDEXrt = rt
                  IDEXrt_TB <= "110";
                  wait for period;
                  
                  instruction_TB <= "10001100000001101111111111111111"; --no stall with lw
                  IDEXrt_TB <= "001";
                  wait for period;
                  
                  instruction_TB <= "00001000000001101111111111111111"; --jump
                  jump_TB <= '1';
                  wait for period;
                  sim_end <= true; -- signal the end of the stimuli
                  wait;
          end process;

end testbench;
