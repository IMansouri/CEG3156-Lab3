LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity mux2x1_3bits is
	port(
	
		a : in std_logic_vector(2 downto 0);
		b : in std_logic_vector(2 downto 0);
		s : in std_logic;
    
		o : out std_logic_vector(2 downto 0)
    
	);
end entity mux2x1_3bits;

architecture rtl of mux2x1_3bits is
  
  begin
    
    o(0) <= (not(s) and a(0)) or (s and b(0));
    o(1) <= (not(s) and a(1)) or (s and b(1));
    o(2) <= (not(s) and a(2)) or (s and b(2));
   
   
end rtl;
