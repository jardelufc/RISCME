// arm_single.v
// David_Harris@hmc.edu and Sarah_Harris@hmc.edu 25 June 2013
// Single-cycle implementation of a subset of ARMv4
// 
// run 210
// Expect simulator to print "Simulation succeeded"
// when the value 7 is written to address 100 (0x64)

// 16 32-bit registers
// Data-processing instructions
//   ADD, SUB, AND, ORR
//   INSTR<cond><S> rd, rn, #immediate
//   INSTR<cond><S> rd, rn, rm
//    rd <- rn INSTR rm	      if (S) Update Status Flags
//    rd <- rn INSTR immediate	if (S) Update Status Flags
//   Instr[31:28] = cond
//   Instr[27:26] = op = 00
//   Instr[25:20] = funct
//                  [25]:    1 for immediate, 0 for register
//                  [24:21]: 0100 (ADD) / 0010 (SUB) /
//                           0000 (AND) / 1100 (ORR)
//                  [20]:    S (1 = update CPSR status Flags)
//   Instr[19:16] = rn
//   Instr[15:12] = rd
//   Instr[11:8]  = 0000
//   Instr[7:0]   = imm8      (for #immediate type) / 
//                  {0000,rm} (for register type)
//   
// Load/Store instructions
//   LDR, STR
//   INSTR rd, [rn, #offset]
//    LDR: rd <- Mem[rn+offset]
//    STR: Mem[rn+offset] <- rd
//   Instr[31:28] = cond
//   Instr[27:26] = op = 01 
//   Instr[25:20] = funct
//                  [25]:    0 (A)
//                  [24:21]: 1100 (P/U/B/W)
//                  [20]:    L (1 for LDR, 0 for STR)
//   Instr[19:16] = rn
//   Instr[15:12] = rd
//   Instr[11:0]  = imm12 (zero extended)
//
// Branch instruction (PC <= PC + offset, PC holds 8 bytes past Branch Instr)
//   B
//   B target
//    PC <- PC + 8 + imm24 << 2
//   Instr[31:28] = cond
//   Instr[27:25] = op = 10
//   Instr[25:24] = funct
//                  [25]: 1 (Branch)
//                  [24]: 0 (link)
//   Instr[23:0]  = imm24 (sign extend, shift left 2)
//   Note: no Branch delay slot on ARM
//
// Other:
//   R15 reads as PC+8
//   Conditional Encoding
//    cond  Meaning                       Flag
//    0000  Equal                         Z = 1
//    0001  Not Equal                     Z = 0
//    0010  Carry Set                     C = 1
//    0011  Carry Clear                   C = 0
//    0100  Minus                         N = 1
//    0101  Plus                          N = 0
//    0110  Overflow                      V = 1
//    0111  No Overflow                   V = 0
//    1000  Unsigned Higher               C = 1 & Z = 0
//    1001  Unsigned Lower/Same           C = 0 | Z = 1
//    1010  Signed greater/equal          N = V
//    1011  Signed less                   N != V
//    1100  Signed greater                N = V & Z = 0
//    1101  Signed less/equal             N != V | Z = 1
//    1110  Always                        any

module testbench();

  logic        clk;
  logic        reset;

  logic [31:0] WriteData, DataAdr;
  logic        MemWrite;
  wire logic     [31:0] pins;
  // instantiate device to be tested
  top dut(clk, reset, pins);
  
  // initialize test
  initial
    begin
      reset <= 1; # 22; reset <= 0;
    end

  // generate clock to sequence tests
  always
    begin
      clk <= 1; # 5; clk <= 0; # 5;
    end

  // check results
 /* always @(negedge clk)
    begin
      if(MemWrite) begin
        if(DataAdr === 100 & WriteData === 7) begin
          $display("Simulation succeeded");
          $stop;
        end else if (DataAdr !== 96) begin
          $display("Simulation failed");
          $stop;
        end
      end
    end*/
endmodule

