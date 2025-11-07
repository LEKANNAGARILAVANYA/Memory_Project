//`include "mem.v"
//module tb;
//parameter width=8;
//parameter depth=32;
//parameter addr_width=$clog2(depth);
//reg clk,rst,wr_rd,valid;
//reg [addr_width-1:0]addr;
//reg [width-1:0]w_data;
//wire [width-1:0]r_data;
//wire ready;
//
//memory dut(.clk(clk),.rst(rst),.wr_rd(wr_rd),.addr(addr),.w_data(w_data),.r_data(r_data),.valid(valid),.ready(ready));
//integer i;
//always #5 clk=~clk;
//initial begin
//clk=0;
//rst=1;
//wr_rd=0;
//addr=0;
//w_data=0;
//valid=0;
//repeat (2) @(posedge clk)
//rst=0;
//for(i=0;i<depth;i=i+1) begin
//@(posedge clk)
//wr_rd=1;
//addr=i;
//w_data=$random;
//valid=1;
//wait(ready==1);
//end
//@(posedge clk)
//valid=0;
//wr_rd=0;
//w_data=0;
//addr=0;
//
//for(i=0;i<depth;i=i+1) begin
//@(posedge clk)
//wr_rd=0;
//addr=i;
//valid=1;
//wait(ready==1);
//end
//@(posedge clk)
//valid=0;
//wr_rd=0;
//w_data=0;
//addr=0;
//
//#100;
//$finish;
//end
//endmodule

//------------tb using task:------------
`include "mem.v"
module tb;
parameter width=8;
parameter depth=32;
parameter addr_width=$clog2(depth);
reg clk,rst,wr_rd,valid;
reg [addr_width-1:0]addr;
reg [width-1:0]w_data;
wire [width-1:0]r_data;
wire ready;

memory dut(.clk(clk),.rst(rst),.wr_rd(wr_rd),.addr(addr),.w_data(w_data),.r_data(r_data),.valid(valid),.ready(ready));
integer i;
always #5 clk=~clk;
initial begin
clk=0;
rst=1;
wr_rd=0;
addr=0;
w_data=0;
valid=0;
repeat (2) @(posedge clk)
rst=0;
write();
read();
#100;
$finish;
end
//write task
task write();
begin
for(i=0;i<depth;i=i+1) begin
	@(posedge clk)
	wr_rd=1;
	addr=i;
	w_data=$random;
	valid=1;
	wait(ready==1);
end
@(posedge clk)
valid=0;
wr_rd=0;
w_data=0;
addr=0;
end
endtask
//read task
task read();
begin
for(i=0;i<depth;i=i+1) begin
	@(posedge clk)
	wr_rd=0;
	addr=i;
	valid=1;
	wait(ready==1);
end
@(posedge clk)
valid=0;
wr_rd=0;
w_data=0;
addr=0;
end
endtask
endmodule


