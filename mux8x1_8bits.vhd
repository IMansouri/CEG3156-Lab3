LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity mux8x1_8bits is
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
end entity mux8x1_8bits;

architecture rtl of mux8x1_8bits is
  
  begin
    
    o(0) <= (not(s(2)) and not(s(1)) and not(s(0)) and x0(0)) or  --000
            (not(s(2)) and not(s(1)) and s(0) and x1(0)) or       --001
            (not(s(2)) and s(1) and not(s(0)) and x2(0)) or       --010
            (not(s(2)) and s(1) and s(0) and x3(0)) or            --011
            (s(2) and not(s(1)) and not(s(0)) and x4(0)) or       --100
            (s(2) and not(s(1)) and s(0) and x5(0)) or            --101
            (s(2) and s(1) and not(s(0)) and x6(0)) or            --110
            (s(2) and s(1) and s(0) and x7(0));                   --111
   
    o(1) <= (not(s(2)) and not(s(1)) and not(s(0)) and x0(1)) or  --000
            (not(s(2)) and not(s(1)) and s(0) and x1(1)) or       --001
            (not(s(2)) and s(1) and not(s(0)) and x2(1)) or       --010
            (not(s(2)) and s(1) and s(0) and x3(1)) or            --011
            (s(2) and not(s(1)) and not(s(0)) and x4(1)) or       --100
            (s(2) and not(s(1)) and s(0) and x5(1)) or            --101
            (s(2) and s(1) and not(s(0)) and x6(1)) or            --110
            (s(2) and s(1) and s(0) and x7(1));                   --111

    o(2) <= (not(s(2)) and not(s(1)) and not(s(0)) and x0(2)) or  --000
            (not(s(2)) and not(s(1)) and s(0) and x1(2)) or       --001
            (not(s(2)) and s(1) and not(s(0)) and x2(2)) or       --010
            (not(s(2)) and s(1) and s(0) and x3(2)) or            --011
            (s(2) and not(s(1)) and not(s(0)) and x4(2)) or       --100
            (s(2) and not(s(1)) and s(0) and x5(2)) or            --101
            (s(2) and s(1) and not(s(0)) and x6(2)) or            --110
            (s(2) and s(1) and s(0) and x7(2));                   --111

    o(3) <= (not(s(2)) and not(s(1)) and not(s(0)) and x0(3)) or  --000
            (not(s(2)) and not(s(1)) and s(0) and x1(3)) or       --001
            (not(s(2)) and s(1) and not(s(0)) and x2(3)) or       --010
            (not(s(2)) and s(1) and s(0) and x3(3)) or            --011
            (s(2) and not(s(1)) and not(s(0)) and x4(3)) or       --100
            (s(2) and not(s(1)) and s(0) and x5(3)) or            --101
            (s(2) and s(1) and not(s(0)) and x6(3)) or            --110
            (s(2) and s(1) and s(0) and x7(3));                   --111
            
    o(4) <= (not(s(2)) and not(s(1)) and not(s(0)) and x0(4)) or  --000
            (not(s(2)) and not(s(1)) and s(0) and x1(4)) or       --001
            (not(s(2)) and s(1) and not(s(0)) and x2(4)) or       --010
            (not(s(2)) and s(1) and s(0) and x3(4)) or            --011
            (s(2) and not(s(1)) and not(s(0)) and x4(4)) or       --100
            (s(2) and not(s(1)) and s(0) and x5(4)) or            --101
            (s(2) and s(1) and not(s(0)) and x6(4)) or            --110
            (s(2) and s(1) and s(0) and x7(4));                   --111
            
    o(5) <= (not(s(2)) and not(s(1)) and not(s(0)) and x0(5)) or  --000
            (not(s(2)) and not(s(1)) and s(0) and x1(5)) or       --001
            (not(s(2)) and s(1) and not(s(0)) and x2(5)) or       --010
            (not(s(2)) and s(1) and s(0) and x3(5)) or            --011
            (s(2) and not(s(1)) and not(s(0)) and x4(5)) or       --100
            (s(2) and not(s(1)) and s(0) and x5(5)) or            --101
            (s(2) and s(1) and not(s(0)) and x6(5)) or            --110
            (s(2) and s(1) and s(0) and x7(5));                   --111            


    o(6) <= (not(s(2)) and not(s(1)) and not(s(0)) and x0(6)) or  --000
            (not(s(2)) and not(s(1)) and s(0) and x1(6)) or       --001
            (not(s(2)) and s(1) and not(s(0)) and x2(6)) or       --010
            (not(s(2)) and s(1) and s(0) and x3(6)) or            --011
            (s(2) and not(s(1)) and not(s(0)) and x4(6)) or       --100
            (s(2) and not(s(1)) and s(0) and x5(6)) or            --101
            (s(2) and s(1) and not(s(0)) and x6(6)) or            --110
            (s(2) and s(1) and s(0) and x7(6));                   --111

    o(7) <= (not(s(2)) and not(s(1)) and not(s(0)) and x0(7)) or  --000
            (not(s(2)) and not(s(1)) and s(0) and x1(7)) or       --001
            (not(s(2)) and s(1) and not(s(0)) and x2(7)) or       --010
            (not(s(2)) and s(1) and s(0) and x3(7)) or            --011
            (s(2) and not(s(1)) and not(s(0)) and x4(7)) or       --100
            (s(2) and not(s(1)) and s(0) and x5(7)) or            --101
            (s(2) and s(1) and not(s(0)) and x6(7)) or            --110
            (s(2) and s(1) and s(0) and x7(7));                   --111
            
end rtl;
