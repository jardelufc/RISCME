module imem(input  logic [31:0] a, output logic [15:0] rd);
  reg [15:0] ROM[255:0];
  initial begin
  //
  
     ROM[0]='hE004;
ROM[1]='hE003;
ROM[2]='h0031;
ROM[3]='h0000;
ROM[4]='h0800;
ROM[5]='h0000;
ROM[6]='h1BF8;
ROM[7]='h1BF9;
ROM[8]='h1BFB;
ROM[9]='h1BFC;
ROM[10]='h3355;
ROM[11]='h34AA;
ROM[12]='h4323;
ROM[13]='hD0F7;
ROM[14]='h6843;
ROM[15]='h6843;
ROM[16]='h4798;
ROM[17]='hE7F3;
ROM[18]='hBF00;
ROM[19]='hBF00;
ROM[20]='hBF00;
ROM[21]='hBF00;
ROM[22]='hBF00;
ROM[23]='hBF00;
ROM[24]='h1BF8;
ROM[25]='h6881;
ROM[26]='h6881;
ROM[27]='h1BFA;
ROM[28]='h32FF;
ROM[29]='h600A;
ROM[30]='h600A;
ROM[31]='h600A;
ROM[32]='h4770;
ROM[33]='h0000;
  end
  assign rd = ROM[a[31:1]];
endmodule