module top(input  logic        clk, reset, 
           inout  tri   [7:0] pins
);

  logic [31:0] PC, ReadData;
  logic [15:0] Instr;  
  logic hreset,hclk;
  logic [31:0] WriteData, DataAdr;
  logic        MemWrite;  
  assign hreset=!reset;
    assign hclk=clk;

  // instantiate processor and memories
  arm arm(clk, reset, PC, Instr, MemWrite, DataAdr, 
          WriteData, ReadData);
  imem imem(PC, Instr);
  //dmem dmem(clk, MemWrite, DataAdr, WriteData, ReadData);
  ahb_lite dmem(hclk,hreset , DataAdr, MemWrite,WriteData, ReadData,pins );

endmodule

module arm(input  logic        clk, reset,
           output logic [31:0] PC,
           input  logic [15:0] Instr,
           output logic        MemWrite,
           output logic [31:0] ALUResult, WriteData,
           input  logic [31:0] ReadData);

  logic [3:0] ALUFlags;
  logic       RegWrite, 
              ALUSrc, MemtoReg, PCSrc;
  logic [2:0] RegSrc, ALUControl;
  logic [2:0] ImmSrc;


  controller c(clk, reset, Instr[15:6], ALUFlags, 
               RegSrc, RegWrite, ImmSrc, 
               ALUSrc, ALUControl,
               MemWrite, MemtoReg, PCSrc);
  datapath dp(clk, reset, 
              RegSrc, RegWrite, ImmSrc,
              ALUSrc, ALUControl,
              MemtoReg, PCSrc,
              ALUFlags, PC, Instr,
              ALUResult, WriteData, ReadData);
endmodule

module controller(input  logic         clk, reset,
	              input  logic [27:6] Instr,
                  input  logic [3:0]   ALUFlags,
                  output logic [2:0]   RegSrc,
                  output logic         RegWrite,
                  output logic [2:0]   ImmSrc,
                  output logic         ALUSrc, 
                  output logic [1:0]   ALUControl,
                  output logic         MemWrite, MemtoReg,
                  output logic         PCSrc);

  logic [1:0] FlagW;
  logic       PCS, RegW, MemW;
  
  decode dec(Instr[27:26], Instr[25:20], Instr[15:12],
             FlagW, PCS, RegW, MemW,
             MemtoReg, ALUSrc, ImmSrc, RegSrc, ALUControl);
  condlogic cl(clk, reset, Instr[11:8], ALUFlags,
               FlagW, PCS, RegW, MemW,
               PCSrc, RegWrite, MemWrite);
endmodule

module decode(input  logic [1:0] Op,
              input  logic [5:0] Funct,
              input  logic [3:0] Rd,
              output logic [1:0] FlagW,
              output logic       PCS, RegW, MemW,
              output logic       MemtoReg, ALUSrc,
              output logic [2:0] ImmSrc, RegSrc, ALUControl);

  logic [9:0] controls;
  logic       Branch, ALUOp;

  // Main Decoder
  
  always_comb
  	casex(Op)
  	                        // Data processing immediate
  	  2'b00: if (Funct[5])  controls = 10'b0000101001; 
  	                        // Data processing register
  	         else           controls = 10'b0000001001; 
  	                        // LDR
  	  2'b01: if (Funct[0])  controls = 10'b0001111000; 
  	                        // STR
  	         else           controls = 10'b1001110100; 
  	                        // B
  	  2'b10:                controls = 10'b0110100010; 
  	                        // Unimplemented
  	  default:              controls = 10'bx;          
  	endcase

  assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, 
          RegW, MemW, Branch, ALUOp} = controls; 
          
  // ALU Decoder             
  always_comb
    if (ALUOp) begin                 // which DP Instr?
      case(Funct[4:1]) 
  	    4'b0100: ALUControl = 2'b00; // ADD
  	    4'b0010: ALUControl = 2'b01; // SUB
        4'b0000: ALUControl = 2'b10; // AND
  	    4'b1100: ALUControl = 2'b11; // ORR
  	    default: ALUControl = 2'bx;  // unimplemented
      endcase
      // update flags if S bit is set 
	// (C & V only updated for arith instructions)
      FlagW[1]      = Funct[0]; // FlagW[1] = S-bit
	// FlagW[0] = S-bit & (ADD | SUB)
      FlagW[0]      = Funct[0] & 
        (ALUControl == 2'b00 | ALUControl == 2'b01); 
    end else begin
      ALUControl = 2'b00; // add for non-DP instructions
      FlagW      = 2'b00; // don't update Flags
    end
              
  // PC Logic
  assign PCS  = ((Rd == 4'b1111) & RegW) | Branch; 
endmodule

module condlogic(input  logic       clk, reset,
                 input  logic [3:0] Cond,
                 input  logic [3:0] ALUFlags,
                 input  logic [1:0] FlagW,
                 input  logic       PCS, RegW, MemW,
                 output logic       PCSrc, RegWrite, MemWrite);
                 
  logic [1:0] FlagWrite;
  logic [3:0] Flags;
  logic       CondEx;

  flopenr #(2)flagreg1(clk, reset, FlagWrite[1], 
                       ALUFlags[3:2], Flags[3:2]);
  flopenr #(2)flagreg0(clk, reset, FlagWrite[0], 
                       ALUFlags[1:0], Flags[1:0]);

  // write controls are conditional
  condcheck cc(Cond, Flags, CondEx);
  assign FlagWrite = FlagW & {2{CondEx}};
  assign RegWrite  = RegW  & CondEx;
  assign MemWrite  = MemW  & CondEx;
  assign PCSrc     = PCS   & CondEx;
