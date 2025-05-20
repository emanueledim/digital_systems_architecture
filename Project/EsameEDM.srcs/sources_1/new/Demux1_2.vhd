library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Demux1_2 is generic(
	N : integer := 2);
	port(
		a: in std_logic_vector(N-1 downto 0);
		s: in std_logic;
		y1: out std_logic_vector(N-1 downto 0);
		y2: out std_logic_vector(N-1 downto 0)
	);
end Demux1_2;


architecture Behavioral of Demux1_2 is

begin
 process_demux : process(a,s)
	begin
		case s is
			when '0' => y1 <= a;
			when '1' => y2 <= a;
			when others => y1 <= a;
		end case;
	end process;
end Behavioral;

