module imem(input  logic [31:0] a, output logic [15:0] rd);
  reg [15:0] ROM[255:0];
  initial begin
ROM[0]='hE004;
ROM[1]='hE003;
ROM[2]='h0029;
ROM[3]='h0000;
ROM[4]='h0800;
ROM[5]='h0000;
ROM[6]='h1BF8;
ROM[7]='h1BF9;
ROM[8]='h6843;
ROM[9]='h6843;
ROM[10]='h4798;
ROM[11]='hE7F9;
ROM[12]='hBF00;
ROM[13]='hBF00;
ROM[14]='hBF00;
ROM[15]='hBF00;
ROM[16]='hBF00;
ROM[17]='hBF00;
ROM[18]='h1BF8;
ROM[19]='h68C1;
ROM[20]='h68C1;
ROM[21]='h1BFA;
ROM[22]='h32FF;
ROM[23]='h600A;
ROM[24]='h600A;
ROM[25]='h4770;
  end
  assign rd = ROM[a[31:1]];
endmodule