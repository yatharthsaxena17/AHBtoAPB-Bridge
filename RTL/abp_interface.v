module apb_interface(Pwrite,Penable,Pselx,Paddr,Pwdata,Pwrite_out,Penable_out,Pselx_out,Paddr_out,Pwdata_out,Prdata);

input Pwrite,Penable;
input [2:0]Pselx;
input [31:0]Paddr,Pwdata;
output Pwrite_out,Penable_out;
output [2:0]Pselx_out;
output [31:0]Paddr_out,Pwdata_out;
output reg [31:0]Prdata;

assign Pwrite_out = Pwrite;
assign Penable_out = Penable;
assign Pselx_out = Pselx;
assign Paddr_out = Paddr;
assign Pwdata_out = Pwdata;

always@(*)
	begin
	if (!Pwrite && Penable)
	Prdata = {$random}%256;
	else Prdata = 32'h0;
	end

endmodule