//=====================================================================
// Author   : H Geng
// Version  : v1.2
// Description:
//  riscv inst defines for debug probe
//=====================================================================

`define DBG_OPCODE_LOAD     7'b0000011  // I1
`define DBG_OPCODE_MISC_MEM 7'b0001111  // I3
`define DBG_OPCODE_OP_IMM   7'b0010011  // I1/I2
`define DBG_OPCODE_AUIPC    7'b0010111  // U
`define DBG_OPCODE_STORE    7'b0100011  // S
`define DBG_OPCODE_OP       7'b0110011  // R
`define DBG_OPCODE_LUI      7'b0110111  // U
`define DBG_OPCODE_BRANCH   7'b1100011  // B
`define DBG_OPCODE_JALR     7'b1100111  // I1
`define DBG_OPCODE_JAL      7'b1101111  // J
`define DBG_OPCODE_SYSTEM   7'b1110011  // I4/I5

// string. Radix=ASCII
`define DBG_REG_ASCII_X0    "x0/zero";
`define DBG_REG_ASCII_X1    "x1/ra  ";
`define DBG_REG_ASCII_X2    "x2/sp  ";
`define DBG_REG_ASCII_X3    "x3/gp  ";
`define DBG_REG_ASCII_X4    "x4/tp  ";
`define DBG_REG_ASCII_X5    "x5/t0  ";
`define DBG_REG_ASCII_X6    "x6/t1  ";
`define DBG_REG_ASCII_X7    "x7/t2  ";
`define DBG_REG_ASCII_X8    "x8/s0  ";
`define DBG_REG_ASCII_X9    "x9/s1  ";
`define DBG_REG_ASCII_X10   "x10/a0 ";
`define DBG_REG_ASCII_X11   "x11/a1 ";
`define DBG_REG_ASCII_X12   "x12/a2 ";
`define DBG_REG_ASCII_X13   "x13/a3 ";
`define DBG_REG_ASCII_X14   "x14/a4 ";
`define DBG_REG_ASCII_X15   "x15/a5 ";
`define DBG_REG_ASCII_X16   "x16/a6 ";
`define DBG_REG_ASCII_X17   "x17/a7 ";
`define DBG_REG_ASCII_X18   "x18/s2 ";
`define DBG_REG_ASCII_X19   "x19/s3 ";
`define DBG_REG_ASCII_X20   "x20/s4 ";
`define DBG_REG_ASCII_X21   "x21/s5 ";
`define DBG_REG_ASCII_X22   "x22/s6 ";
`define DBG_REG_ASCII_X23   "x23/s7 ";
`define DBG_REG_ASCII_X24   "x24/s8 ";
`define DBG_REG_ASCII_X25   "x25/s9 ";
`define DBG_REG_ASCII_X26   "x26/s10";
`define DBG_REG_ASCII_X27   "x27/s11";
`define DBG_REG_ASCII_X28   "x28/t3 ";
`define DBG_REG_ASCII_X29   "x29/t4 ";
`define DBG_REG_ASCII_X30   "x30/t5 ";
`define DBG_REG_ASCII_X31   "x31/t6 ";

// string. Radix=ASCII
`define DBG_INST_TYPE_ASCII_R         "R   "
`define DBG_INST_TYPE_ASCII_I1        "I1  "  // JALR, LOAD, OP-IMM without shamt
`define DBG_INST_TYPE_ASCII_I2        "I2  "  // OP-IMM with shamt
`define DBG_INST_TYPE_ASCII_I3        "I3  "  // FENCE
`define DBG_INST_TYPE_ASCII_I4        "I4  "  // ECALL/EBREAK/Zicsr-CSRRW/CSRRS/CSRRC
`define DBG_INST_TYPE_ASCII_I5        "I5  "  // Zicsr-CSRRWI/CSRRSI/CSRRCI
`define DBG_INST_TYPE_ASCII_S         "S   "
`define DBG_INST_TYPE_ASCII_B         "B   "
`define DBG_INST_TYPE_ASCII_U         "U   "
`define DBG_INST_TYPE_ASCII_J         "J   "
`define DBG_INST_TYPE_ASCII_INVALID   "IVLD"

 // string. Radix=ASCII
