LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity mux2x1_8bits is
	port(
	
		a : in std_logic_vector(7 downto 0);
		b : in std_logic_vector(7 downto 0);
		s : in std_logic;
    
		o : out std_logic_vector(7 downto 0)
    
	);
end entity mux2x1_8bits;

architecture rtl of mux2x1_8bits is
  
  begin
    
    o(0) <= (not(s) and a(0)) or (s and b(0));
    o(1) <= (not(s) and a(1)) or (s and b(1));
    o(2) <= (not(s) and a(2)) or (s and b(2));
    o(3) <= (not(s) and a(3)) or (s and b(3));
    o(4) <= (not(s) and a(4)) or (s and b(4));
    o(5) <= (not(s) and a(5)) or (s and b(5));
    o(6) <= (not(s) and a(6)) or (s and b(6));
    o(7) <= (not(s) and a(7)) or (s and b(7));
   
   
end rtl;
