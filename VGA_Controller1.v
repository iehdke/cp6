module VGA_Controller1 (VGA_clk, xCount, yCount, displayArea, VGA_hSync, VGA_vSync, blank_n, keyboard_data, direction);

	input VGA_clk;
	output reg [9:0]xCount, yCount; 
	output reg displayArea;  
	output VGA_hSync, VGA_vSync, blank_n;
	input [7:0] keyboard_data;
	output reg [2:0] direction;

	reg p_hSync, p_vSync; 
   //wire [3:0]direction;
	
	integer porchHF = 640; //start of horizntal front porch
	integer syncH = 655;//start of horizontal sync
	integer porchHB = 747; //start of horizontal back porch
	integer maxH = 793; //total length of line.

	integer porchVF = 480; //start of vertical front porch 
	integer syncV = 490; //start of vertical sync
	integer porchVB = 492; //start of vertical back porch
	integer maxV = 525; //total rows. 
   
	wire [7:0] ps2_key_data;
	PS2_Interface(VGA_clk, 0, ps2_clock, ps2_data, keyboard_data, ps2_key_pressed, last_data_received);
	
	//assign keyboard_data = ps2_key_data;
	always@(posedge VGA_clk)
	begin
		if(xCount === maxH)
			xCount <= 0;
		else
			xCount <= xCount + 1;
	end
	// 93sync, 46 bp, 640 display, 15 fp
	// 2 sync, 33 bp, 480 display, 10 fp
	always@(posedge VGA_clk)
	begin
		if(xCount === maxH)
		begin
			if(yCount === maxV)
				yCount <= 0;
			else
			yCount <= yCount + 1;
		end
	end
	
	always@(posedge VGA_clk)
	begin
		displayArea <= ((xCount < porchHF) && (yCount < porchVF)); 
	end

	always@(posedge VGA_clk)
	begin
		p_hSync <= ((xCount >= syncH) && (xCount < porchHB)); 
		p_vSync <= ((yCount >= syncV) && (yCount < porchVB)); 
	end
 
	assign VGA_vSync = ~p_vSync; 
	assign VGA_hSync = ~p_hSync;
	assign blank_n = displayArea;
	
	///
	always@(keyboard_data)
	begin
      if (keyboard_data == 8'h75)
		direction = 3'b001;
		
		else if(ps2_key_data == 8'h6B)
		direction = 3'b010;
			
		else if(ps2_key_data == 8'h72)
		direction = 3'b011;
		
		else if(ps2_key_data == 8'h74)
		direction = 3'b100;
		
		else  
		direction <= direction;
		   
	end
endmodule	
