library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Testbench is
end Testbench;

architecture TB_A_B of Testbench is
	signal CLK1: std_logic;
    signal CLK2: std_logic;
	signal RST1: std_logic;
	signal RST2: std_logic;
	signal START: std_logic;
    signal DATA: std_logic_vector(7 downto 0);
    signal REQ: std_logic;
    signal ACK: std_logic;
begin

    B: entity work.RicevitoreB port map(
        CLK => CLK2,
        RST => RST1,
        REQ => REQ,
        DATA => DATA,
        ACK => ACK
    );
    
    A: entity work.TrasmettitoreA port map(
        CLK => CLK1,
        RST => RST2,
        START => START,
		REQ => REQ,
        DATA => DATA,
        ACK => ACK
    );
    
    
    CLK1_UPDATE: process
    begin
        CLK1 <= '0';
        wait for 5 ns;
        CLK1 <= '1';
        wait for 5 ns;
    end process;
    
    CLK2_UPDATE: process
    begin
        wait for 7 ns;
        CLK2 <= '0';
        wait for 17 ns;
        CLK2 <= '1';
        wait for 10 ns;
    end process;
    
    
    UUT: process
    begin
        RST1 <= '1';
        RST2 <= '1';
        wait for 30 ns;
        RST1 <= '0';
        RST2 <= '0';
		START <= '1';
        wait;
    end process;
end TB_A_B;
