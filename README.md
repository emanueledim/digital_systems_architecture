[![en](https://img.shields.io/badge/lang-en-red.svg)](https://github.com/emanueledim/digital_systems_architecture/blob/main/README-en.md)

# Contenuto
Repository contenente lo svolgimento della prova d'esame, consistente nella progettazione, implementazione e simulazione in VHDL un sistema di nodi che elaborano dati da una ROM.

# Traccia
Progettare, implementare e simulare in VHDL la seguente architettura.
Un nodo A è alimentato da 2 ROM di N byte. Tale nodo trasmette a un altro nodo B il valore ottenuto sommando gli elementi delle due ROM in posizioni omologhe. Il nodo B a sua volta è dotato di due moduli di memoria MEM1 e MEM2: i byte ricevuti da B sono memorizzati in MEM1 se positivi, mentre vengono memorizzati in MEM2 se nulli o negativi.
Progettare il sistema utilizzando un componente multiplexer in A e un componente demultiplexer in B. Inserire un sommatore progettato con "structural" in A.

# Progettazione
I numeri memorizzati nelle ROM sono espressi in complemento a due, ciò permette di effettuare semplicemente delle somme senza ulteriori componenti.
La comunicazione tra i due nodi avviene tramite protocollo di hs, inviando in parallelo gli 8 bit risultati dall'operazione di somma.
N = 8, quindi le ROM e le memoria dispongono di 8 locazioni di 8 bit ciascuna. Gli ingressi di indirizzi saranno di 3 bit.

# Nodo A
## Unità di controllo
Il nodo A dispone dei seguenti segnali:
* REQ: segnale che serve ad informare B quando un nuovo dato è disponibile sulla linea DATA da 8 bit.
* DATA: bus da 8 bit che contiene il dato da inviare a B.
* ACK: segnale che serve ad informare A quando B ha acquisito con successo il dato sulla linea DATA.
* START: comincia la preparazione e l'invio di un nuovo dato da parte di A verso B.

## Unità operativa
L'unità operativa dispone dei seguenti componenti:
* ROM1 e ROM2: sono le ROM che contengono i byte da sommare tra di essi. Il segnale R permette di leggere il dato riferito dalla locazione di memoria proveniente dal contatore CONT_ROM.
* CONT_ROM: contatore di indirizzi che seleziona la locazione dei byte delle ROM. L'uscita DIV informa l'UC quando sono stati inviati tutti i byte. 
* MUX: seleziona il byte della ROM1 o ROM2 da propagare all'addizionatore, attraverso il segnale di selezione SEL_ROM, abilitato dall'UC.
* ADDER: addizionatore che effettua la somma tra OP1 e OP2. Esso è implementato come un Ripple Carry Adder.
* REG_BUF: registro di buffer da 8 bit che memorizza la somma e propaga il dato a B. è dotato dell'ingresso RST_BUF per permettere l'azzeramento del registro prima di effettuare la somma degli operandi successivi. Inizialmente verrà salvato l'operando proveniente dalla ROM1, dopodiché verrà effettuata la somma tra il contenuto di questo registro, e il byte proveniente dalla ROM2, la quale verrà selezionata grazie al MUX.
L'adder combinatoro è stato implementato in maniera strutturale come un Ripple Carry Adder, utilizzando i FULL ADDER. Cin è posto a 0 mentre il Cout non è stato utilizzato.
Il full adder è stato implementato in maniera dataflow, descrivendo le funzioni logiche di SUM e Cout.
