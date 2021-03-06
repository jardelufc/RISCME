module ahb_rom(input  logic        HCLK,
               input  logic        HSEL,
               input  logic [31:0] HADDR,
               output logic [31:0] HRDATA);

  logic [31:0] ROM[255:0]; // 64KB ROM organized as 16K x 32 bits 
  initial begin   
  
  // 
  
    ROM[0]='hE005E006;
ROM[1]='h00000043;
ROM[2]='h00000800;
ROM[3]='h00000804;
ROM[4]='h1BFF1BF8;
ROM[5]='h37FF37FF;
ROM[6]='h32FF37FF;
ROM[7]='h68C168C1;
ROM[8]='h600A600A;
ROM[9]='h68816881;
ROM[10]='h68466846;
ROM[11]='h32551BFA;
ROM[12]='h600A600A;
ROM[13]='h1BFA47B0;
ROM[14]='h600A32AA;
ROM[15]='h47B0600A;
ROM[16]='h1BFDE7F4;
ROM[17]='h1BED3D01;
ROM[18]='h4770D7FD;
  end
  //    $readmemh("rom_contents.dat",rom);
  
  assign HRDATA = ROM[{2'b0,HADDR[31:2]}];
endmodule