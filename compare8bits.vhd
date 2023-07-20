LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity compare8bits is
	port(
	
		x : in std_logic_vector(7 downto 0);
		y : in std_logic_vector(7 downto 0);
		
		eq : out std_logic
    
	);
end entity compare8bits;

architecture rtl of compare8bits is
  
  signal eq0,eq1,eq2,eq3,eq4,eq5,eq6,eq7 : std_logic;
  
  begin
    
    eq0 <= (x(0) xnor y(0));
    eq1 <= (x(1) xnor y(1));
    eq2 <= (x(2) xnor y(2));
    eq3 <= (x(3) xnor y(3));
    eq4 <= (x(4) xnor y(4));
    eq5 <= (x(5) xnor y(5));
    eq6 <= (x(6) xnor y(6));
    eq7 <= (x(7) xnor y(7));
    
    eq <= eq0 and eq1 and eq2 and eq3 and eq4 and eq5 and eq6 and eq7;
  
end rtl;
