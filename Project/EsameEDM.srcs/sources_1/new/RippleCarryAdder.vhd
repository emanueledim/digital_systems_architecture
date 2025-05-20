library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity RippleCarryAdder is generic(
    N : integer := 8
    ); port (
    A : in std_logic_vector(N-1 downto 0);
    B : in std_logic_vector(N-1 downto 0);
    Carry_in : in std_logic;
    S : out std_logic_vector(N-1 downto 0);  
    Cout: out std_logic
);
end RippleCarryAdder;

architecture Structural of RippleCarryAdder is
signal Internal_Carry: std_logic_vector(0 to N-2);
begin
    
	FA0: entity work.FullAdder port map(
        A => A(0),
        B => B(0),
        Cin => Carry_in,
        S => S(0),
        Cout => Internal_Carry(0)
    );
            
    RippleCarryAdder: for i in 1 to N-2 generate
        FA1_to_N: entity work.FullAdder port map(
            A => A(i),
            B => B(i),
            Cin => Internal_Carry(i-1),
            S => S(i),
            Cout => Internal_Carry(i)
        );
    end generate;
    
    FAN: entity work.FullAdder port map(
        A => A(N-1),
        B => B(N-1),
        Cin => Internal_Carry(N-2),
        S => S(N-1),
        Cout => Cout
    );
end Structural;
