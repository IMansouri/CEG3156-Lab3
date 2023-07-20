LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity compare3bits is
	port(
	
		x : in std_logic_vector(2 downto 0);
		y : in std_logic_vector(2 downto 0);
		
		eq : out std_logic
    
	);
end entity compare3bits;

architecture rtl of compare3bits is
  
  signal eq0,eq1,eq2 : std_logic;
  
  begin
    
    eq0 <= (x(0) xnor y(0));
    eq1 <= (x(1) xnor y(1));
    eq2 <= (x(2) xnor y(2));
    
    eq <= eq0 and eq1 and eq2;
  
end rtl;
