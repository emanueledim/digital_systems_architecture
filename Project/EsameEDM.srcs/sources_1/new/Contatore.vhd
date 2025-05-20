library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;
use IEEE.NUMERIC_STD.ALL;

entity Contatore is
generic(
	M : integer := 60
); port ( 
	CLK : in std_logic ;
	RST : in  std_logic;
	ENABLE : in std_logic;
	COUNT : out std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0);
	DIV : out std_logic 
);
end Contatore;

architecture Behavioral of Contatore is
	signal T : std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0) := (others => '0');    
	
begin

	div_out : process (T)
        begin
           if(to_integer(unsigned(T)) >= M-1)then
                DIV<='1';
           else
                DIV<='0';
           end if;  
    end process;
	
	conteggio : process (CLK)
    begin
        if (rising_edge (CLK)) then
            if(RST='1')then
				T <= (others =>'0');
            elsif(ENABLE='1')then 
                if(to_integer(unsigned(T)) >= M)then
					T<=(others=>'0');
				else
					T <= std_logic_vector(unsigned(T) +1);   
				end if;   
			end if;  
        end if;          
    end process;
    COUNT<=T;
end Behavioral;