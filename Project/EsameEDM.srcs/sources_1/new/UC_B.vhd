library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UC_B is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           REQ : in STD_LOGIC;
           POS : in STD_LOGIC;
           NOT_POS : in STD_LOGIC;
           DIV_BYTE : in STD_LOGIC;
           EN_IN : out STD_LOGIC;
           SEL_MEM : out STD_LOGIC;
           W1 : out STD_LOGIC;
           W2 : out STD_LOGIC;
           INC_ADDR_MEM1 : out STD_LOGIC;
           INC_ADDR_MEM2 : out STD_LOGIC;
           INC_BYTE : out STD_LOGIC;
           ACK : out STD_LOGIC);
end UC_B;

architecture FSM of UC_B is
	TYPE state IS (WAIT_REQ, GET_DATA, SEND_ACK, CHECK_POSITIVE, SELECT_MEM1,
				SELECT_MEM2, SAVE_MEM1, SAVE_MEM2, NEXT_BYTE, TERMINAZIONE);
	signal current_state : state := WAIT_REQ;
	signal next_state : state;

begin
    UPDATE_STATE: process(CLK)
    begin
        if(rising_edge(CLK)) then
            if(RST = '1') then
                current_state <= WAIT_REQ;
            else
                current_state <= next_state;
            end if;
        end if;
    end process;
    
    
    COMB: process(REQ, POS, NOT_POS, DIV_BYTE, current_state)
    begin
        case current_state is
            when WAIT_REQ =>
				EN_IN <= '0';
				SEL_MEM <= '0';
				W1 <= '0';
				W2 <= '0';
				INC_ADDR_MEM1 <= '0';
				INC_ADDR_MEM2 <= '0';
				INC_BYTE <= '0';
				ACK <= '0';
				if(REQ = '1') then
					next_state <= GET_DATA;
				else
					next_state <= WAIT_REQ;
				end if;
			when GET_DATA =>
				EN_IN <= '1';
				next_state <= SEND_ACK;
			when SEND_ACK =>
				EN_IN <= '0';
				ACK <= '1';
				if(REQ = '0') then
					next_state <= CHECK_POSITIVE;
				else
					next_state <= SEND_ACK;
				end if;
			when CHECK_POSITIVE =>
				ACK <= '0';
				if(POS = '1') then
					next_state <= SELECT_MEM1;
				elsif(NOT_POS = '1') then
					next_state <= SELECT_MEM2;
				else
					next_state <= CHECK_POSITIVE;
				end if;
			when SELECT_MEM1 =>
				SEL_MEM <= '0';
				next_state <= SAVE_MEM1;
			when SELECT_MEM2 =>
				SEL_MEM <= '1';
				next_state <= SAVE_MEM2;
			when SAVE_MEM1 =>
				W1 <= '1';
				INC_ADDR_MEM1 <= '1';
				next_state <= NEXT_BYTE;
			when SAVE_MEM2 =>
				W2 <= '1';
				INC_ADDR_MEM2 <= '1';
				next_state <= NEXT_BYTE;
			when NEXT_BYTE =>
				W1 <= '0';
				W2 <= '0';
				INC_ADDR_MEM1 <= '0';
				INC_ADDR_MEM2 <= '0';
				SEL_MEM <= '0';
				INC_BYTE <= '1';
				if(DIV_BYTE = '1') then
					next_state <= TERMINAZIONE;
				else
					next_state <= WAIT_REQ;
				end if;
			when TERMINAZIONE =>
				INC_BYTE <= '0';
				next_state <= TERMINAZIONE;
        end case;
    end process;
end FSM;
