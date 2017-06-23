


module AHBLITE_SYS(
	//CLOCKS & RESET
	input		wire				CLK,
	input		wire				RESETn, 
	
	//TO BOARD LEDs
	output 	wire	[7:0] 	LED,
	output 	wire	[7:0] 	deLED	

);

//AHB-LITE SIGNALS 
//Gloal Signals
wire 				HCLK;
reg 				HRESETn;
//Address, Control & Write Data Signals
wire [31:0]		HADDR;
wire [31:0]		HWDATA;
wire 				HWRITE;
wire [1:0] 		HTRANS;
wire [2:0] 		HBURST;
wire 				HMASTLOCK;
wire [3:0] 		HPROT;
wire [2:0] 		HSIZE;
//Transfer Response & Read Data Signals
wire [31:0] 	HRDATA;
wire 				HRESP;
wire 				HREADY;

//SELECT SIGNALS
wire [3:0] 		MUX_SEL;

wire 				HSEL_MEM;
wire 				HSEL_LED;

//SLAVE READ DATA
wire [31:0] 	HRDATA_MEM;
wire [31:0] 	HRDATA_LED;

//SLAVE HREADYOUT
wire 				HREADYOUT_MEM;
wire 				HREADYOUT_LED;

//CM0-DS Sideband signals
wire 				LOCKUP;
wire 				TXEV;
wire 				SLEEPING;
wire [15:0]		IRQ;


reg [3:0] count;

//reg HRESETn;
reg enable;

  
//SYSTEM GENERATES NO ERROR RESPONSE
assign 			HRESP = 1'b0;

assign 			IRQ = {16'b0000_0000_0000_0000};
assign 			LED[7] = LOCKUP;
	
ClockDiv  instance_name
  (
  // Clock out ports  
  .clk_out1(HCLK),
 // Clock in ports
  .clk_in1(CLK)
  );



always @ (posedge HCLK)

if (RESETn == 1'b1) begin

    HRESETn <= 1'b0;
     
end else if(RESETn == 1'b0) begin

    HRESETn <= 1'b1;

end

  top dut(HCLK, RESETn, LED);

endmodule
