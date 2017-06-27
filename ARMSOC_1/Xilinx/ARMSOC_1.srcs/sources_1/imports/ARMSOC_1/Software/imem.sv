module imem(input  logic [31:0] a, output logic [15:0] rd);
  reg [15:0] ROM[255:0];
  initial begin
ROM[0]='h1BF8;
ROM[1]='h1BF9;
ROM[2]='h3000;
ROM[3]='h6801;
ROM[4]='h1BF9;
ROM[5]='h30FF;
ROM[6]='h6008;
ROM[7]='h6008;
ROM[8]='h1BF8;
ROM[9]='h4780;
ROM[10]='h0001;
ROM[11]='h0000;
ROM[12]='h0014;
ROM[13]='h0000;
  end
  assign rd = ROM[a[31:1]];
endmodule