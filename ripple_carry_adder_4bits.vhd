LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity ripple_carry_adder_4bits is
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
end entity ripple_carry_adder_4bits;

architecture rtl of ripple_carry_adder_4bits is

	signal c0toc1, c1toc2, c2toc3, cOut, p0, p1, p2, p3, g0, g1, g2, g3 : std_logic;

	component full_adder is
		port(

			c_i : in std_logic;
			x_i : in std_logic;
			y_i : in std_logic;

			s_i : out std_logic;
			c_i1 : out std_logic

		);
	end component full_adder;
	
	component xor_gate
		port(

			x_xor : in std_logic;
			y_xor : in std_logic;

			z_xor : out std_logic

		);
	end component xor_gate;

	begin

		f0 : entity work.full_adder(rtl)
				port map (c_in, x_vector(0), y_vector(0), s_vector(0), c0toc1);

		f1 : entity work.full_adder(rtl)
				port map (c0toc1, x_vector(1), y_vector(1), s_vector(1), c1toc2);

		f2 : entity work.full_adder(rtl)
				port map (c1toc2, x_vector(2), y_vector(2), s_vector(2), c2toc3);

		f3 : entity work.full_adder(rtl)
				port map (c2toc3, x_vector(3), y_vector(3), s_vector(3), cOut);
						
		overflowFlag <= c2toc3 xor cOut;
						
		c_out <= cOut;
		
		p0 <= x_vector(0) or y_vector(0);
		p1 <= x_vector(1) or y_vector(1);
		p2 <= x_vector(2) or y_vector(2);
		p3 <= x_vector(3) or y_vector(3);
		
		g0 <= x_vector(0) and y_vector(0);
		g1 <= x_vector(1) and y_vector(1);
		g2 <= x_vector(2) and y_vector(2);
		g3 <= x_vector(3) and y_vector(3);
		
		p_i <= p0 and p1 and p2 and p3;
		
		g_i <= g3 or (p3 and g2) or (p3 and p2 and g1) or (p3 and p2 and p1 and g0);

end architecture rtl;
