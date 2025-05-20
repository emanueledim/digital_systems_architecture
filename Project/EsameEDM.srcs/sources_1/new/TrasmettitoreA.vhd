library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity TrasmettitoreA is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           START : in STD_LOGIC;
           ACK : in STD_LOGIC;
           REQ : out STD_LOGIC;
           DATA : out STD_LOGIC_VECTOR (7 downto 0));
end TrasmettitoreA;

architecture Structural of TrasmettitoreA is
	signal R: std_logic; --Segnale di comando di lettura per entrambe le ROM (dall'UC)
	signal OUTROM1: std_logic_vector(7 downto 0); --Operando in uscita dalla ROM 1 e diretta nel MUX
	signal OUTROM2: std_logic_vector(7 downto 0); --Operando in uscita dalla ROM 2 e diretta nel MUX
	signal ADDRESS: std_logic_vector(2 downto 0); --Indirizzo della prossima lettura dalle ROM
	signal SEL_ROM: std_logic; --Segnale selezione del MUX (ROM1 o ROM2) (dall'UC)
	signal OP1: std_logic_vector(7 downto 0); --Operando in uscita dal MUX e diretto all'ADDER
	signal OP2: std_logic_vector(7 downto 0); --Operando in uscita dal REGISTRO BUFF e diretto all'ADDER
	signal RST_BUF: std_logic; --RST in ingresso al REGISTRO BUFF
	signal RST_BUF_UC: std_logic; --RST proveniente dall'UC per resettare il REGISTRO BUFF
	signal INC: std_logic; --Segnale per incrementare il contatore (dall'UC)
	signal EN_BUF: std_logic; --Segnale per abilitare alla memorizzazione del REGISTRO BUFF (dall'UC)
	signal DIV: std_logic; --Segnale di stato per informare l'UC che sono stati elaborati tutti gli operando delle ROM
	signal OUTREGBUFF: std_logic_vector(7 downto 0); --Uscita del REGISTRO BUFF
	signal SUM: std_logic_vector(7 downto 0); --Uscita del sommatore
begin
RST_BUF <= RST OR RST_BUF_UC;
OP2 <= OUTREGBUFF;
DATA <= OUTREGBUFF;

	ROM1: entity work.ROM1 port map( 
		CLK => CLK,
		READ_ROM => R,
		ADDRESS => ADDRESS,
		DATA_OUT => OUTROM1
	);
	
	ROM2: entity work.ROM2 port map( 
		CLK => CLK,
		READ_ROM => R,
		ADDRESS => ADDRESS,
		DATA_OUT => OUTROM2
	);
	
	CONT_ADDRESS: entity work.Contatore generic map(
		M => 8
	) port map( 
		CLK => CLK,
		RST => RST,
		ENABLE => INC,
		COUNT => ADDRESS,
		DIV => DIV 
	);


	MUX_OPERANDO1: entity work.Mux2_1 generic map(
	N => 8
	) port map(
		a1 => OUTROM1,
		a2 => OUTROM2,
		s => SEL_ROM,
		y => OP1
	);
	
	RCA: entity work.RippleCarryAdder generic map(
		N => 8
    ) port map(
		A => OP1,
		B => OP2,
		Carry_in => '0',
		S => SUM
	);

	REGISTRO_BUFF: entity work.Registro generic map(
		M => 8
	) port map(
		CLK => CLK,
		RST => RST_BUF,
		INPUT => SUM,
		ENABLE => EN_BUF,
		OUTPUT => OUTREGBUFF
	);


	UC_A: entity work.UC_A port map(
		CLK => CLK,
		RST => RST,
        START => START,
		DIV => DIV,
		ACK => ACK,
        R => R,
		SEL_ROM => SEL_ROM,
		EN_BUF => EN_BUF,
		INC => INC,
		RST_BUF_UC => RST_BUF_UC,
		REQ => REQ
	);
end Structural;
