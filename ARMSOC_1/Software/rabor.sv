  end
  //    $readmemh("rom_contents.dat",rom);
  
  assign HRDATA = ROM[{2'b0,HADDR[31:2]}];
endmodule