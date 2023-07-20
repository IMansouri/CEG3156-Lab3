LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity full_adder is
	port(

		c_i : in std_logic;
		x_i : in std_logic;
		y_i : in std_logic;

		s_i : out std_logic;
		c_i1 : out std_logic

	);
end entity full_adder;

architecture rtl of full_adder is

	signal XOR1toANDxOR : std_logic;
	signal AND1toOR : std_logic;
	signal AND2toOR : std_logic;

	begin
					
		XOR1toANDxOR <= x_i xor y_i;
					
		AND1toOR <= x_i and y_i;
		
		AND2toOR <= c_i and XOR1toANDxOR;
		
		s_i <= c_i xor XOR1toANDxOR;
		
		c_i1 <= AND2toOR or AND1toOR;

end architecture rtl;
