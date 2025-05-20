library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Mux2_1 is generic(
	N : integer := 2);
	port(
		a1: in std_logic_vector(N-1 downto 0);
		a2: in std_logic_vector(N-1 downto 0);
		s: in std_logic;
		y: out std_logic_vector(N-1 downto 0)
	);
end Mux2_1;


architecture Behavioral of Mux2_1 is

begin
 process_mux : process(a1,a2,s)
	begin
		case s is
			when '0' => y <= a1;
			when '1' => y <= a2;
			when others => y <= a1;
		end case;
	end process;
end Behavioral;

