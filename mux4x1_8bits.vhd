LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity mux4x1_8bits is
	port(
	
		a : in std_logic_vector(7 downto 0);
    b : in std_logic_vector(7 downto 0);
    c : in std_logic_vector(7 downto 0);
    d : in std_logic_vector(7 downto 0);
    s : in std_logic_vector(1 downto 0);
    
    o : out std_logic_vector(7 downto 0)
    
	);
end entity mux4x1_8bits;

architecture rtl of mux4x1_8bits is
  
  begin
    
    o(0) <= (not(s(0)) and not(s(1)) and a(0)) or (s(0) and not(s(1)) and b(0)) or (not(s(0)) and s(1) and c(0)) or (s(0) and s(1) and d(0));
    o(1) <= (not(s(0)) and not(s(1)) and a(1)) or (s(0) and not(s(1)) and b(1)) or (not(s(0)) and s(1) and c(1)) or (s(0) and s(1) and d(1));
    o(2) <= (not(s(0)) and not(s(1)) and a(2)) or (s(0) and not(s(1)) and b(2)) or (not(s(0)) and s(1) and c(2)) or (s(0) and s(1) and d(2));
    o(3) <= (not(s(0)) and not(s(1)) and a(3)) or (s(0) and not(s(1)) and b(3)) or (not(s(0)) and s(1) and c(3)) or (s(0) and s(1) and d(3));
    o(4) <= (not(s(0)) and not(s(1)) and a(4)) or (s(0) and not(s(1)) and b(4)) or (not(s(0)) and s(1) and c(4)) or (s(0) and s(1) and d(4));
    o(5) <= (not(s(0)) and not(s(1)) and a(5)) or (s(0) and not(s(1)) and b(5)) or (not(s(0)) and s(1) and c(5)) or (s(0) and s(1) and d(5));
    o(6) <= (not(s(0)) and not(s(1)) and a(6)) or (s(0) and not(s(1)) and b(6)) or (not(s(0)) and s(1) and c(6)) or (s(0) and s(1) and d(6));
    o(7) <= (not(s(0)) and not(s(1)) and a(7)) or (s(0) and not(s(1)) and b(7)) or (not(s(0)) and s(1) and c(7)) or (s(0) and s(1) and d(7));
   
   
end rtl;
