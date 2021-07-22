module bridge_top (Hwdata,Haddr,Htrans,Hreadyin,Hwrite,Hclk,Hreset,Hrdata,Prdata,Pselx,Paddr,Pwdata,Penable,Pwrite,Hreadyout);

input [31:0]Hwdata,Haddr,Prdata;
input [1:0]Htrans;
input Hreadyin,Hwrite,Hclk,Hreset;
output [2:0]Pselx;
output [31:0]Paddr,Pwdata;
output Penable,Pwrite,Hreadyout;
output [31:0]Hrdata;

wire Valid,Hwrite_reg;
wire [31:0] Haddr1,Haddr2,Hdata1,Hdata2;
wire [2:0] Tempselx;

assign Hrdata = Prdata;

ahb_slave a_s(.Hwdata(Hwdata),.Haddr(Haddr),.Htrans(Htrans),.Hreadyin(Hreadyin),.Hclk(Hclk),.Hreset(Hreset),.Hwrite(Hwrite),
.Valid(Valid),.Hwrite_reg(Hwrite_reg),.Tempselx(Tempselx),.Haddr1(Haddr1),.Haddr2(Haddr2),.Hdata1(Hdata1),.Hdata2(Hdata2));

fsm fsm_blk(.Valid(Valid),.Hwrite_reg(Hwrite_reg),.Hwrite(Hwrite),.Hreset(Hreset),.Hclk(Hclk),.Haddr1(Haddr1),.Haddr2(Haddr2),
.Hdata1(Hdata1),.Hdata2(Hdata2),.Tempselx(Tempselx),.Pselx(Pselx),.Paddr(Paddr),.Pwdata(Pwdata),.Penable(Penable),.Pwrite(Pwrite),
.Hreadyout(Hreadyout));//,.Hrdata(Hrdata),.Prdata(Prdata));

/*bridge_top top_blk(.Hwdata(Hwdata),.Haddr(Haddr),.Htrans(Htrans),.Hreadyin(Hreadyin),.Hclk(Hclk),.Hreset(Hreset),.Hwrite(Hwrite),
.Hrdata(Hrdata),.Prdata(Prdata),.Pselx(Pselx),.Paddr(Paddr),.Pwdata(Pwdata),.Penable(Penable),.Pwrite(Pwrite),.Hreadyout(Hreadyout));*/

endmodule