endmodule    

module condcheck(input  logic [3:0] Cond,
                 input  logic [3:0] Flags,
                 output logic       CondEx);
  
  logic neg, zero, carry, overflow, ge;
  
  assign {neg, zero, carry, overflow} = Flags;
  assign ge = (neg == overflow);
                  
  always_comb
    case(Cond)
      4'b0000: CondEx = zero;             // EQ
      4'b0001: CondEx = ~zero;            // NE
      4'b0010: CondEx = carry;            // CS
      4'b0011: CondEx = ~carry;           // CC
      4'b0100: CondEx = neg;              // MI
      4'b0101: CondEx = ~neg;             // PL
      4'b0110: CondEx = overflow;         // VS
      4'b0111: CondEx = ~overflow;        // VC
      4'b1000: CondEx = carry & ~zero;    // HI
      4'b1001: CondEx = ~(carry & ~zero); // LS
      4'b1010: CondEx = ge;               // GE
      4'b1011: CondEx = ~ge;              // LT
      4'b1100: CondEx = ~zero & ge;       // GT
      4'b1101: CondEx = ~(~zero & ge);    // LE
      4'b1110: CondEx = 1'b1;             // Always
      default: CondEx = 1'bx;             // undefined
    endcase
endmodule

module datapath(input  logic        clk, reset,
                input  logic [2:0]  RegSrc,
                input  logic        RegWrite,
                input  logic [1:0]  ImmSrc,
                input  logic        ALUSrc,
                input  logic [1:0]  ALUControl,
                input  logic        MemtoReg,
                input  logic        PCSrc,
                output logic [3:0]  ALUFlags,
                output logic [31:0] PC,
                input  logic [15:0] Instr,
                output logic [31:0] ALUResult, WriteData,
                input  logic [31:0] ReadData);

  logic [31:0] PCNext, PCPlus2, PCPlus4;
  logic [31:0] ExtImm, SrcA, SrcB, Result;
  logic [3:0]  RA1, RA2, RA3;

  // next PC logic
  mux2 #(32)  pcmux(PCPlus2, Result, PCSrc, PCNext);
  flopr #(32) pcreg(clk, reset, PCNext, PC);
  adder #(32) pcadd1(PC, 32'b10, PCPlus2);
  adder #(32) pcadd2(PCPlus2, 32'b10, PCPlus4);

  // register file logic
  mux2 #(4)   ra1mux(Instr[5:3], 4'b1111, RegSrc[0], RA1);
  mux2 #(4)   ra2mux(Instr[2:0], Instr[8:6], RegSrc[1], RA2);

  mux2 #(4)   ra3mux(Instr[2:0], Instr[10:8], RegSrc[2], RA3);


  regfile     rf(clk, RegWrite, RA1, RA2,
                 RA3, Result, PCPlus4, 
                 SrcA, WriteData); 
  mux2 #(32)  resmux(ALUResult, ReadData, MemtoReg, Result);
  extend      ext(Instr[10:0], ImmSrc, ExtImm);

  // ALU logic
  mux2 #(32)  srcbmux(WriteData, ExtImm, ALUSrc, SrcB);
  alu         alu(SrcA, SrcB, ALUControl, 
                  ALUResult, ALUFlags);
