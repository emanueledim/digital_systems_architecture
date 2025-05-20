[![it](https://img.shields.io/badge/lang-it-blue.svg)](https://github.com/emanueledim/digital_systems_architecture/blob/main/README.md)

# Content
This repository contains the exam project, which consists of designing, implementing, and simulating in VHDL a system of nodes that process data from a ROM.

# Assignment
Design, implement, and simulate the following architecture in VHDL.
A node A is fed by 2 ROMs of N bytes. This node transmits to another node B the value obtained by summing the elements of the two ROMs at corresponding positions. Node B is equipped with two memory modules, MEM1 and MEM2: the bytes received by B are stored in MEM1 if positive, and in MEM2 if zero or negative.
Design the system using a multiplexer component in A and a demultiplexer component in B. Insert an adder in A designed using a structural approach.

# Design
The numbers stored in the ROMs are expressed in two’s complement, which allows summing them directly without additional components.
Communication between the two nodes occurs via a handshake protocol, sending in parallel the 8-bit result of the addition.
N = 8, so both the ROMs and the memory modules have 8 locations of 8 bits each. The address inputs are 3-bit wide.

# Node A
## Control Unità
Node A features the following signals:
* REQ: signal used to notify node B when a new data value is available on the 8-bit DATA line.
* DATA: 8-bit bus containing the data to be sent to B.
* ACK: signal used to inform node A when node B has successfully received the data on the DATA line.
* START: initiates the preparation and sending of a new data value from A to B.

## Operational Unit
The operational unit includes the following components:
* ROM1 and ROM2: ROMs that store the bytes to be summed. The R signal enables reading from the memory location indicated by the CONT_ROM counter.
* CONT_ROM: address counter that selects the memory location of the ROM bytes. The DIV output informs the control unit when all bytes have been sent.
* MUX: selects the byte from either ROM1 or ROM2 to pass to the adder, through the SEL_ROM selection signal, enabled by the control unit.
* ADDER: performs the sum between OP1 and OP2. It is implemented as a Ripple Carry Adder.
* REG_BUF: 8-bit buffer register that stores the sum and propagates the data to node B. It has a RST_BUF input to reset the register before computing the next sum. Initially, the operand from ROM1 is stored in this register, then the sum is performed between the content of the register and the byte from ROM2, which is selected via the MUX.

The combinational adder is implemented structurally as a Ripple Carry Adder using FULL ADDERs. Cin is set to 0, while Cout is not used.
The full adder is implemented using a dataflow approach, describing the logical functions of SUM and Cout.