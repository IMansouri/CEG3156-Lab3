library ieee;
use ieee.std_logic_1164.all;

entity ForwardingUnit_TB is -- testbenches NEVER have ports!
end ForwardingUnit_TB;

architecture testbench of ForwardingUnit_TB is
        
        signal IDEXrs_TB,IDEXrt_TB,EXMEMrd_TB,MEMWBrd_TB : std_logic_vector(2 downto 0);
        signal EXMEMregDst_TB, MEMWBregDst_TB,ALUSrc_TB : std_logic;
        signal aluAmux_TB, aluBmux_TB : std_logic_vector(1 downto 0);
        signal sim_end : boolean := false;
        
        component ForwardingUnit is 
	       port(

      IDEXrs : in std_logic_vector(2 downto 0);
      IDEXrt : in std_logic_vector(2 downto 0);
      
      EXMEMrd : in std_logic_vector(2 downto 0);
      EXMEMregDst : in std_logic;
      
      MEMWBrd : in std_logic_vector(2 downto 0);
      MEMWBregDst : in std_logic;
      
      ALUSrc : in std_logic;
      
      aluAmux : out std_logic_vector(1 downto 0);
      aluBmux : out std_logic_vector(1 downto 0)

	       );

        end component ForwardingUnit;
        
        constant period: time := 50 ns; -- used to set the time period for our clock
        
        begin
          forwUnit : ForwardingUnit
                      port map(
	                         
      IDEXrs => IDEXrs_TB,
      IDEXrt => IDEXrt_TB,
      
      EXMEMrd => EXMEMrd_TB,
      EXMEMregDst => EXMEMregDst_TB,
      
      MEMWBrd => MEMWBrd_TB,
      MEMWBregDst => MEMWBregDst_TB,
      
      ALUSrc => ALUSrc_TB,
      
      aluAmux => aluAmux_TB,
      aluBmux => aluBmux_TB
	                     );
         

          testbench_process : process
                begin
                  
                  ALUSrc_TB <= '0';
                  MEMWBrd_TB <= "000";
                  MEMWBregDst_TB <= '0';
                  IDEXrs_TB <= "010"; --Forward A from EXMEM buffer (10)
                  IDEXrt_TB <= "100";
                  EXMEMrd_TB <= "010";
                  EXMEMregDst_TB <= '1';
                  wait for period;
                  
                  IDEXrs_TB <= "010"; --Forward B from EXMEM buffer (10)
                  IDEXrt_TB <= "100";
                  EXMEMrd_TB <= "100";
                  wait for period;
                  
                  IDEXrs_TB <= "010"; --Forward A from MEMWB buffer (01)
                  IDEXrt_TB <= "100";
                  EXMEMregDst_TB <= '0';
                  MEMWBregDst_TB <= '1';
                  MEMWBrd_TB <= "010";
                  wait for period;
                  
                  IDEXrs_TB <= "010"; --Forward B from MEMWB buffer (01)
                  IDEXrt_TB <= "100";
                  EXMEMregDst_TB <= '0';
                  EXMEMrd_TB <= "010";
                  MEMWBregDst_TB <= '1';
                  MEMWBrd_TB <= "100";
                  wait for period;
                  
                  IDEXrs_TB <= "010"; --Prioritising EXMEM buffer
                  IDEXrt_TB <= "100";
                  EXMEMregDst_TB <= '1';
                  EXMEMrd_TB <= "010";
                  MEMWBregDst_TB <= '1';
                  MEMWBrd_TB <= "010";
                  wait for period;
                  
                  IDEXrs_TB <= "010"; --No forwarding
                  IDEXrt_TB <= "100";
                  EXMEMregDst_TB <= '1';
                  EXMEMrd_TB <= "000";
                  MEMWBregDst_TB <= '1';
                  MEMWBrd_TB <= "000";
                  wait for period;
                  
                  ALUSrc_TB <= '1'; --ALUSrc = 1
                  wait for period;
                  sim_end <= true; -- signal the end of the stimuli
                  wait;
          end process;

end testbench;

