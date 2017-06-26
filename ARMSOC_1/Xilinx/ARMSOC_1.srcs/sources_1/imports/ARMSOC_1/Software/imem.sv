module imem(input  logic [31:0] a, output logic [15:0] rd);
  reg [15:0] ROM[255:0];
  initial begin
ROM[0]='h1BF8;
ROM[1]='h1BF9;
ROM[2]='h6801;
ROM[3]='h30FF;
ROM[4]='h6008;
ROM[5]='h6008;
ROM[6]='hE7F8;
ROM[7]='h0000;
  end
  assign rd = ROM[a[31:1]];
endmodule