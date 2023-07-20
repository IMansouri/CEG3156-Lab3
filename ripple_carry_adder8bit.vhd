LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity ripple_carry_adder8bit is
	port(

		c_in : in std_logic;
		x_vector : in std_logic_vector(7 downto 0);
		y_vector : in std_logic_vector(7 downto 0);
		
		s_vector : out std_logic_vector(7 downto 0);
		overflowFlag : out std_logic;
		c_out : out std_logic

	);
end entity ripple_carry_adder8bit;

architecture rtl of ripple_carry_adder8bit is

	signal alu1_carry_in, alu0_overflow, g0, p0, g1, p1, c1, c2 : std_logic;
	signal alu0_s, alu1_s : std_logic_vector(3 downto 0);

	component ripple_carry_adder_4bits is
		port(

			c_in : in std_logic;
			x_vector : in std_logic_vector(3 downto 0);
			y_vector : in std_logic_vector(3 downto 0);
			
			s_vector : out std_logic_vector(3 downto 0);
			p_i : out std_logic;
			g_i : out std_logic;
			overflowFlag : out std_logic;
			c_out : out std_logic

		);
	end component ripple_carry_adder_4bits;

	begin

		alu0 : entity work.ripple_carry_adder_4bits(rtl)
					port map(c_in, x_vector(3 downto 0), y_vector(3 downto 0), s_vector(3 downto 0), g0, p0, alu0_overflow, alu1_carry_in);
		
		c1 <= G0 or (p0 and c_in);			
		
		alu1 : entity work.ripple_carry_adder_4bits(rtl)
					port map(alu1_carry_in, x_vector(7 downto 4), y_vector(7 downto 4), s_vector(7 downto 4), g1, p1, overflowFlag, c2);
		
		c_out <= g1 or (p1 and g0) or (p1 and p0 and c_in);

end architecture rtl;
