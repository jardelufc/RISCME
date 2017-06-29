module ahb_rom(input  logic        HCLK,
               input  logic        HSEL,
               input  logic [31:0] HADDR,
               output logic [31:0] HRDATA);

  logic [31:0] ROM[255:0]; // 64KB ROM organized as 16K x 32 bits 
  initial begin   
  
  // 
  
    ROM[0]='hE003E004;
ROM[1]='h00000031;
ROM[2]='h00000800;
ROM[3]='h1BF91BF8;
ROM[4]='h1BFC1BFB;
ROM[5]='h34AA3355;
ROM[6]='hD0F74323;
ROM[7]='h68436843;
ROM[8]='hE7F34798;
ROM[9]='hBF00BF00;
ROM[10]='hBF00BF00;
ROM[11]='hBF00BF00;
ROM[12]='h68811BF8;
ROM[13]='h1BFA6881;
ROM[14]='h600A32FF;
ROM[15]='h600A600A;
ROM[16]='h00004770;
  end
  //    $readmemh("rom_contents.dat",rom);
  
  assign HRDATA = ROM[{2'b0,HADDR[31:2]}];
endmodule