library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity RicevitoreB is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           REQ : in STD_LOGIC;
           DATA : in STD_LOGIC_VECTOR (7 downto 0);
           ACK : out STD_LOGIC);
end RicevitoreB;

architecture Structural of RicevitoreB is

	--Dato > 0 -> In MEM1
	--Dato < o = 0 -> In MEM2
	signal W1: std_logic; --Segnale di scrittura per MEM1 
	signal W2: std_logic; --Segnale di scrittura per MEM2
	signal ADDR_MEM1: std_logic_vector(2 downto 0); --Indirizzo per la prossima scrittura in MEM1 
	signal ADDR_MEM2: std_logic_vector(2 downto 0); --Indirizzo per la prossima scrittura in MEM2
	signal INDATA_MEM1: std_logic_vector(7 downto 0); --Dato in ingresso alla memoria MEM1
	signal INDATA_MEM2: std_logic_vector(7 downto 0); --Dato in ingresso alla memoria MEM2
	signal DIV_MEM1: std_logic; --Segnale di stato che informa l'UC riguardo il contatore degli indirizzi di MEM1
	signal DIV_MEM2: std_logic; --Segnale di stato che informa l'UC riguardo il contatore degli indirizzi di MEM2
	signal INC_ADDR_MEM1: std_logic; --Segnale di incremento del contatore degli indirizzi di MEM1
	signal INC_ADDR_MEM2: std_logic; --Segnale di incremento del contatore degli indirizzi di MEM2
	signal OUTREGDATA: std_logic_vector(7 downto 0); --Dato in uscita dal registro di buff posto in ricezione
	signal SEL_MEM: std_logic; --Segnale per selezionare la linea lungo la quale verrà propagato il dato, verso MEM1 o MEM2
    signal POS: std_logic; --Flag per segnalare all'UC che il dato e' strettamente positivo
    signal NOT_POS: std_logic; --Flag per segnalare all'UC che il dato e' nullo o negativo
    signal INC_BYTE: std_logic; --Segnale per incrementare il contatore dei byte ricevuti
    signal DIV_BYTE: std_logic; --Segnale di stato per informare l'UC che sono stati ricevuti tutti i byte
    signal EN_IN: std_logic; --Segnale di memorizzazione del byte ricevuto

begin

	REGISTRO_BUFF: entity work.Registro generic map(
		M => 8
	) port map(
		CLK => CLK,
		RST => RST,
		INPUT => DATA,
		ENABLE => EN_IN,
		OUTPUT => OUTREGDATA
	);
	
	CHECK_POSITIVE: entity work.CheckPositive port map(
		INPUT => OUTREGDATA,
		POSITIVE => POS,
		NOT_POSITIVE => NOT_POS
	);
	
	DEMUX_MEM: entity work.Demux1_2 generic map(
		N => 8
	) port map(
		a => OUTREGDATA,
		s => SEL_MEM,
		y1 => INDATA_MEM1,
		y2 => INDATA_MEM2
	);
	
	
	MEM1: entity work.Memoria generic map(
	N => 8,
	WORD => 8
	) port map ( 
		CLK => CLK,
		RST => RST,
		R => '0', --Non vengono mai lette
		W => W1,
		ADDRESS => ADDR_MEM1,
		DATA_INPUT => INDATA_MEM1
	);
	
	MEM2: entity work.Memoria generic map(
	N => 8,
	WORD => 8
	) port map ( 
		CLK => CLK,
		RST => RST,
		R => '0', --Non vengono mai lette
		W => W2,
		ADDRESS => ADDR_MEM2,
		DATA_INPUT => INDATA_MEM2
	);

	CONT_ADDRESS_1: entity work.Contatore generic map(
		M => 8
	) port map( 
		CLK => CLK,
		RST => RST,
		ENABLE => INC_ADDR_MEM1,
		COUNT => ADDR_MEM1,
		DIV => DIV_MEM1
	);
	
	CONT_ADDRESS_2: entity work.Contatore generic map(
		M => 8
	) port map( 
		CLK => CLK,
		RST => RST,
		ENABLE => INC_ADDR_MEM2,
		COUNT => ADDR_MEM2,
		DIV => DIV_MEM2 
	);
	
	CONT_BYTE: entity work.Contatore generic map(
		M => 8
	) port map( 
		CLK => CLK,
		RST => RST,
		ENABLE => INC_BYTE,
		DIV => DIV_BYTE
	);
	
	
	
	UC_B: entity work.UC_B port map(
		CLK => CLK,
        RST => RST,
        REQ => REQ,
        POS => POS,
        NOT_POS => NOT_POS,
        DIV_BYTE => DIV_BYTE,
        EN_IN => EN_IN,
		SEL_MEM => SEL_MEM,
        W1 => W1,
        W2 => W2,
        INC_ADDR_MEM1 => INC_ADDR_MEM1,
        INC_ADDR_MEM2 => INC_ADDR_MEM2,
        INC_BYTE => INC_BYTE,
        ACK => ACK);
end Structural;
