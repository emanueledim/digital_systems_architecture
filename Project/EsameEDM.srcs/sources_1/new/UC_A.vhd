library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity UC_A is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           START : in STD_LOGIC;
           DIV : in STD_LOGIC;
           ACK : in STD_LOGIC;
           R : out STD_LOGIC;
           SEL_ROM : out STD_LOGIC;
           EN_BUF : out STD_LOGIC;
           INC : out STD_LOGIC;
           RST_BUF_UC : out STD_LOGIC;
           REQ : out STD_LOGIC
		);
end UC_A;

architecture FSM of UC_A is
	TYPE state IS (IDLE, READ_ROM, SAVE_OP1, SELECT_ROM2, SAVE_SUM, SEND_REQ, WAIT_ACK, NEXT_ADDRESS, TERMINAZIONE);
	signal current_state : state := IDLE;
	signal next_state : state;

begin
    UPDATE_STATE: process(CLK)
    begin
        if(rising_edge(CLK)) then
            if(RST = '1') then
                current_state <= IDLE;
            else
                current_state <= next_state;
            end if;
        end if;
    end process;
    
    
    COMB: process(START, DIV, ACK, current_state)
    begin
        case current_state is
            when IDLE =>
				R <= '0';
				SEL_ROM <= '0';
				EN_BUF <= '0';
				INC <= '0';
				RST_BUF_UC <= '1';
				REQ <= '0';
				if(START = '1') then
					next_state <= READ_ROM;
				else
					next_state <= IDLE;
				end if;
			when READ_ROM =>
				R <= '1';
				SEL_ROM <= '0';
				RST_BUF_UC <= '0';
				next_state <= SAVE_OP1;
			when SAVE_OP1 =>
				R <= '0';
				EN_BUF <= '1';
				next_state <= SELECT_ROM2;
			when SELECT_ROM2 =>
				EN_BUF <= '0';
				SEL_ROM <= '1';
				next_state <= SAVE_SUM;
			when SAVE_SUM =>
				EN_BUF <= '1';
				next_state <= SEND_REQ;
			when SEND_REQ =>
				EN_BUF <= '0';
				REQ <= '1';
				if(ACK = '1') then
					next_state <= WAIT_ACK;
				else
					next_state <= SEND_REQ;
				end if;
			when WAIT_ACK =>
				REQ <= '0';
				if(ACK = '0') then
					next_state <= NEXT_ADDRESS;
				else
					next_state <= WAIT_ACK;
				end if;
			when NEXT_ADDRESS =>
				INC <= '1';
				if(DIV = '1') then
					next_state <= TERMINAZIONE;
				else
					next_state <= IDLE;
				end if;
			when TERMINAZIONE =>
				INC <= '0';
				next_state <= TERMINAZIONE;
        end case;
    end process;
end FSM;
