module Controller(x,y,z,w,h, direction, reset, VGA_clk);
	
	input  [7:0]x,y,z,w,h;
	input VGA_clk;
	output reg [2:0] direction;
	output reg reset =0; 

	wire ps2_clk, ps2_data;
	wire [7:0]ps2_key_data, last_data_received;
	wire ps2_key_pressed;
			
	PS2_Interface ps2(VGA_clk, 0, ps2_clk, ps2_data, ps2_key_data, ps2_key_pressed, last_data_received);
	
	always@(ps2_key_data,x,y,z,w,h)
begin
	 if(h)
		begin
			reset = 1;
			direction =3'b111;
		end
	else  
			begin
			reset =0 ;
			
        
			if(ps2_key_data == 8'h75)
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
end


endmodule 