`define DBG_INST_NAME_ASCII_INVALID    "INVALID   "    // Invalid Inst
`define DBG_INST_NAME_ASCII_LUI        "LUI       " 
`define DBG_INST_NAME_ASCII_AUIPC      "AUIPC     " 
`define DBG_INST_NAME_ASCII_JAL        "JAL       " 
`define DBG_INST_NAME_ASCII_J          "J         "    // Pseudo-Inst
`define DBG_INST_NAME_ASCII_JALR       "JALR      " 
`define DBG_INST_NAME_ASCII_JR         "JR        "    // Pseudo-Inst
`define DBG_INST_NAME_ASCII_RET        "RET       "    // Pseudo-Inst
`define DBG_INST_NAME_ASCII_BEQ        "BEQ       " 
`define DBG_INST_NAME_ASCII_BEQZ       "BEQZ      "    // Pseudo-Inst
`define DBG_INST_NAME_ASCII_BNE        "BNE       " 
`define DBG_INST_NAME_ASCII_BNEZ       "BNEZ      "    // Pseudo-Inst
`define DBG_INST_NAME_ASCII_BLT        "BLT       " 
`define DBG_INST_NAME_ASCII_BGT        "BGT       "    // Pseudo-Inst
`define DBG_INST_NAME_ASCII_BLTZ       "BLTZ      "    // Pseudo-Inst
`define DBG_INST_NAME_ASCII_BGTZ       "BGTZ      "    // Pseudo-Inst
`define DBG_INST_NAME_ASCII_BGE        "BGE       " 
`define DBG_INST_NAME_ASCII_BLE        "BLE       "    // Pseudo-Inst
`define DBG_INST_NAME_ASCII_BGEZ       "BGEZ      "    // Pseudo-Inst
`define DBG_INST_NAME_ASCII_BLEZ       "BLEZ      "    // Pseudo-Inst
`define DBG_INST_NAME_ASCII_BLTU       "BLTU      " 
`define DBG_INST_NAME_ASCII_BGTU       "BGTU      "    // Pseudo-Inst
`define DBG_INST_NAME_ASCII_BGEU       "BGEU      " 
`define DBG_INST_NAME_ASCII_BLEU       "BLEU      "    // Pseudo-Inst
`define DBG_INST_NAME_ASCII_LB         "LB        " 
`define DBG_INST_NAME_ASCII_LH         "LH        " 
`define DBG_INST_NAME_ASCII_LW         "LW        " 
`define DBG_INST_NAME_ASCII_LBU        "LBU       " 
`define DBG_INST_NAME_ASCII_LHU        "LHU       " 
`define DBG_INST_NAME_ASCII_SB         "SB        " 
`define DBG_INST_NAME_ASCII_SH         "SH        " 
`define DBG_INST_NAME_ASCII_SW         "SW        " 
`define DBG_INST_NAME_ASCII_ADDI       "ADDI      " 
`define DBG_INST_NAME_ASCII_NOP        "NOP       "    // Pseudo-Inst
`define DBG_INST_NAME_ASCII_MV         "MV        "    // Pseudo-Inst
`define DBG_INST_NAME_ASCII_SLTI       "SLTI      " 
`define DBG_INST_NAME_ASCII_SLTIU      "SLTIU     " 
`define DBG_INST_NAME_ASCII_XORI       "XORI      " 
`define DBG_INST_NAME_ASCII_NOT        "NOT       "    // Pseudo-Inst
`define DBG_INST_NAME_ASCII_ORI        "ORI       " 
`define DBG_INST_NAME_ASCII_ANDI       "ANDI      " 
`define DBG_INST_NAME_ASCII_SLLI       "SLLI      " 
`define DBG_INST_NAME_ASCII_SRLI       "SRLI      " 
`define DBG_INST_NAME_ASCII_SRAI       "SRAI      " 
`define DBG_INST_NAME_ASCII_ADD        "ADD       " 
`define DBG_INST_NAME_ASCII_SUB        "SUB       " 
`define DBG_INST_NAME_ASCII_NEG        "NEG       "    // Pseudo-Inst
`define DBG_INST_NAME_ASCII_SLL        "SLL       " 
`define DBG_INST_NAME_ASCII_SLT        "SLT       " 
`define DBG_INST_NAME_ASCII_SLTZ       "SLTZ      "    // Pseudo-Inst
`define DBG_INST_NAME_ASCII_SGTZ       "SGTZ      "    // Pseudo-Inst
`define DBG_INST_NAME_ASCII_SLTU       "SLTU      " 
`define DBG_INST_NAME_ASCII_SNEZ       "SNEZ      "    // Pseudo-Inst
`define DBG_INST_NAME_ASCII_XOR        "XOR       " 
`define DBG_INST_NAME_ASCII_SRL        "SRL       " 
`define DBG_INST_NAME_ASCII_SRA        "SRA       " 
`define DBG_INST_NAME_ASCII_OR         "OR        " 
`define DBG_INST_NAME_ASCII_AND        "AND       " 
`define DBG_INST_NAME_ASCII_FENCE      "FENCE     " 
`define DBG_INST_NAME_ASCII_FENCE_TSO  "FENCE_TSO "    // Pseudo-Inst
`define DBG_INST_NAME_ASCII_PAUSE      "PAUSE     "    // Pseudo-Inst
`define DBG_INST_NAME_ASCII_ECALL      "ECALL     " 
`define DBG_INST_NAME_ASCII_EBREAK     "EBREAK    " 

`define DBG_INST_NAME_ASCII_CSRRW      "CSRRW     "
`define DBG_INST_NAME_ASCII_CSRRS      "CSRRS     "
`define DBG_INST_NAME_ASCII_CSRRC      "CSRRC     "
`define DBG_INST_NAME_ASCII_CSRRWI     "CSRRWI    "
`define DBG_INST_NAME_ASCII_CSRRSI     "CSRRSI    "
`define DBG_INST_NAME_ASCII_CSRRCI     "CSRRCI    "

// The follows are designed for real hardware decoder?

// `define INST_TYPE_R         6'b100_000
// `define INST_TYPE_I         6'b010_000
// `define INST_TYPE_I1        6'b010_001
// `define INST_TYPE_I2        6'b010_010
// `define INST_TYPE_I3        6'b010_011
// `define INST_TYPE_I4        6'b010_100
// `define INST_TYPE_S         6'b001_000
// `define INST_TYPE_B         6'b000_100
// `define INST_TYPE_U         6'b000_010
// `define INST_TYPE_J         6'b000_001
// `define INST_TYPE_INVALID   6'b000_000

