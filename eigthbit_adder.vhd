LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity eigthbit_adder is 
	port(

		xV : in std_logic_vector(7 downto 0);
		yV : in std_logic_vector(7 downto 0);
		addNot : in std_logic;

		sV : out std_logic_vector(7 downto 0);
		carry : out std_logic;
		overflow : out std_logic

	);

end entity eigthbit_adder;

architecture rtl of eigthbit_adder is

	signal yxor : std_logic_vector(7 downto 0);

	component ripple_carry_adder8bit is
		port(

			c_in : in std_logic;
			x_vector : in std_logic_vector(7 downto 0);
			y_vector : in std_logic_vector(7 downto 0);
		
			s_vector : out std_logic_vector(7 downto 0);
			overflowFlag : out std_logic;
			c_out : out std_logic

		);
	end component ripple_carry_adder8bit;
	
	component xor_8bit is
		port(

			x_xor8bit : in std_logic_vector(7 downto 0);
			y_xor8bit : in std_logic;
			
			r_xor8bit : out std_logic_vector(7 downto 0)

		);
	end component xor_8bit;

	begin

		xor8bit : entity work.xor_8bit(rtl)
					port map (yV, addNot, yxor);
		
		adder : entity work.ripple_carry_adder8bit(rtl)
					port map (addNot, xV, yxor, sV, overflow, carry);

end architecture rtl;
