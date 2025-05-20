library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
entity ROM2 is port(
	CLK: in std_logic;
	READ_ROM: in std_logic;
	ADDRESS: in std_logic_vector(2 downto 0);
	DATA_OUT: out std_logic_vector(7 downto 0)
);
end ROM2;

architecture Behavioral of ROM2 is
TYPE registri is array (0 to 7) of std_logic_vector(7 downto 0);
signal memoria : registri := (	
				("00010100"),   -- 20
				("10011100"),   -- -100
				("10101111"),   -- -81
				("00011110"),   -- 30
				("00111100"),   -- 60
				("10011100"),   -- -100
				("11110001"),   -- -15
				("00000000")    -- 0
				);

begin
	memo_behavioral: process(CLK)
	begin
		if(rising_edge(CLK)) then
			if(READ_ROM = '1') then
				DATA_OUT <= memoria(conv_integer(ADDRESS));
			end if;
		end if;
	end process;
end Behavioral;

