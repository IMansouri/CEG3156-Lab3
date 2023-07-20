LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY lpm;
USE lpm.lpm_components.all;

entity pipelinedProc is
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
end entity pipelinedProc;

architecture rtl of pipelinedProc is

							-- Signals --

  -- Clock divider --
  signal clk1M,clk100K,clk10K,clk1K,clk100,clk10,clk1 : std_logic;
  
  -- IF stage --
  signal pc4, pcValue,IFIDpc_in,IFIDpc_out,jumpAddr,branchAddr : std_logic_vector(7 downto 0);
  signal muxAddrSelect : std_logic_vector(1 downto 0);
  signal IFIDinstruction_in,IFIDinstruction_out,IDinstruction_out,EXinstruction_out,MEMinstruction_out,WBinstruction_out : std_logic_vector(31 downto 0);
  signal flush,IFIDen,en : std_logic;
  
  -- ID stage --
  signal RegDst,BranchEQ,BranchNotEQ,Jump,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,muxControlUnitSelect,compEQ : std_logic;
  signal ALUOp,addrSelect,IDEXALUOp_out : std_logic_vector(1 downto 0);
  signal controlUnitMux,IDEXcontrolunits_in,rd1,rd2 : std_logic_vector(7 downto 0);
  signal IDEXMemToReg_out,IDEXRegWrite_out,IDEXMemRead_out,IDEXMemWrite_out,IDEXALUSrc_out,IDEXRegDst_out : std_logic;
	signal IDEXreadData1_out,IDEXreadData2_out,IDEXsignReducedAddress_out : std_logic_vector(7 downto 0); 
	signal IDEXrs_out,IDEXrt_out,IDEXrd_out : std_logic_vector(2 downto 0);
  
  -- EX stage --
  signal EXMEMMemToReg_out,EXMEMRegWrite_out,EXMEMMemRead_out,EXMEMMemWrite_out,aluCarry,aluOverflow,slt,zero : std_logic;
  signal EXMEMaluResult_out,aluA,aluB,aluResult : std_logic_vector(7 downto 0);
	signal EXMEMwriteReg_out,opALU,writeReg : std_logic_vector(2 downto 0);
	signal aluASelect,aluBSelect : std_logic_vector(1 downto 0);
	
	-- MEM stage --
	signal MEMWBMemToReg_out,MEMWBRegWrite_out : std_logic;
	signal MEMWBaluResult_out,MEMWBwriteData_out : std_logic_vector(7 downto 0);
	signal MEMWBwriteReg_out : std_logic_vector(2 downto 0);
	
	-- WB stage --
  signal writeData,memData : std_logic_vector(7 downto 0);
  	
  	
  	
							-- Components --
	
	component bidirectional_shift_register_8bits is
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
	end component bidirectional_shift_register_8bits;
	
	component ControlUnit is 
		port(

			instruction : in std_logic_vector(5 downto 0);
			
			RegDst : out std_logic;
			BranchEQ : out std_logic;
			BranchNotEQ : out std_logic;
			Jump : out std_logic;
			MemRead : out std_logic;
			MemtoReg : out std_logic;
			ALUOp : out std_logic_vector(1 downto 0);
			MemWrite : out std_logic;
			ALUSrc : out std_logic;
			RegWrite : out std_logic

		);

	end component ControlUnit;
	
	component mux2x1_8bits is
		port(
		
			a : in std_logic_vector(7 downto 0);
			b : in std_logic_vector(7 downto 0);
			s : in std_logic;
		 
			o : out std_logic_vector(7 downto 0)
		 
		);
	end component mux2x1_8bits;
	
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
	
	component ALU_8bits is 
		port(

			op : in std_logic_vector(2 downto 0);
			x : in std_logic_vector(7 downto 0);
			y : in std_logic_vector(7 downto 0);

			s : out std_logic_vector(7 downto 0);
			carry : out std_logic;
			overflow : out std_logic;
			slt : out std_logic;
			zero : out std_logic

		);

	end component ALU_8bits;
	
	component ALUControl is
	port (
		funct: IN STD_LOGIC_VECTOR( 5 Downto 0);
		ALUop: IN STD_LOGIC_VECTOR( 1 Downto 0);	
		op: OUT STD_LOGIC_VECTOR( 2 Downto 0)
	);
	end component ALUControl;
	
	component eigthbit_adder is 
		port(

			xV : in std_logic_vector(7 downto 0);
			yV : in std_logic_vector(7 downto 0);
			addNot : in std_logic;

			sV : out std_logic_vector(7 downto 0);
			carry : out std_logic;
			overflow : out std_logic

		);

	end component eigthbit_adder;
	
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
	
	component mux2x1_3bits is
		port(
		
			a : in std_logic_vector(2 downto 0);
			b : in std_logic_vector(2 downto 0);
			s : in std_logic;
		 
			o : out std_logic_vector(2 downto 0)
		 
		);
	end component mux2x1_3bits;
	
	COMPONENT clk_div IS

	 PORT
	   (
		    clock_25Mhz				: IN	STD_LOGIC;
		    clock_1MHz				: OUT	STD_LOGIC;
		    clock_100KHz				: OUT	STD_LOGIC;
		    clock_10KHz				: OUT	STD_LOGIC;
		    clock_1KHz				: OUT	STD_LOGIC;
		    clock_100Hz				: OUT	STD_LOGIC;
		    clock_10Hz				: OUT	STD_LOGIC;
		    clock_1Hz				: OUT	STD_LOGIC);
	
  END  COMPONENT clk_div;
  
  component mux4x1_8bits is
	 port(
	
		  a : in std_logic_vector(7 downto 0);
      b : in std_logic_vector(7 downto 0);
      c : in std_logic_vector(7 downto 0);
      d : in std_logic_vector(7 downto 0);
      s : in std_logic_vector(1 downto 0);
    
      o : out std_logic_vector(7 downto 0)
    
	 );
  end component mux4x1_8bits;
  
  component compare8bits is
	 port(
	
		  x : in std_logic_vector(7 downto 0);
		  y : in std_logic_vector(7 downto 0);
		
		  eq : out std_logic
    
	 );
  end component compare8bits;

  component IFIDbuffer is
	 port(
	
		  pc_in : in std_logic_vector(7 downto 0);
		  instruction_in : in std_logic_vector(31 downto 0);
		
		  clock : in std_logic;
		  reset : in std_logic;
		  en : in std_logic;
		  Flush : in std_logic;
      
      pc_out : out std_logic_vector(7 downto 0);
		  instruction_out : out std_logic_vector(31 downto 0) 
	 );
  end component IFIDbuffer;
  
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
		  rd_in : in std_logic_vector(2 downto 0);
		  rt_in : in std_logic_vector(2 downto 0);
		
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
		  rd_out : out std_logic_vector(2 downto 0);
		  rt_out : out std_logic_vector(2 downto 0)
	 );
  end component IDEXbuffer;
  
  component EXMEMbuffer is
	 port(
	
		  MemToReg_in : in std_logic;
		  RegWrite_in : in std_logic;
		  MemRead_in : in std_logic;
		  MemWrite_in : in std_logic;
		
		  aluResult_in : in std_logic_vector(7 downto 0);
		  writeReg_in : in std_logic_vector(2 downto 0);
		
		  clock : in std_logic;
		  reset : in std_logic;
    
      MemToReg_out : out std_logic;
		  RegWrite_out : out std_logic;
		  MemRead_out : out std_logic;
		  MemWrite_out : out std_logic;
    
      aluResult_out : out std_logic_vector(7 downto 0);
		  writeReg_out : out std_logic_vector(2 downto 0)
	 );
  end component EXMEMbuffer;
  
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
  
  begin
    
    clkDiv : entity work.clk_div(a)
                port map(GClock,clk1M,clk100K,clk10K,clk1K,clk100,clk10,clk1);
  
  
                            -- IF --
                en <= IFIDen or not(GReset);            
		pc : entity work.bidirectional_shift_register_8bits(rtl)
				port map(pc4, '0', '0', '0', en, GReset, clk1M, pcValue);
		
		pcAddJ : entity work.eigthbit_adder(rtl)
					port map(pcValue,"00000100",'0',IFIDpc_in);
					  
		muxAddr : entity work.mux4x1_8bits(rtl)
		            port map(IFIDpc_in,jumpAddr,branchAddr,"00000000",muxAddrSelect,pc4);
		
		ROM : lpm_rom
		        GENERIC MAP(LPM_WIDTH => 32 ,
		        LPM_WIDTHAD => 8, 
		        LPM_FILE => "ROM.mif")
                PORT MAP(address => pcValue, 
                         q => IFIDinstruction_in,
								inclock => GClock,
								outclock => GClock);
								
		buff1 : entity work.IFIDbuffer(rtl)
		          port map(IFIDpc_in,IFIDinstruction_in,clk1M,GReset,en,flush,IFIDpc_out,IFIDinstruction_out);				
		          
		          	
		                        -- ID --			
		
		cu : entity work.ControlUnit(rtl)
				port map(IFIDinstruction_out(31 downto 26),RegDst,BranchEQ,BranchNotEQ,Jump,MemRead,MemtoReg,ALUOp,MemWrite,ALUSrc,RegWrite);
		
		controlUnitMux(0) <= RegWrite;
		controlUnitMux(1) <= MemtoReg;
		controlUnitMux(2) <= MemWrite;
		controlUnitMux(4 downto 3) <= ALUOp;
		controlUnitMux(5) <= RegDst;
		controlUnitMux(6) <= ALUSrc;
		controlUnitMux(7) <= MemRead;
		
		muxControlUnit : entity work.mux2x1_8bits(rtl)
						port map(controlUnitMux,"00000000",muxControlUnitSelect,IDEXcontrolunits_in);
										
		rf : entity work.RegisterFile(rtl)
					port map(IFIDinstruction_out(23 downto 21),IFIDinstruction_out(18 downto 16),EXMEMwriteReg_out,writeData,MEMWBRegWrite_out,GReset,clk1M,rd1,rd2);
		
		compareReadData : entity work.compare8bits(rtl)
		                    port map(rd1,rd2,compEQ);
		                      
		shftJ : entity work.shiftByTwo(rtl)
					     port map(IFIDinstruction_out(7 downto 0),'0','0','1','1',GReset,GClock,jumpAddr);
					  
		pcAddB : entity work.eigthbit_adder(rtl)
					     port map(IFIDpc_out,jumpAddr,'0',branchAddr);
					       
		hzdUnit : entity work.HazardUnit(rtl)
		            port map(IFIDinstruction_out,IDEXrt_out,IDEXmemRead_out,compEQ,BranchEQ,BranchNotEQ,Jump,
		                      muxControlUnitSelect,IFIDen,flush,muxAddrSelect);
					       
		buff2 : entity work.IDEXbuffer(rtl)
		          port map(IDEXcontrolunits_in(1),IDEXcontrolunits_in(0),IDEXcontrolunits_in(7),IDEXcontrolunits_in(2),ALUSrc,IDEXcontrolunits_in(4 downto 3),IDEXcontrolunits_in(5),
		                    rd1,rd2,IFIDinstruction_out(7 downto 0),IFIDinstruction_out(23 downto 21),IFIDinstruction_out(18 downto 16),IFIDinstruction_out(13 downto 11),
		                    clk1M,GReset,IDEXMemToReg_out,IDEXRegWrite_out,IDEXMemRead_out,IDEXMemWrite_out,IDEXALUSrc_out,IDEXALUOp_out,IDEXRegDst_out,IDEXreadData1_out ,      
		                    IDEXreadData2_out,IDEXsignReducedAddress_out,IDEXrs_out,IDEXrt_out,IDEXrd_out);
	
		                    
		                        -- EX --
		                        
		aluAMux : entity work.mux4x1_8bits(rtl)
		            port map(IDEXreadData1_out,MEMWBwriteData_out,EXMEMaluResult_out,"00000000",aluASelect,aluA);
		
		aluBMux : entity work.mux4x1_8bits(rtl)
		            port map(IDEXreadData2_out,MEMWBwriteData_out,EXMEMaluResult_out,IDEXsignReducedAddress_out,aluBSelect,aluB);
		
		aluC : entity work.ALUControl(rtl)
					port map(IDEXsignReducedAddress_out(5 downto 0),ALUOp,opALU);
		
		alu : entity work.ALU_8bits(rtl)
					 port map(opALU,aluA,aluB,aluResult,aluCarry,aluOverflow,slt,zero);
					   
	  muxRegDst : entity work.mux2x1_3bits(rtl)
	               port map(IDEXrt_out,IDEXrd_out,IDEXRegDst_out,writeReg);
	                 
	  fwdUnit : entity work.ForwardingUnit(rtl)
		            port map(IDEXrs_out,IDEXrt_out,EXMEMwriteReg_out,EXMEMRegWrite_out,MEMWBwriteReg_out,MEMWBRegWrite_out,
                          IDEXALUSrc_out,aluASelect,aluBSelect);
	 
	  buff3 : entity work.EXMEMbuffer(rtl)
	           port map(IDEXMemToReg_out,IDEXRegWrite_out,IDEXMemRead_out,IDEXMemWrite_out,aluResult,writeReg,
	                    clk1M,GReset,EXMEMMemToReg_out,EXMEMRegWrite_out,EXMEMMemRead_out,EXMEMMemWrite_out,EXMEMaluResult_out,
	                    EXMEMwriteReg_out);
		                    
	                         -- MEM --			
						  
		RAM : lpm_ram_dq
		        GENERIC MAP(LPM_WIDTH => 8 ,
		        LPM_WIDTHAD => 8, 
		        LPM_FILE => "RAM.mif")
                PORT MAP(data => rd2, 
                        address => EXMEMaluResult_out, 
                        we => EXMEMMemWrite_out,
                        q => memData,
								        inclock => GClock,
								        outclock => GClock);			
								        	  	
		
		buff4 : entity work.MEMWbbuffer(rtl)
		          port map(EXMEMMemToReg_out,EXMEMRegWrite_out,EXMEMaluResult_out,memData,EXMEMwriteReg_out,
		                    clk1M,GReset,MEMWBMemToReg_out,MEMWBRegWrite_out,MEMWBaluResult_out,MEMWBwriteData_out,
		                    MEMWBwriteReg_out);						 
		                    
		                  
		                                             	  	
								        	 --	WB --
								        	 	  
		muxMem : entity work.mux2x1_8bits(rtl)
						port map(MEMWBaluResult_out,MEMWBwriteData_out,MEMWBMemToReg_out,writeData);		
		
		                      -- Outputs --
	 
	  pcValue_out <= pcValue;
		IFinstruction <= IFIDinstruction_in;
		flush_out <= flush;
		IFIDen_out <=IFIDen;
		
		IDEXALUSrc <= IDEXALUSrc_out;
		IDEXRegDst <= IDEXRegDst_out;
    IDEXrs_output <= IDEXrs_out;
    IDEXrt_output <= IDEXrt_out;
    IDEXrd_output <= IDEXrd_out;
    IDEXreadData1 <= IDEXreadData1_out;
    IDEXreadData2 <= IDEXreadData2_out;
    
    EXMEMaluResult <= EXMEMaluResult_out;
    aluA_out <= aluA;
    aluB_out <= aluB;
    aluResult_out <= aluResult;
    
    MEMWBMemToReg <= MEMWBMemToReg_out;
    MEMWBRegWrite <= MEMWBRegWrite_out;
	  MEMWBwriteReg <= MEMWBwriteReg_out;
    writeData_out <= writeData;
    
    selectMux <= aluASelect;
				
end rtl;