// `define INST_INVALID    'd0     // Invalid Inst
// `define INST_LUI        'd1
// `define INST_AUIPC      'd2
// `define INST_JAL        'd3
// `define INST_J          'd43    // Pseudo-Inst
// `define INST_JALR       'd4
// `define INST_JR         'd44    // Pseudo-Inst
// `define INST_RET        'd45    // Pseudo-Inst
// `define INST_BEQ        'd5
// `define INST_BEQZ       'd46    // Pseudo-Inst
// `define INST_BNE        'd6
// `define INST_BNEZ       'd47    // Pseudo-Inst
// `define INST_BLT        'd7
// `define INST_BGT        'd48    // Pseudo-Inst
// `define INST_BLTZ       'd49    // Pseudo-Inst
// `define INST_BGTZ       'd50    // Pseudo-Inst
// `define INST_BGE        'd8
// `define INST_BLE        'd51    // Pseudo-Inst
// `define INST_BGEZ       'd52    // Pseudo-Inst
// `define INST_BLEZ       'd53    // Pseudo-Inst
// `define INST_BLTU       'd9
// `define INST_BGTU       'd54    // Pseudo-Inst
// `define INST_BGEU       'd10
// `define INST_BLEU       'd55    // Pseudo-Inst
// `define INST_LB         'd11
// `define INST_LH         'd12
// `define INST_LW         'd13
// `define INST_LBU        'd14
// `define INST_LHU        'd15
// `define INST_SB         'd16
// `define INST_SH         'd17
// `define INST_SW         'd18
// `define INST_ADDI       'd19
// `define INST_NOP        'd56    // Pseudo-Inst
// `define INST_MV         'd57    // Pseudo-Inst
// `define INST_SLTI       'd20
// `define INST_SLTIU      'd21
// `define INST_XORI       'd22
// `define INST_NOT        'd58    // Pseudo-Inst
// `define INST_ORI        'd23
// `define INST_ANDI       'd24
// `define INST_SLLI       'd25
// `define INST_SRLI       'd26
// `define INST_SRAI       'd27
// `define INST_ADD        'd28
// `define INST_SUB        'd29
// `define INST_NEG        'd59    // Pseudo-Inst
// `define INST_SLL        'd30
// `define INST_SLT        'd31
// `define INST_SLTZ       'd60    // Pseudo-Inst
// `define INST_SGTZ       'd61    // Pseudo-Inst
// `define INST_SLTU       'd32
// `define INST_SNEZ       'd62    // Pseudo-Inst
// `define INST_XOR        'd33
// `define INST_SRL        'd34
// `define INST_SRA        'd35
// `define INST_OR         'd36
// `define INST_AND        'd37
// `define INST_FENCE      'd38
// `define INST_FENCE_TSO  'd41    // Pseudo-Inst
// `define INST_PAUSE      'd42    // Pseudo-Inst
// `define INST_ECALL      'd39
// `define INST_EBREAK     'd40
