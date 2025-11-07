`include "async_fifo.v"
module tb;
parameter WIDTH=8;
parameter FIFO_SIZE=16;
parameter PTR_WIDTH=$clog2(FIFO_SIZE);

reg wr_clk,rd_clk,res,wr_en,rd_en;
reg [WIDTH-1:0]wdata;
wire[WIDTH-1:0]rdata;
wire full,overflow,empty,underflow;
async dut(.wr_clk(wr_clk),.rd_clk(rd_clk),.res(res),.wr_en(wr_en),.rd_en(rd_en),.wdata(wdata),.rdata(rdata),.full(full),.empty(empty),.overflow(overflow),.underflow(underflow));
integer i;
always #10 wr_clk=~wr_clk;
always #5 rd_clk=~rd_clk;
initial begin
	wr_clk=0;
	rd_clk=0;
	res=1;
	wr_en=0;
	rd_en=0;
	wdata=0;
	repeat(2) @(posedge wr_clk);
	res=0;
	writes(FIFO_SIZE);
	reads(FIFO_SIZE);
	#100;
	$finish;
end
task writes(input integer num_writes); begin
	for(i=0;i<num_writes;i=i+1) begin
		@(posedge wr_clk);
		wr_en=1;
		wdata=$random;
	end
	@(posedge wr_clk)
	wr_en=0;
	wdata=0;
end
endtask
task reads(input integer num_reads); begin
	for(i=0;i<num_reads;i=i+1) begin
		@(posedge rd_clk)
		rd_en=1;
			end
	@(posedge rd_clk)
	wr_en=0;
end
endtask
endmodule
