//memory testcases
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
//reg [20*8-1:0]test_name;
always #5 clk=~clk;
reg [20*8-1:0]test_name;
initial begin
$value$plusargs("test_name=%s",test_name);
end
initial begin
clk=0;
rst=1;
wr_rd=0;
addr=0;
w_data=0;
valid=0;
repeat (2) @(posedge clk)
rst=0;
case(test_name)
"1wr-1rd": begin
	write(15,1);
	read(15,1);
end

"5wr-5rd":begin
write(20,5);
read(20,5);
end

"fd-wr-fd-rd":begin
write(0,depth);
read(0,depth);
end
"bd-wr-bd-rd":begin
	bd_write();
	bd_read();
end
"fd-wr-bd-rd":begin
	write(0,depth);
	bd_read();
end
"bd-wr-fd-rd":begin
	bd_write();
	read(0,depth);
end
"1st-quarter":begin
	write(0,depth/4);
	read(0,depth/4);
end
"2nd-quarter":begin
	write(depth/4,depth/4);
	read(depth/4,depth/4);
end

"3rd-quarter":begin
	write(depth/2,depth/4);
	read(depth/2,depth/4);
end

"4th-quarter":begin
	write(3*(depth/4),depth/4);
	read(3*(depth/4),depth/4);
end

"consecutive":begin
	for(i=0;i<depth;i=i+1)
		consecutive(i);
end
endcase
#100;
$finish;
end
//write task
task write(input reg [addr_width-1:0]start_loc,input reg[addr_width:0]num_writes);
begin
for(i=start_loc;i<(start_loc+num_writes);i=i+1) begin
	@(posedge clk)
	wr_rd=1;
	addr=i;
	w_data=$random;
	valid=1;
	wait(ready==1);
	end
	end
endtask
//read task
task read(input reg [addr_width-1:0]start_loc,input reg[addr_width:0]num_reads);
begin
	for(i=start_loc;i<(start_loc+num_reads);i=i+1) begin
		@(posedge clk)
		wr_rd=0;
		addr=i;
		valid=1;
		wait(ready==1);
	end
end
endtask
//backdoor write
task bd_write();
	$readmemh("input.hex",dut.mem);
endtask
//backdoor read
task bd_read();
	$writememh("output.hex",dut.mem);
endtask
//cosecutive write and read
task consecutive(input reg [addr_width-1:0]loc);
begin
	@(posedge clk)
	wr_rd=1;
	addr=i;
	w_data=$random;
	valid=1;
	wait(ready==1);
    @(posedge clk)
	wr_rd=0;
	addr=i;
	valid=1;
	wait(ready==1);
end
endtask
endmodule


