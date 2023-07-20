library ieee;
use ieee.std_logic_1164.all;

entity pipelinedProc_TB is -- testbenches NEVER have ports!
end pipelinedProc_TB;

architecture testbench of pipelinedProc_TB is

        signal CLK_TB, RST_TB : std_logic; -- control signal for testbench
        
        signal flush_out_TB,IFIDen_out_TB,IDEXMemToReg_TB,IDEXRegWrite_TB,
                IDEXMemRead_TB,IDEXMemWrite_TB,IDEXALUSrc_TB,IDEXRegDst_TB,EXMEMMemToReg_TB,EXMEMRegWrite_TB,EXMEMMemRead_TB,
                EXMEMMemWrite_TB,MEMWBMemToReg_TB,MEMWBRegWrite_TB : std_logic;
        signal pcValue_out_TB,IDEXreadData1_TB,IDEXreadData2_TB,IDEXsignReducedAddress_TB,EXMEMaluResult_TB,aluA_out_TB,
               aluB_out_TB,aluResult_out_TB,MEMWBaluResult_TB,MEMWBwriteData_TB,writeData_out_TB : std_logic_vector(7 downto 0);
        signal IFinstruction_TB,IDinstruction_TB,EXinstruction_TB,MEMinstruction_TB,WBinstruction_TB : std_logic_vector(31 downto 0);
        signal IDEXrs_output_TB,IDEXrt_output_TB,IDEXrd_output_TB,MEMWBwriteReg_TB,EXMEMwriteReg_TB : std_logic_vector(2 downto 0);
        signal muxAddrSelect_out_TB,selectMux_TB : std_logic_vector(1 downto 0);
        signal sim_end : boolean := false;
        
        component pipelinedProc is
	       port(
		GClock : in std_logic;
		GReset : in std_logic;
		
		pcValue_out : out std_logic_vector(7 downto 0);
		IFinstruction : out std_logic_vector(31 downto 0);
		flush_out,IFIDen_out,IDEXALUSrc,IDEXRegDst : out std_logic;
    IDEXreadData1,IDEXreadData2,IDEXsignReducedAddress : out std_logic_vector(7 downto 0);
    IDEXrs_output,IDEXrt_output,IDEXrd_output : out std_logic_vector(2 downto 0);
    EXMEMaluResult,aluA_out,aluB_out,aluResult_out : out std_logic_vector(7 downto 0);
    MEMWBMemToReg,MEMWBRegWrite : out std_logic;
	  MEMWBwriteReg : out std_logic_vector(2 downto 0);
    writeData_out : out std_logic_vector(7 downto 0);
    selectMux : out std_logic_vector(1 downto 0)
	  
	         );
        end component pipelinedProc;
        
        constant period: time := 100 ns; -- used to set the time period for our clock
        
        begin
          ppProc : pipelinedProc
                      port map(
		GClock => CLK_TB,
		GReset => RST_TB,
		
		pcValue_out => pcValue_out_TB,
		IFinstruction => IFinstruction_TB,
		IFIDen_out => IFIDen_out_TB,
		flush_out => flush_out_TB,
		IDEXALUSrc => IDEXALUSrc_TB,
		IDEXRegDst => IDEXRegDst_TB,
    IDEXreadData1 => IDEXreadData1_TB,
    IDEXreadData2 => IDEXreadData2_TB,
    IDEXrs_output => IDEXrs_output_TB,
    IDEXrt_output => IDEXrt_output_TB,
    IDEXrd_output => IDEXrd_output_TB,
    EXMEMaluResult => EXMEMaluResult_TB,
    aluA_out => aluA_out_TB,
    aluB_out => aluB_out_TB,
    aluResult_out => aluResult_out_TB,
    MEMWBMemToReg => MEMWBMemToReg_TB,
    MEMWBRegWrite => MEMWBRegWrite_TB,
    writeData_out => writeData_out_TB,                 
    selectMux => selectMux_TB
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
                  
                  RST_TB <= '1';
                  wait for 50 ns;
                  RST_TB <= '0', '1' after period;
                  wait for period; -- we let the clock and reset signal stabilize
                  
                  wait for 60000 ns;
                  sim_end <= true; -- signal the end of the stimuli
                  wait;
          end process;
end testbench;

