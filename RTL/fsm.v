`include "define.v"
module fsm (Valid,Hwrite_reg,Hwrite,Hclk,Hdata1,Hdata2,Haddr1,Haddr2,Hreset,Tempselx,Hreadyout,Pselx,Paddr,Penable,Pwrite,Pwdata);//,Hrdata,Prdata);

input Valid,Hwrite_reg,Hwrite,Hreset,Hclk;
input [31:0]Haddr1,Haddr2,Hdata1,Hdata2;//,Prdata;
input [2:0]Tempselx;
output reg [2:0]Pselx;
output reg [31:0]Paddr,Pwdata;//,Hrdata;
output reg Penable,Pwrite,Hreadyout;


//parameter ST_IDLE = 3'b000,ST_WWAIT = 3'b001,ST_READ = 3'b010,ST_WRITE = 3'b011,ST_WRITEP = 3'b100,ST_RENABLE = 3'b101,ST_WENABLE = 3'b110,ST_WENABLEP = 3'b111;

reg [2:0] present_state,next_state;
reg [2:0]pselx_temp;
reg penable_temp,pwrite_temp,hreadyout_temp;
reg [31:0]paddr_temp,pwdata_temp;
reg [31:0]addr;

always @(posedge Hclk or negedge Hreset)
	begin
	if (!Hreset)
	present_state <= `ST_IDLE;
	else
	present_state <= next_state;
	end

always @(*)//Valid,Hwrite_reg,present_state,Hwrite)
	//next_state = 0;
	begin
	//next_state = 0;
	case(present_state)

	`ST_IDLE : if (Valid == 0)
	next_state = present_state;
	else if (Valid == 1 & Hwrite == 1)
	next_state = `ST_WWAIT;
	else if (Valid == 1 & Hwrite == 0)
	next_state = `ST_READ;
	else next_state = present_state;
	
	`ST_WWAIT : if (Valid == 0)
	next_state = `ST_WRITE;
	else next_state = `ST_WRITEP;

	`ST_READ : next_state = `ST_RENABLE;

	`ST_WRITE : if (Valid == 0)
	next_state = `ST_WENABLE;
	else next_state = `ST_WENABLEP;

	`ST_WRITEP : next_state = `ST_WENABLEP;

	`ST_RENABLE : if (Valid == 1 & Hwrite == 0)
	next_state = `ST_READ;
	else if (Valid == 0)
	next_state = `ST_IDLE;
	else if (Valid == 1 & Hwrite == 1)
	next_state = `ST_WWAIT;
	else next_state = present_state;

	`ST_WENABLE : if (Valid == 1 & Hwrite == 1)
	next_state = `ST_WWAIT;
	else if (Valid == 1 & Hwrite == 0)
	next_state = `ST_READ;
	else if (Valid == 0)
	next_state = `ST_IDLE;
	else next_state = present_state;

	`ST_WENABLEP : if (Valid == 0 & Hwrite_reg == 1)
	next_state = `ST_WRITE;
	else if (Valid == 1 & Hwrite_reg == 1)
	next_state = `ST_WRITEP;
	else if (Hwrite_reg == 0)
	next_state = `ST_READ;
	else next_state = present_state;
	
	endcase
	end	

always @(*)
	begin
pselx_temp = 0;
penable_temp = 0;
pwrite_temp = 0;
hreadyout_temp = 0;
paddr_temp = 0;
//pwdata_temp <= 0;
	//begin
	case(present_state)
	`ST_IDLE : begin
	hreadyout_temp = 1;
	//pwrite_temp = 0; //commented
	//pselx_temp = 0; //commented
	//penable_temp = 0; //commented
	end
	
	`ST_WWAIT : begin
	hreadyout_temp = 1; //change from 0 to 1
	end

	`ST_READ : begin
	paddr_temp = Haddr1;
	pselx_temp = Tempselx;
	hreadyout_temp = 0; //change from 1 to 0
	pwrite_temp = 0; //commented
	//penable_temp = 1; //extra
	end

	`ST_WRITE : begin
	paddr_temp = Haddr2; //Haddr1 changed from 2
	pwrite_temp = 1; // assuming blocking statement
	pwdata_temp = Hdata1; //comment it Hdata1
	pselx_temp = Tempselx;
//	pwrite_temp = 1;
	hreadyout_temp = 1;  //comment it
//	penable_temp = 0;	// comment it
	end

	`ST_WRITEP : begin
	paddr_temp = Haddr2; //Haddr2
	pselx_temp = Tempselx;
	pwrite_temp = 1;
	pwdata_temp = Hdata2;  //comment it Hdata1
	addr = paddr_temp; //y  comment it
//	hreadyout_temp = 0;
	//pwdata_temp = Hdata2; //extra
	//penable_temp = 1; //extra
	end 

	`ST_RENABLE : begin
//	paddr_temp = Haddr1;
	penable_temp = 1;
	hreadyout_temp = 1;
	paddr_temp = Haddr2; //Haddr2
	pselx_temp = Tempselx;
	pwrite_temp = 0;
	end 

	`ST_WENABLE : begin
	penable_temp = 1;
	pwrite_temp = 1;
	pselx_temp = Tempselx;
	paddr_temp = Haddr1; // assuming blocking assingment
	pwdata_temp = Hdata1;  //comment it
//	paddr_temp = Haddr1;
	hreadyout_temp = 1;  //comment it
	end

	`ST_WENABLEP : begin
	pwrite_temp = 1;
	penable_temp = 1;
	pselx_temp = Tempselx;
	pwdata_temp = Hdata2; //Hdata2
	hreadyout_temp = 1;
	paddr_temp = Haddr2; //y  comment it
	end
	endcase
	end
always @(posedge Hclk or negedge Hreset)
	begin
	if (!Hreset)
	begin
	Pwrite <= 0;
	Penable <= 0;
	Paddr <= 0;
	Pwdata <= 0;
	Pselx <= 0;
	Hreadyout <= 0;
	end
	else
	begin
	Pwrite <= pwrite_temp;
	Penable <= penable_temp;
	Paddr <= paddr_temp;
	Pwdata <= pwdata_temp;
	Pselx <= pselx_temp;
	Hreadyout <= hreadyout_temp;
	end
	end

endmodule