endmodule

module regfile(input  logic        clk, 
               input  logic        we3, 
               input  logic [3:0]  ra1, ra2, wa3, 
               input  logic [31:0] wd3, r15,
               output logic [31:0] rd1, rd2);

  logic [31:0] rf[14:0];

  // three ported register file
  // read two ports combinationally
  // write third port on rising edge of clock
  // register 15 reads PC+8 instead

  always_ff @(posedge clk)
    if (we3) rf[wa3] <= wd3;	

  assign rd1 = (ra1 == 4'b1111) ? r15 : rf[ra1];
  assign rd2 = (ra2 == 4'b1111) ? r15 : rf[ra2];
endmodule

module extend(input  logic [10:0] Instr,
              input  logic [2:0]  ImmSrc,
              output logic [31:0] ExtImm);
 
  always_comb
    case(ImmSrc) 
 
               // 8-bit unsigned immediate 
        3'b000:   ExtImm = {24'b0, Instr[7:0]}; 
              // // 8-bit unsigned immediate 
        3'b001:   ExtImm = {23'b0, Instr[7:0],1'b0}; 
              // // 8-bit unsigned immediateh 
        3'b010:   ExtImm = {22'b0, Instr[7:0],2'b00}; 
              // //11-bit unsigned immediateh 
        3'b011:   ExtImm = {20'b0, Instr[10:0], 1'b0}; 
              // //5-bit unsigned immediateh 
        3'b100:   ExtImm = {25'b0, Instr[10:6],2'b00}; 
              // //3-bit unsigned immediateh 
        3'b101:   ExtImm = {29'b0, Instr[8:6]}; 
        default: ExtImm = 32'bx; // undefined

/* 
               // 3-bit unsigned immediate
      3'b000:   ExtImm = {29'b0, Instr[8:6]};  
               // 5-bit unsigned immediate 
      3'b010:   ExtImm = {27'b0, Instr[10:6]}; 
               // 8-bit two's complement shifted branch 
      3'b100:   ExtImm = {24'b0, Instr[7:0]}; 
               // 11-bit imm branch encoding t2 
      3'b110:   ExtImm = {{20{Instr[10]}}, Instr[10:0], 2'b00}; 
*/
//      default: ExtImm = 32'bx; // undefined
    endcase             
endmodule

module adder #(parameter WIDTH=8)
              (input  logic [WIDTH-1:0] a, b,
               output logic [WIDTH-1:0] y);
             
  assign y = a + b;
endmodule

module flopenr #(parameter WIDTH = 8)
                (input  logic             clk, reset, en,
                 input  logic [WIDTH-1:0] d, 
                 output logic [WIDTH-1:0] q);

  always_ff @(posedge clk, posedge reset)
    if (reset)   q <= 0;
    else if (en) q <= d;
endmodule

module flopr #(parameter WIDTH = 8)
              (input  logic             clk, reset,
               input  logic [WIDTH-1:0] d, 
               output logic [WIDTH-1:0] q);

  always_ff @(posedge clk, posedge reset)
    if (reset) q <= 0;
    else       q <= d;
endmodule

module mux2 #(parameter WIDTH = 8)
             (input  logic [WIDTH-1:0] d0, d1, 
              input  logic             s, 
              output logic [WIDTH-1:0] y);

  assign y = s ? d1 : d0; 
