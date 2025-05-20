library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity CheckPositive is
    Port ( INPUT : in STD_LOGIC_VECTOR (7 downto 0);
           POSITIVE : out STD_LOGIC;
           NOT_POSITIVE: out STD_LOGIC);
end CheckPositive;

architecture Behavioral of CheckPositive is

begin

    CHECK: process(INPUT)
    begin
        if(INPUT(7) = '1' OR INPUT = "00000000") then
            NOT_POSITIVE <= '1';
            POSITIVE <= '0';
        else
            NOT_POSITIVE <= '0';
            POSITIVE <= '1';
        end if;       
    end process;
end Behavioral;
