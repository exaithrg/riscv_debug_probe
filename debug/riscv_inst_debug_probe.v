//=====================================================================
// Author   : H Geng
// Version  : v1.2
// Description:
//  RISC-V instruction debug probe
//** ADD THIS PROBE TO TESTBENCH & SIMULATION SOURCES **
//** DO NOT ADD THIS PROBE TO TAPE-OUT CODES **
//=====================================================================

`include "riscv_inst_debug_probe_defines.v"

// Instantiation Example
// ridp means riscv_inst_debug_probe, add this prefix to avoid name conflicts
// wire [31:0]      ridp_inst              ;
// wire [10*8-1:0]  ridp_inst_name_ascii   ;   // string. Radix=ASCII;
// wire [4*8-1:0]   ridp_inst_type_ascii   ;   // string. Radix=ASCII;
// wire [7*8-1:0]   ridp_rs1_name_ascii    ;   // string. Radix=ASCII;
// wire [7*8-1:0]   ridp_rs2_name_ascii    ;   // string. Radix=ASCII;
// wire [7*8-1:0]   ridp_rd_name_ascii     ;   // string. Radix=ASCII;
// wire [6:0]       ridp_opcode            ;
// wire [4:0]       ridp_rs1               ;
// wire [4:0]       ridp_rs2               ;
// wire [4:0]       ridp_rd                ;
// wire [2:0]       ridp_funct3            ;
// wire [6:0]       ridp_funct7            ;
// wire [31:0]      ridp_immi              ;
// wire [31:0]      ridp_imms              ;  // NOTE: imms = offset
// wire [31:0]      ridp_immb              ;
// wire [31:0]      ridp_immu              ;
// wire [31:0]      ridp_immj              ;
// wire [4:0]       ridp_shamt             ;
// wire [3:0]       ridp_fm                ;
// wire [3:0]       ridp_pred              ;
// wire [3:0]       ridp_succ              ;
// wire [11:0]      ridp_csr               ;
// wire [4:0]       ridp_zimm              ;
// 
// assign ridp_inst = cpu_core.ifu.instruction;
// 
// riscv_inst_debug_probe u_riscv_inst_debug_probe (
//     .inst               ( ridp_inst            ),
//     .inst_name_ascii    ( ridp_inst_name_ascii ),
//     .inst_type_ascii    ( ridp_inst_type_ascii ),
//     .rs1_name_ascii     ( ridp_rs1_name_ascii  ),
//     .rs2_name_ascii     ( ridp_rs2_name_ascii  ),
//     .rd_name_ascii      ( ridp_rd_name_ascii   ),
//     .opcode             ( ridp_opcode          ),
//     .rs1                ( ridp_rs1             ),
//     .rs2                ( ridp_rs2             ),
//     .rd                 ( ridp_rd              ),
//     .funct3             ( ridp_funct3          ),
//     .funct7             ( ridp_funct7          ),
//     .immi               ( ridp_immi            ),
//     .imms               ( ridp_imms            ),
//     .immb               ( ridp_immb            ),
//     .immu               ( ridp_immu            ),
//     .immj               ( ridp_immj            ),
//     .shamt              ( ridp_shamt           ),
//     .fm                 ( ridp_fm              ),
//     .pred               ( ridp_pred            ),
//     .succ               ( ridp_succ            ),
//     .csr                ( ridp_csr             ),
//     .zimm               ( ridp_zimm            )
// );


module riscv_inst_debug_probe(
    input       [31:0]      inst
    ,output reg [10*8-1:0]  inst_name_ascii   // string. Radix=ASCII
    ,output reg [4*8-1:0]   inst_type_ascii   // string. Radix=ASCII
    ,output reg [7*8-1:0]   rs1_name_ascii    // string. Radix=ASCII
    ,output reg [7*8-1:0]   rs2_name_ascii    // string. Radix=ASCII
    ,output reg [7*8-1:0]   rd_name_ascii     // string. Radix=ASCII
    ,output reg [6:0]       opcode  
    ,output reg [4:0]       rs1     
    ,output reg [4:0]       rs2     
    ,output reg [4:0]       rd      
    ,output reg [2:0]       funct3  
    ,output reg [6:0]       funct7  
    ,output reg [31:0]      immi    
    ,output reg [31:0]      imms    // NOTE: imms = offset 
    ,output reg [31:0]      immb    
    ,output reg [31:0]      immu    
    ,output reg [31:0]      immj    
    ,output reg [4:0]       shamt   
    ,output reg [3:0]       fm      
    ,output reg [3:0]       pred    
    ,output reg [3:0]       succ    
    ,output reg [11:0]      csr     
    ,output reg [4:0]       zimm    
);

    // decode inst type
    always @* begin
        if(inst_name_ascii == `DBG_INST_NAME_ASCII_INVALID) begin
            inst_type_ascii = `DBG_INST_TYPE_ASCII_INVALID;
        end else begin
            case(inst[6:0])
                `DBG_OPCODE_LOAD, `DBG_OPCODE_JALR: begin
                    inst_type_ascii = `DBG_INST_TYPE_ASCII_I1;
                end
                `DBG_OPCODE_MISC_MEM: begin
                    inst_type_ascii = `DBG_INST_TYPE_ASCII_I3;
                end
                `DBG_OPCODE_OP_IMM: begin
                    // SLLI, SRLI, SRAI
                    if(inst[14:12] == 3'b001 || inst[14:12] == 3'b101) begin
                        inst_type_ascii = `DBG_INST_TYPE_ASCII_I2;
                    end else begin
                        inst_type_ascii = `DBG_INST_TYPE_ASCII_I1;
                    end
                end
                `DBG_OPCODE_AUIPC, `DBG_OPCODE_LUI: begin
                    inst_type_ascii = `DBG_INST_TYPE_ASCII_U;
                end
                `DBG_OPCODE_STORE: begin
                    inst_type_ascii = `DBG_INST_TYPE_ASCII_S;
                end
                `DBG_OPCODE_OP: begin
                    inst_type_ascii = `DBG_INST_TYPE_ASCII_R;
                end
                `DBG_OPCODE_BRANCH: begin
                    inst_type_ascii = `DBG_INST_TYPE_ASCII_B;
                end
                `DBG_OPCODE_JAL: begin
                    inst_type_ascii = `DBG_INST_TYPE_ASCII_J;
                end
                `DBG_OPCODE_SYSTEM: begin
                    // CSRRWI/CSRRSI/CSRRCI
                    if(inst[14:12] == 3'b101 || inst[14:12] == 3'b110
                        || inst[14:12] == 3'b111) begin
                        inst_type_ascii = `DBG_INST_TYPE_ASCII_I5;
                    end else begin
                        inst_type_ascii = `DBG_INST_TYPE_ASCII_I4;
                    end
                end
                default: begin
                    inst_type_ascii = `DBG_INST_TYPE_ASCII_INVALID;
                end
            endcase
        end
    end

    // decode inst name
    always @* begin
        casez(inst)
            //=======================================================
            // LUI
            32'b????????????????????_?????_0110111: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_LUI;
            end    
            //=======================================================
            // AUIPC
            32'b????????????????????_?????_0010111: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_AUIPC;
            end
            //=======================================================
            //  JAL
            32'b????????????????????_00000_1101111: begin // Pseudo-Inst
                inst_name_ascii   = `DBG_INST_NAME_ASCII_J;
            end
            32'b????????????????????_?????_1101111: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_JAL ;
            end
            //=======================================================
            //  JALR
            32'b000000000000_00001_000_00000_1100111: begin // Pseudo-Inst
                inst_name_ascii   = `DBG_INST_NAME_ASCII_RET;
            end
            32'b000000000000_?????_000_00000_1100111: begin // Pseudo-Inst
                inst_name_ascii   = `DBG_INST_NAME_ASCII_JR;
            end
            32'b????????????_?????_???_?????_1100111: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_JALR;
            end
            //=======================================================
            // BRANCH
            32'b???????_00000_?????_000_?????_1100011: begin // Pseudo-Inst
                inst_name_ascii   = `DBG_INST_NAME_ASCII_BEQZ;
            end
            32'b???????_?????_?????_000_?????_1100011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_BEQ;
            end
            32'b???????_00000_?????_001_?????_1100011: begin // Pseudo-Inst
                inst_name_ascii   = `DBG_INST_NAME_ASCII_BNEZ;
            end
            32'b???????_?????_?????_001_?????_1100011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_BNE;
            end
            // BGT cannot be detected
            32'b???????_00000_?????_100_?????_1100011: begin // Pseudo-Inst
                inst_name_ascii   = `DBG_INST_NAME_ASCII_BLTZ;
            end
            32'b???????_?????_00000_100_?????_1100011: begin // Pseudo-Inst
                inst_name_ascii   = `DBG_INST_NAME_ASCII_BGTZ;
            end
            32'b???????_?????_?????_100_?????_1100011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_BLT;
            end
            // BLE cannot be detected
            32'b???????_00000_?????_101_?????_1100011: begin // Pseudo-Inst
                inst_name_ascii   = `DBG_INST_NAME_ASCII_BGEZ;
            end
            32'b???????_?????_00000_101_?????_1100011: begin // Pseudo-Inst
                inst_name_ascii   = `DBG_INST_NAME_ASCII_BLEZ;
            end
            32'b???????_?????_?????_101_?????_1100011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_BGE;
            end
            // BGTU cannot be detected
            32'b???????_?????_?????_110_?????_1100011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_BLTU;
            end
            // BLEU cannot be detected
            32'b???????_?????_?????_111_?????_1100011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_BGEU;
            end
            //=======================================================
            // LOAD
            32'b???????_?????_?????_000_?????_0000011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_LB;
            end
            32'b???????_?????_?????_001_?????_0000011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_LH;
            end
            32'b???????_?????_?????_010_?????_0000011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_LW;
            end
            32'b???????_?????_?????_100_?????_0000011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_LBU;
            end
            32'b???????_?????_?????_101_?????_0000011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_LHU;
            end
            //=======================================================
            // STORE
            32'b???????_?????_?????_000_?????_0100011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_SB;
            end
            32'b???????_?????_?????_001_?????_0100011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_SH;
            end
            32'b???????_?????_?????_010_?????_0100011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_SW;
            end
            //=======================================================
            // OP-IMM
            32'b000000000000_00000_000_00000_0010011: begin // Pseudo-Inst
                inst_name_ascii   = `DBG_INST_NAME_ASCII_NOP;
            end
            32'b000000000000_?????_000_?????_0010011: begin // Pseudo-Inst
                inst_name_ascii   = `DBG_INST_NAME_ASCII_MV;
            end
            32'b????????????_?????_000_?????_0010011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_ADDI;
            end
            32'b????????????_?????_010_?????_0010011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_SLTI;
            end
            32'b????????????_?????_011_?????_0010011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_SLTIU;
            end
            32'b111111111111_?????_100_?????_0010011: begin // Pseudo-Inst
                inst_name_ascii   = `DBG_INST_NAME_ASCII_NOT;
            end
            32'b????????????_?????_100_?????_0010011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_XORI;
            end
            32'b????????????_?????_110_?????_0010011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_ORI;
            end
            32'b????????????_?????_111_?????_0010011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_ANDI;
            end
            32'b0000000_?????_?????_001_?????_0010011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_SLLI;
            end
            32'b0000000_?????_?????_101_?????_0010011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_SRLI;
            end
            32'b0100000_?????_?????_101_?????_0010011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_SRAI;
            end
            //=======================================================
            // OP
            32'b0000000_?????_?????_000_?????_0110011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_ADD;
            end
            32'b0100000_?????_00000_000_?????_0110011: begin // Pseudo-Inst
                inst_name_ascii   = `DBG_INST_NAME_ASCII_NEG;
            end
            32'b0100000_?????_?????_000_?????_0110011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_SUB;
            end
            32'b0000000_?????_?????_001_?????_0110011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_SLL;
            end
            32'b0000000_?????_00000_010_?????_0110011: begin // Pseudo-Inst
                inst_name_ascii   = `DBG_INST_NAME_ASCII_SLTZ;
            end
            32'b0000000_00000_?????_010_?????_0110011: begin // Pseudo-Inst
                inst_name_ascii   = `DBG_INST_NAME_ASCII_SGTZ;
            end
            32'b0000000_?????_?????_010_?????_0110011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_SLT;
            end
            32'b0000000_?????_00000_011_?????_0110011: begin // Pseudo-Inst
                inst_name_ascii   = `DBG_INST_NAME_ASCII_SNEZ;
            end
            32'b0000000_?????_?????_011_?????_0110011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_SLTU;
            end
            32'b0000000_?????_?????_100_?????_0110011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_XOR;
            end
            32'b0000000_?????_?????_101_?????_0110011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_SRL;
            end
            32'b0100000_?????_?????_101_?????_0110011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_SRA;
            end
            32'b0000000_?????_?????_110_?????_0110011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_OR;
            end
            32'b0000000_?????_?????_111_?????_0110011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_AND;
            end
            //=======================================================
            //  MISC-MEM
            32'b1000_0011_0011_00000_000_00000_0001111: begin // Pseudo-Inst
                inst_name_ascii   = `DBG_INST_NAME_ASCII_FENCE_TSO;
            end
            32'b0000_0001_0000_00000_000_00000_0001111: begin // Pseudo-Inst
                inst_name_ascii   = `DBG_INST_NAME_ASCII_PAUSE;
            end
            32'b????_????_????_?????_000_?????_0001111: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_FENCE;
                //do nothing -> order is preserved without doing anything
            end
            //=======================================================
            //  SYSTEM
            32'b000000000000_00000_000_00000_1110011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_ECALL;
            end
            32'b000000000001_00000_000_00000_1110011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_EBREAK;
            end
            32'b????????????_?????_001_?????_1110011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_CSRRW;
            end
            32'b????????????_?????_010_?????_1110011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_CSRRS;
            end
            32'b????????????_?????_011_?????_1110011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_CSRRC;
            end
            32'b????????????_?????_101_?????_1110011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_CSRRWI;
            end
            32'b????????????_?????_110_?????_1110011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_CSRRSI;
            end
            32'b????????????_?????_111_?????_1110011: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_CSRRCI;
            end
            //=======================================================
            // default
            default: begin
                inst_name_ascii   = `DBG_INST_NAME_ASCII_INVALID;
            end
        endcase
    end

    // decode inst data part
    always @* begin
        case(inst_type_ascii)
            `DBG_INST_TYPE_ASCII_R: begin
                opcode = inst[6:0];
                immi = 'bx; imms = 'bx; immb = 'bx; immu = 'bx; immj = 'bx;
                rs1 = inst[19:15]; rs2= inst[24:20]; rd = inst[11:7];
                funct3 = inst[14:12]; funct7 = inst[31:25]; shamt = 5'bxxxxx;
                fm = 4'bxxxx; pred = 4'bxxxx; succ = 4'bxxxx;
                csr = 'bx; zimm = 5'bxxxxx;
            end
            `DBG_INST_TYPE_ASCII_I1: begin // JALR, LOAD, OP-IMM without shamt
                opcode = inst[6:0];
                imms = 'bx; immb = 'bx; immu = 'bx; immj = 'bx;
                immi = {{20{inst[31]}},inst[31:20]};
                rs1 = inst[19:15]; rs2= 5'bxxxxx; rd = inst[11:7];
                funct3 = inst[14:12]; funct7 = 7'bxxxxxxx; shamt = 5'bxxxxx;
                fm = 4'bxxxx; pred = 4'bxxxx; succ = 4'bxxxx;
                csr = 'bx; zimm = 5'bxxxxx;
            end
            `DBG_INST_TYPE_ASCII_I2: begin // OP-IMM with shamt
                opcode = inst[6:0];
                immi = 'bx; imms = 'bx; immb = 'bx; immu = 'bx; immj = 'bx;
                rs1 = inst[19:15]; rs2= 5'bxxxxx; rd = inst[11:7];
                funct3 = inst[14:12]; funct7 = inst[31:25]; shamt = inst[24:20];
                fm = 4'bxxxx; pred = 4'bxxxx; succ = 4'bxxxx;
                csr = 'bx; zimm = 5'bxxxxx;
            end
            `DBG_INST_TYPE_ASCII_I3: begin // FENCE
                opcode = inst[6:0];
                immi = 'bx; imms = 'bx; immb = 'bx; immu = 'bx; immj = 'bx;
                rs1 = inst[19:15]; rs2= 5'bxxxxx; rd = inst[11:7];
                funct3 = inst[14:12]; funct7 = 7'bxxxxxxx; shamt = 5'bxxxxx;
                fm = inst[31:28]; pred = inst[27:24]; succ = inst[23:20];
                csr = 'bx; zimm = 5'bxxxxx;
            end
            `DBG_INST_TYPE_ASCII_I4: begin // ECALL/EBREAK/Zicsr-CSRRW/CSRRS/CSRRC
                opcode = inst[6:0];
                immi = 'bx; imms = 'bx; immb = 'bx; immu = 'bx; immj = 'bx;
                rs1 = inst[19:15]; rs2= 5'bxxxxx; rd = inst[11:7];
                funct3 = inst[14:12]; funct7 = 7'bxxxxxxx; shamt = 5'bxxxxx;
                fm = 4'bxxxx; pred = 4'bxxxx; succ = 4'bxxxx;
                csr = inst[31:20]; zimm = 5'bxxxxx;
            end
            `DBG_INST_TYPE_ASCII_I5: begin // Zicsr-CSRRWI/CSRRSI/CSRRCI
                opcode = inst[6:0];
                immi = 'bx; imms = 'bx; immb = 'bx; immu = 'bx; immj = 'bx;
                rs1 = 5'bxxxxx; rs2= 5'bxxxxx; rd = inst[11:7];
                funct3 = inst[14:12]; funct7 = 7'bxxxxxxx; shamt = 5'bxxxxx;
                fm = 4'bxxxx; pred = 4'bxxxx; succ = 4'bxxxx;
                csr = inst[31:20]; zimm = inst[19:15];
            end
            `DBG_INST_TYPE_ASCII_S: begin 
                opcode = inst[6:0];
                immi = 'bx; immb = 'bx; immu = 'bx; immj = 'bx;
                imms = {{20{inst[31]}},inst[31:25],inst[11:7]}; 
                rs1 = inst[19:15]; rs2= inst[24:20]; rd = 5'bxxxxx;
                funct3 = inst[14:12]; funct7 = 7'bxxxxxxx; shamt = 5'bxxxxx;
                fm = 4'bxxxx; pred = 4'bxxxx; succ = 4'bxxxx;
                csr = 'bx; zimm = 5'bxxxxx;
            end
            `DBG_INST_TYPE_ASCII_B: begin
                opcode = inst[6:0];
                immi = 'bx; imms = 'bx; immu = 'bx; immj = 'bx;
                immb = {{19{inst[31]}},inst[31],inst[7],inst[30:25],inst[11:8],1'b0};
                rs1 = inst[19:15]; rs2= inst[24:20]; rd = 5'bxxxxx;
                funct3 = inst[14:12]; funct7 = 7'bxxxxxxx; shamt = 5'bxxxxx;
                fm = 4'bxxxx; pred = 4'bxxxx; succ = 4'bxxxx;
                csr = 'bx; zimm = 5'bxxxxx;
            end
            `DBG_INST_TYPE_ASCII_U: begin
                opcode = inst[6:0];
                immi = 'bx; imms = 'bx; immb = 'bx; immj = 'bx;
                immu = {inst[31:12],12'b0};
                rs1 = 5'bxxxxx; rs2= 5'bxxxxx; rd = inst[11:7];
                funct3 = 3'bxxx; funct7 = 7'bxxxxxxx; shamt = 5'bxxxxx;
                fm = 4'bxxxx; pred = 4'bxxxx; succ = 4'bxxxx;
                csr = 'bx; zimm = 5'bxxxxx;
            end
            `DBG_INST_TYPE_ASCII_J: begin
                opcode = inst[6:0];
                immi = 'bx; imms = 'bx; immb = 'bx; immu = 'bx; 
                immj = {{11{inst[31]}},inst[31],inst[19:12],inst[20],inst[30:21],1'b0};
                rs1 = 5'bxxxxx; rs2= 5'bxxxxx; rd = 5'bxxxxx;
                funct3 = 3'bxxx; funct7 = 7'bxxxxxxx; shamt = 5'bxxxxx;
                fm = 4'bxxxx; pred = 4'bxxxx; succ = 4'bxxxx;
                csr = 'bx; zimm = 5'bxxxxx;
            end
            default: begin
                opcode = 7'bxxxxxxx;
                immi = 'bx; imms = 'bx; immb = 'bx; immu = 'bx; immj = 'bx;
                rs1 = 5'bxxxxx; rs2= 5'bxxxxx; rd = 5'bxxxxx;
                funct3 = 3'bxxx; funct7 = 7'bxxxxxxx; shamt = 5'bxxxxx;
                fm = 4'bxxxx; pred = 4'bxxxx; succ = 4'bxxxx;
                csr = 'bx; zimm = 5'bxxxxx;
            end
        endcase
    end

    // decode reg name
    always @* begin
        case(rs1)
            5'd0:  begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X0; end
            5'd1:  begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X1; end
            5'd2:  begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X2; end
            5'd3:  begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X3; end
            5'd4:  begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X4; end
            5'd5:  begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X5; end
            5'd6:  begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X6; end
            5'd7:  begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X7; end
            5'd8:  begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X8; end
            5'd9:  begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X9; end
            5'd10: begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X10; end
            5'd11: begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X11; end
            5'd12: begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X12; end
            5'd13: begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X13; end
            5'd14: begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X14; end
            5'd15: begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X15; end
            5'd16: begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X16; end
            5'd17: begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X17; end
            5'd18: begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X18; end
            5'd19: begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X19; end
            5'd20: begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X20; end
            5'd21: begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X21; end
            5'd22: begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X22; end
            5'd23: begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X23; end
            5'd24: begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X24; end
            5'd25: begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X25; end
            5'd26: begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X26; end
            5'd27: begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X27; end
            5'd28: begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X28; end
            5'd29: begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X29; end
            5'd30: begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X30; end
            5'd31: begin rs1_name_ascii = `DBG_REG_NAME_ASCII_X31; end
        endcase
    end

    always @* begin
        case(rs2)
            5'd0:  begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X0; end
            5'd1:  begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X1; end
            5'd2:  begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X2; end
            5'd3:  begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X3; end
            5'd4:  begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X4; end
            5'd5:  begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X5; end
            5'd6:  begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X6; end
            5'd7:  begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X7; end
            5'd8:  begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X8; end
            5'd9:  begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X9; end
            5'd10: begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X10; end
            5'd11: begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X11; end
            5'd12: begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X12; end
            5'd13: begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X13; end
            5'd14: begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X14; end
            5'd15: begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X15; end
            5'd16: begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X16; end
            5'd17: begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X17; end
            5'd18: begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X18; end
            5'd19: begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X19; end
            5'd20: begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X20; end
            5'd21: begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X21; end
            5'd22: begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X22; end
            5'd23: begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X23; end
            5'd24: begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X24; end
            5'd25: begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X25; end
            5'd26: begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X26; end
            5'd27: begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X27; end
            5'd28: begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X28; end
            5'd29: begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X29; end
            5'd30: begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X30; end
            5'd31: begin rs2_name_ascii = `DBG_REG_NAME_ASCII_X31; end
        endcase
    end

    always @* begin
        case(rd)
            5'd0:  begin rd_name_ascii = `DBG_REG_NAME_ASCII_X0; end
            5'd1:  begin rd_name_ascii = `DBG_REG_NAME_ASCII_X1; end
            5'd2:  begin rd_name_ascii = `DBG_REG_NAME_ASCII_X2; end
            5'd3:  begin rd_name_ascii = `DBG_REG_NAME_ASCII_X3; end
            5'd4:  begin rd_name_ascii = `DBG_REG_NAME_ASCII_X4; end
            5'd5:  begin rd_name_ascii = `DBG_REG_NAME_ASCII_X5; end
            5'd6:  begin rd_name_ascii = `DBG_REG_NAME_ASCII_X6; end
            5'd7:  begin rd_name_ascii = `DBG_REG_NAME_ASCII_X7; end
            5'd8:  begin rd_name_ascii = `DBG_REG_NAME_ASCII_X8; end
            5'd9:  begin rd_name_ascii = `DBG_REG_NAME_ASCII_X9; end
            5'd10: begin rd_name_ascii = `DBG_REG_NAME_ASCII_X10; end
            5'd11: begin rd_name_ascii = `DBG_REG_NAME_ASCII_X11; end
            5'd12: begin rd_name_ascii = `DBG_REG_NAME_ASCII_X12; end
            5'd13: begin rd_name_ascii = `DBG_REG_NAME_ASCII_X13; end
            5'd14: begin rd_name_ascii = `DBG_REG_NAME_ASCII_X14; end
            5'd15: begin rd_name_ascii = `DBG_REG_NAME_ASCII_X15; end
            5'd16: begin rd_name_ascii = `DBG_REG_NAME_ASCII_X16; end
            5'd17: begin rd_name_ascii = `DBG_REG_NAME_ASCII_X17; end
            5'd18: begin rd_name_ascii = `DBG_REG_NAME_ASCII_X18; end
            5'd19: begin rd_name_ascii = `DBG_REG_NAME_ASCII_X19; end
            5'd20: begin rd_name_ascii = `DBG_REG_NAME_ASCII_X20; end
            5'd21: begin rd_name_ascii = `DBG_REG_NAME_ASCII_X21; end
            5'd22: begin rd_name_ascii = `DBG_REG_NAME_ASCII_X22; end
            5'd23: begin rd_name_ascii = `DBG_REG_NAME_ASCII_X23; end
            5'd24: begin rd_name_ascii = `DBG_REG_NAME_ASCII_X24; end
            5'd25: begin rd_name_ascii = `DBG_REG_NAME_ASCII_X25; end
            5'd26: begin rd_name_ascii = `DBG_REG_NAME_ASCII_X26; end
            5'd27: begin rd_name_ascii = `DBG_REG_NAME_ASCII_X27; end
            5'd28: begin rd_name_ascii = `DBG_REG_NAME_ASCII_X28; end
            5'd29: begin rd_name_ascii = `DBG_REG_NAME_ASCII_X29; end
            5'd30: begin rd_name_ascii = `DBG_REG_NAME_ASCII_X30; end
            5'd31: begin rd_name_ascii = `DBG_REG_NAME_ASCII_X31; end
        endcase
    end

endmodule

//                       _oo0oo_
//                      o8888888o
//                      88" . "88
//                      (| -_- |)
//                      0\  =  /0
//                    ___/`---'\___
//                  .' \\|     |// '.
//                 / \\|||  :  |||// \
//                / _||||| -:- |||||- \
//               |   | \\\  -  /// |   |
//               | \_|  ''\---/''  |_/ |
//               \  .-\__  '-'  ___/-. /
//             ___'. .'  /--.--\  `. .'___
//          ."" '<  `.___\_<|>_/___.' >' "".
//         | | :  `- \`.;`\ _ /`;.`/ - ` : | |
//         \  \ `_.   \_ __\ /__ _/   .-` /  /
//     =====`-.____`.___ \_____/___.-`___.-'=====
//                       `=---='