endmodule
module alu(input  logic [31:0] a, b,
           input  logic [1:0]  ALUControl,
           output logic [31:0] Result,
           output logic [3:0]  ALUFlags);

  logic        neg, zero, carry, overflow;
  logic [31:0] condinvb;
  logic [32:0] sum;

  assign condinvb = ALUControl[0] ? ~b : b;
  assign sum = a + condinvb + ALUControl[0];

  always_comb
    casex (ALUControl[1:0])
      2'b0?: Result = sum;
      2'b10: Result = a & b;
      2'b11: Result = a | b;
    endcase

  assign neg      = Result[31];
  assign zero     = (Result == 32'b0);
  assign carry    = (ALUControl[1] == 1'b0) & sum[32];
  assign overflow = (ALUControl[1] == 1'b0) & 
                    ~(a[31] ^ b[31] ^ ALUControl[0]) & 
                    (a[31] ^ sum[31]); 
  assign ALUFlags    = {neg, zero, carry, overflow};
endmodule


module ahb_lite(input  logic        HCLK,
                input  logic        HRESETn,
                input  logic [31:0] HADDR,
                input  logic        HWRITE,
                input  logic [31:0] HWDATA,
                output logic [31:0] HRDATA,
                inout  tri   [31:0] pins);
              
  logic [3:0] HSEL;
  logic [31:0] HRDATA0, HRDATA1, HRDATA2, HRDATA3;
  //logic [31:0] pins_dir, pins_out, pins_in;
  logic [31:0] HADDRDEL;
  logic        HWRITEDEL;

  // Delay address and write signals to align in time with data
  flop #(32)  adrreg(HCLK, HADDR, HADDRDEL);
  flop #(1)   writereg(HCLK, HWRITE, HWRITEDEL);
  
  // Memory map decoding
  ahb_decoder dec(HADDRDEL, HSEL);
  ahb_mux     mux(HSEL, HRDATA0, HRDATA1, HRDATA2, HRDATA3, HRDATA);
  
  // Memory and peripherals
  ahb_rom     rom  (HCLK, HSEL[0], HADDRDEL[7:0], HRDATA0);
  ahb_ram     ram  (HCLK, HSEL[1], HADDRDEL[7:0], HWRITE, HWDATA, HRDATA1);
  ahb_gpio    gpio (HCLK, HRESETn, HSEL[2], HADDRDEL[2], HWRITE, HWDATA, HRDATA2, pins);
  ahb_timer   timer(HCLK, HRESETn, HSEL[3], HADDRDEL[4:2], HWRITE, HWDATA, HRDATA3);
  
endmodule

module ahb_decoder(input  logic [31:0] HADDR,
                   output logic [3:0]  HSEL);
                   
  // Decode based on most significant bits of the address
  /*assign HSEL[0] = (HADDR[31:16] == 16'h0000); // 64KB ROM  at 0x00000000 - 0x0000FFFF
  assign HSEL[1] = (HADDR[31:17] == 15'h0001); // 128KB RAM at 0x00020000 - 0x003FFFFF
  assign HSEL[2] = (HADDR[31:4]  == 28'h2020000); // GPIO   at 0x20200000 - 0x20200007
  assign HSEL[3] = (HADDR[31:8]  == 24'h200030);  // Timer  at 0x20003000 - 0x2000301B*/
  
  assign HSEL[0] = (HADDR[11:10] == 2'b00); // 1KB ROM  at 0x00000000 - 0x000003FF
  assign HSEL[1] = (HADDR[11:10] == 2'b01);  // 1KB RAM at 0x00000400 - 0x000007FF
  assign HSEL[2] = (HADDR[11:10]  == 2'b10); // GPIO   at 0x00000800 - 0x00000BFF
  assign HSEL[3] = (HADDR[11:10]  == 2'b11);  // Timer  at 0x00000C00 - 0x00000FFF
  
endmodule

module ahb_mux(input  logic [3:0]  HSEL,
               input  logic [31:0] HRDATA0, HRDATA1, HRDATA2, HRDATA3,
               output logic [31:0] HRDATA);
               
  always_comb
    casez(HSEL)
      4'b???1: HRDATA <= HRDATA0;
      4'b??10: HRDATA <= HRDATA1;
      4'b?100: HRDATA <= HRDATA2;
      4'b1000: HRDATA <= HRDATA3;
    endcase
endmodule

module ahb_ram(input  logic        HCLK,
               input  logic        HSEL,
               input  logic [7:0] HADDR,
               input  logic        HWRITE,
               input  logic [31:0] HWDATA,
               output logic [31:0] HRDATA);

  logic [31:0] ram[255:0]; // 128KB RAM organized as 32K x 32 bits 
  
  assign HRDATA = ram[HADDR]; 
  always_ff @(posedge HCLK)
    if (HWRITE & HSEL) ram[HADDR] <= HWDATA;
endmodule

module ahb_rom(input  logic        HCLK,
               input  logic        HSEL,
               input  logic [7:0] HADDR,
               output logic [31:0] HRDATA);

  logic [31:0] rom[255:0]; // 64KB ROM organized as 16K x 32 bits 
  
  //initial
  //    $readmemh("rom_contents.dat",rom);
  
  assign HRDATA = rom[HADDR];
endmodule

module ahb_gpio(input  logic        HCLK,
                input  logic        HRESETn,
                input  logic        HSEL,
                input  logic        HADDR,
                input  logic        HWRITE,
                input  logic [31:0] HWDATA,
                output logic [31:0] HRDATA,
                inout  tri   [31:0] pins);

  reg [31:0] gpio[1:0];     // GPIO registers

  // write selected register
  always_ff @(posedge HCLK or negedge HRESETn)
    if (~HRESETn) begin
      gpio[0] <= 32'b0;  // GPIO_PORT
      gpio[1] <= 32'h55555555;  // GPIO_DIR
    end else if (HWRITE & HSEL)
      gpio[HADDR] <= HWDATA;
    
  // read selected register
  assign HRDATA = HADDR ? gpio[1] : pins;
  
  // No graceful way to control tristates on a per-bit basis in SystemVerilog
  genvar i;
  generate
    for (i=0; i<32; i=i+1) begin: pinloop
      assign pins[i] = gpio[1][i] ? gpio[0][i] : 1'bz;
    end
  endgenerate
endmodule

module ahb_timer(input  logic        HCLK,
                 input  logic        HRESETn,
                 input  logic        HSEL,
                 input  logic [4:2]  HADDR,
                 input  logic        HWRITE,
                 input  logic [31:0] HWDATA,
                 output logic [31:0] HRDATA);

  logic [31:0] timers[6:0];     // timer registers
  logic [31:0] chi, clo;        // next counter value
  logic [3:0]  match, clr;      // determine if counter matches compare reg

  // write selected register and update tiers and match
  always_ff @(posedge HCLK or negedge HRESETn)
    if (~HRESETn) begin
      timers[0] <= 32'b0;  // TIMER_CS
      timers[1] <= 32'b0;  // TIMER_CLO
      timers[2] <= 32'b0;  // TIMER_CHI
      timers[3] <= 32'b0;  // TIMER_C0
      timers[4] <= 32'b0;  // TIMER_C1
      timers[5] <= 32'b0;  // TIMER_C2
      timers[6] <= 32'b0;  // TIMER_C3
    end else begin
      timers[0] <= {28'b0, match};
      timers[1] <= (HWRITE & HSEL & HADDR == 3'b001) ? HWDATA : clo;
      timers[2] <= (HWRITE & HSEL & HADDR == 3'b010) ? HWDATA : chi;
      if (HWRITE & HSEL & HADDR == 3'b011) timers[3] <= HWDATA;
      if (HWRITE & HSEL & HADDR == 3'b100) timers[4] <= HWDATA;
      if (HWRITE & HSEL & HADDR == 3'b101) timers[5] <= HWDATA;
      if (HWRITE & HSEL & HADDR == 3'b110) timers[6] <= HWDATA;
    end    
    
  // read selected register
  assign HRDATA = timers[HADDR];
  
  // increment 64-bit counter as pair of TIMER_CHI, TIMER_CLO
  assign {chi, clo} = {timers[2], timers[1]} + 1;

  // generate matches: set match bit when counter matches compare register
  //   clear bit when a 1 is written to that position of the match register
  assign clr = {4{HWRITE & HSEL & HADDR == 3'b000}} & HWDATA[3:0];
  assign match[0] = ~clr[0] & (timers[0][0] | (timers[1] == timers[3]));
  assign match[1] = ~clr[1] & (timers[0][1] | (timers[1] == timers[4]));
  assign match[2] = ~clr[2] & (timers[0][2] | (timers[1] == timers[5]));
  assign match[3] = ~clr[3] & (timers[0][3] | (timers[1] == timers[6]));
endmodule

module flop #(parameter WIDTH = 8)
              (input  logic             clk,
               input  logic [WIDTH-1:0] d, 
               output logic [WIDTH-1:0] q);

  always_ff @(posedge clk)
    q <= d;
endmodule
