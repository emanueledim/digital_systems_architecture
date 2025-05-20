library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Memoria is generic(
	N: integer := 16;
	WORD: integer := 8
	);
	port( 
	CLK: in std_logic;
	RST: in std_logic;
	R: in std_logic;	--Read
	W: in std_logic;	--Write
	ADDRESS: in std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0);
	DATA_INPUT: in std_logic_vector(WORD-1 downto 0);
	DATA_OUT: out std_logic_vector(WORD-1 downto 0)
);
end Memoria;

architecture Behavioral of Memoria is
TYPE registri is array (0 to N-1) of std_logic_vector(WORD-1 downto 0);
signal memoria : registri; 

begin
	
	memo_behavioral: process(CLK)
	begin
		if(rising_edge(CLK)) then
			if(RST = '1') then
				for k in 0 to N-1 loop 
					memoria(k) <= (others =>'0');
					DATA_OUT <= (others => '0'); 
				end loop;
			elsif(W = '1') then
				memoria(conv_integer(ADDRESS)) <= DATA_INPUT;
			elsif(R = '1') then
				DATA_OUT <= memoria(conv_integer(ADDRESS));
			end if;
		end if;
	end process;
end Behavioral;
