
module memory(clk,rst,wr_rd,addr,w_data,r_data,valid,ready);
parameter width=8;
parameter depth=32;
parameter addr_width=$clog2(depth);

input clk,rst,wr_rd,valid;
input [addr_width-1:0]addr;
input [width-1:0]w_data;
output reg [width-1:0]r_data;
output reg ready;
integer i;
reg [width-1:0] mem [depth-1:0];

always@(posedge clk) begin
if(rst==1) begin
	ready=0;
	r_data=0;
	for(i=0;i<depth;i=i+1)
	mem[i]=0;
end
else begin
	if(valid==1) begin
		ready=1;
			if(wr_rd==1) mem[addr]=w_data;
			else r_data=mem[addr];
	end
	else ready=0;
end
end
endmodule

//writing to all locations and reading-need to change only in tb.
//testcases in memory

