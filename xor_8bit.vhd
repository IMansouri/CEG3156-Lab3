LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity xor_8bit is 
	port(
	
		x_xor8bit : in std_logic_vector(7 downto 0);
		y_xor8bit : in std_logic;
		
		r_xor8bit : out std_logic_vector(7 downto 0)
	);
end entity xor_8bit;

architecture rtl of xor_8bit is
	
	begin 
	
		r_xor8bit(0) <= y_xor8bit xor x_xor8bit(0);
		r_xor8bit(1) <= y_xor8bit xor x_xor8bit(1);
		r_xor8bit(2) <= y_xor8bit xor x_xor8bit(2);
		r_xor8bit(3) <= y_xor8bit xor x_xor8bit(3);
		r_xor8bit(4) <= y_xor8bit xor x_xor8bit(4);
		r_xor8bit(5) <= y_xor8bit xor x_xor8bit(5);
		r_xor8bit(6) <= y_xor8bit xor x_xor8bit(6);
		r_xor8bit(7) <= y_xor8bit xor x_xor8bit(7);
					
end architecture rtl;
