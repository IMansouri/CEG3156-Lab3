LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity shiftByTwo is
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
end entity shiftByTwo;

architecture rtl of shiftByTwo is
	
	signal b7, b6, b5, b4, b3, b2, b1, b0 : std_logic;
	signal d7in, d6in, d5in, d4in, d3in, d2in, d1in, d0in : std_logic;
	 
	component enARdFF_2 is
	 port(
		  i_resetBar	: IN	STD_LOGIC;
		  i_d		: IN	STD_LOGIC;
		  i_enable	: IN	STD_LOGIC;
		  i_clock		: IN	STD_LOGIC;
		  o_q, o_qBar	: OUT	STD_LOGIC);
  end component enARdFF_2;
	
	begin
	
		d7in <= in_n(5);
					
		d6in <= in_n(4);
					
		d5in <= in_n(3);
					
		d4in <= in_n(2);
					
		d3in <= in_n(1);
					
		d2in <= in_n(0);
					
		d1in <= in_bit;
					
		d0in <= in_bit;
	
		d0 : entity work.enARdFF_2(rtl)
				port map(reset, d0in, load, clock, b0);
				
		d1 : entity work.enARdFF_2(rtl)
				port map(reset, d1in, load, clock, b1);
		
		d2 : entity work.enARdFF_2(rtl)
				port map(reset, d2in, load, clock, b2);
		
		d3 : entity work.enARdFF_2(rtl)
				port map(reset, d3in, load, clock, b3);
				
		d4 : entity work.enARdFF_2(rtl)
				port map(reset, d4in, load, clock, b4);
				
		d5 : entity work.enARdFF_2(rtl)
				port map(reset, d5in, load, clock, b5);
				
		d6 : entity work.enARdFF_2(rtl)
				port map(reset, d6in, load, clock, b6);
				
		d7 : entity work.enARdFF_2(rtl)
				port map(reset, d7in, load, clock, b7);
			
		out_n <= (b0 and not(leftShift)) or (b7 and leftShift);
		
		out_vector(0) <= b0;
		out_vector(1) <= b1;
		out_vector(2) <= b2;
		out_vector(3) <= b3;
		out_vector(4) <= b4;
		out_vector(5) <= b5;
		out_vector(6) <= b6;
		out_vector(7) <= b7;
		
end architecture rtl;
