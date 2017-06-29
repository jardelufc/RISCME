module ahb_rom(input  logic        HCLK,
               input  logic        HSEL,
               input  logic [31:0] HADDR,
               output logic [31:0] HRDATA);

  logic [31:0] ROM[255:0]; // 64KB ROM organized as 16K x 32 bits 
  initial begin   
  
  // 
  
    