`include "define.v"
module ahb_master (Hclk,Hreset,Hreadyout,Hrdata,Hresp,/*Hsize,Hburst,*/Hwrite,Hreadyin,Htrans,Haddr,Hwdata);

input Hclk,Hreset,Hreadyout;
input [31:0] Hrdata;
input [1:0] Hresp;
/*output*/ reg [2:0] Hsize,Hburst;
output reg Hreadyin,Hwrite;
output reg [1:0] Htrans;
output reg [31:0] Haddr,Hwdata;

/*parameter BYTE = 3'b000,HALFWORD = 3'b001,WORD = 3'b010;
parameter SINGLE = 3'b000,INCR = 3'b001,WRAP4 = 3'b010,INCR4 = 3'b011,WRAP8 = 3'b100,INCR8 = 3'b101,WRAP16 = 3'b110,INCR16 = 3'b111;
parameter IDLE = 2'b00,BUSY = 2'b01,NONSEQ = 2'b10,SEQ = 2'b11;*/
integer i;
assign Hresp = `OKAY;

/*always @(*)
	begin
	if (Hwrite)
	Hresp = `OKAY;
	else Hresp = `ERROR;
	end*/

task single_read;
	begin
	@(posedge Hclk)
	#30;
	begin
	Htrans = `NONSEQ;
	Haddr = 32'h8000705;
	Hwrite = 0;
	Hreadyin = 1;
//	Hburst = SINGLE;
	end
	@(posedge Hclk);
	#30;
	Htrans = `IDLE;
//	Hrdata = 32'h00054280;
	end
	endtask
	
task single_write;
	begin
	@(posedge Hclk)
	#30;
	begin
	Htrans = `NONSEQ;
	Haddr = 32'h80000501;
	Hwrite = 1;
	Hreadyin = 1;
	Hburst = `SINGLE;
	end
	@(posedge Hclk)
	#30
	Htrans = `IDLE;
	Hwdata = 32'h00032845;
	end
	endtask

//endmodule

task hburst_write (input [2:0] a,b);
	begin
	#20
	@(posedge Hclk)
//	#20
	begin
	Hreadyin = 1'b1;
	Htrans = `NONSEQ;
	Haddr = 32'h80001000;
	Hwrite = 1'b1;
	Hburst = a;
	Hsize = b;
	end


/*always@(posedge Hclk)
	begin*/
case(Hsize)

`BYTE : begin
	case (Hburst)
	`INCR4 : begin
//		#20
		wait(Hreadyout)
		@(posedge Hclk)
		//Hreadyout = 1'b1;
		Htrans = `SEQ;
//		Haddr = Haddr + 1'b1; // assuming blocking 
		Hwdata = {$random} %256;
		Haddr = Haddr + 1'b1;
		wait(Hreadyout)
		@(posedge Hclk)
		Hwdata = {$random} %256;
//		Haddr = Haddr + 1'b1; // comment it incr4

/*		wait(Hreadyout)
		@(posedge Hclk)
		Hwdata = {$random} %256;
		Haddr = Haddr + 1'b1;*/

		for (i = 0;i < 6; i = i+1)
		begin
//		#20
//		@(posedge Hclk) // comment it incr4
//		wait(Hreadyout) //comment it incr4
		Htrans = `SEQ;
		Haddr = Haddr + 1'b1;
//		Hwdata = {$random} %256; // comment it incr4
		wait(Hreadyout)
		@(posedge Hclk)
		Hwdata = {$random} %256;
//		Haddr = Haddr + 1'b1; // comment it incr4
		end
		
		Htrans = `IDLE;
		end
		//end
	`INCR8 : begin
		wait(Hreadyout)
		@(posedge Hclk)
		Htrans = `SEQ;
		Hwdata = {$random} %256;
		Haddr = Haddr + 1'b1;
		wait(Hreadyout) // maybe removed
		@(posedge Hclk) // maybe removed
		Hwdata = {$random} %256; // maybe removed
//		Haddr = Haddr + 1'b1;
		
		for (i = 0; i < 6; i = i+1)
		begin
		@(posedge Hclk)
		wait(Hreadyout)
		Htrans = `SEQ;
		Haddr = Haddr + 1'b1;
//		Hwdata = {$random} %256;
		wait(Hreadyout)
		@(posedge Hclk)
		Hwdata = {$random} %256;
		end
		
		Htrans = `IDLE;
		end

	`INCR16 : begin
		wait(Hreadyout)
		@(posedge Hclk)
		Htrans = `SEQ;
		Hwdata = {$random} %256;
		Haddr = Haddr + 1'b1;
		wait(Hreadyout) // maybe removed
		@(posedge Hclk) // maybe removed
		Hwdata = {$random} %256; // maybe removed
//		Haddr = Haddr + 1'b1;
		
		for (i = 0; i < 14; i = i+1)
		begin
		@(posedge Hclk)
		wait(Hreadyout)
		Htrans = `SEQ;
		Haddr = Haddr + 1'b1;
//		Hwdata = {$random} %256;
		wait(Hreadyout)
		@(posedge Hclk)
		Hwdata = {$random} %256;
		end
		
		Htrans = `IDLE;
		end
//	endcase
//	end
//endcase
//endtask

//endmodule

	`WRAP4 : begin
		#2;//wait(Hreadyout)
		Hwdata = {$random} %256;//@(posedge Hclk)
		Htrans = `SEQ;
		{Haddr[31:2],Haddr[1:0]} = {Haddr[31:2],Haddr[1:0]+1'b1};
		@(posedge Hclk)
		
		for (i = 0;i < 2;i = i+1)
		begin
		wait(Hreadyout)
		@(posedge Hclk)
		#2;
		Htrans = `SEQ;
		{Haddr[31:2],Haddr[1:0]} = {Haddr[31:2],Haddr[1:0]+1'b1};
		Hwdata = ($random) %256;
		//@(posedge Hclk)
		end
		
		wait(Hreadyout)
		@(posedge Hclk)
		#2;
	//	Hwdata = {$random} %256;
		Htrans = `IDLE;
		end
	endcase
end
endcase
end
endtask
endmodule
/*
		endcase
HALFWORD : begin
		case(Hsize)
		INCR4 : 
	/*if (Hsize = BYTE)
	Haddr = Haddr + 1;
	else if (Hsize = HALFWORD)
	Haddr = Haddr + 2;*/

/*INCR :
	
endmodule*/