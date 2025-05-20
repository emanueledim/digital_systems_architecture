library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity Registro is generic(
	M: integer := 8
); port(
	CLK: in std_logic;
    RST: in std_logic;
	INPUT: in std_logic_vector(M-1 downto 0);
	ENABLE: in std_logic;
	OUTPUT: out std_logic_vector(M-1 downto 0)
);
end Registro;

architecture Behavioral of Registro is
signal reg: std_logic_vector(M-1 downto 0) := (others => 'U');

begin
	reg_behavioral: process(CLK)
	begin
		if(rising_edge(CLK)) then
			if(RST = '1') then
				reg <= (others =>'0');
			elsif(enable = '1') then
				reg <= input;
			end if;
		end if;
	end process;
	output <= reg;
end Behavioral;
