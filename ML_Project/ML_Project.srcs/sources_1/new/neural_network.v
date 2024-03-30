`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2024 10:35:50
// Design Name: 
// Module Name: neural_network
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module neural_network(clk, rst, start, image, prediction);
input clk;
input rst;
input start;
input [0:255] image;
output reg [0:3] prediction;

reg [3:0] ps =0;
reg prst;
reg load;
reg Mul_1;
reg Add_1;
reg ReLU_1;
reg Mul_2;
reg Add_2;
reg ReLU_2;
reg Max;
reg Done;

reg [0:255] img;
reg [0:10] Mul_1_out [0:29];
reg [0:10] Add_1_out [0:29];
reg [0:21] ReLU_1_out [0:29];
reg [0:40] Mul_2_out [0:9];
reg [0:40] Add_2_out [0:9];
reg [0:75] ReLU_2_out [0:9];
reg [0:43] Trunc_ReLU_2_out [0:9];
reg [0:9]  Max_out;
reg [0:43] Max_temp;
integer i,j;

//[w12fixedfloat , w12fixedinteger ,err] = fixedpoint1(w12,11,8,1);
//[w23fixedfloat , w23fixedinteger ,err] = fixedpoint1(w23,19,16,1);
//[b12fixedfloat , b12fixedinteger ,err] = fixedpoint1(b12,11,8,1);
//[b23fixedfloat , b23fixedinteger ,err] = fixedpoint1(b23,35,32,1);

reg [0:10] w12 [0:29][0:255];
reg [0:18] w23 [0:9][0:29];
reg [0:10] b12 [0:29];
reg [0:34] b23 [0:9];

always@(posedge rst)
begin
    $readmemb("w12.mem",w12);
    $readmemb("w23.mem",w23);    
    $readmemb("b12.mem",b12);
    $readmemb("b23.mem",b23);        
end

parameter s0 = 0;
parameter s1 = 1;
parameter s2 = 2;
parameter s3 = 3;
parameter s4 = 4;
parameter s5 = 5;
parameter s6 = 6;
parameter s7 = 7;
parameter s8 = 8;
parameter s9 = 9;

// Control Unit
always@(posedge clk)
begin
    case(ps)
    s0: // Reset state
        begin
            prst   <= 1;
            load   <= 0;
            Mul_1  <= 0;
            Add_1  <= 0;
            ReLU_1 <= 0;
            Mul_2  <= 0;
            Add_2  <= 0;
            ReLU_2 <= 0;
            Max    <= 0;
            Done   <= 0;
            if(start == 0)
                ps <= s0;
            else
                ps <= s1;
        end
    s1: // Load state
        begin
            prst <= 0;
            load <= 1;
            ps <= s2;
        end
    s2: // Mul_1 state
        begin
            load <= 0;
            Mul_1 <= 1;
            ps <= s3;
        end  
    s3: // Add_1 state
        begin
            Mul_1 <= 0;
            Add_1 <= 1;
            ps <= s4;
        end
    s4: // ReLU_1 state
        begin
            Add_1 <= 0;
            ReLU_1 <= 1;
            ps <= s5;
        end          
    s5: // Mul_2 state
        begin
            ReLU_1 <= 0;
            Mul_2 <= 1;
            ps <= s6;
        end         
    s6: // Add_2 state
        begin
            Mul_2 <= 0;
            Add_2 <= 1;
            ps <= s7;
        end
    s7: // ReLU_2 state
        begin
            Add_2 <= 0;
            ReLU_2 <= 1;
            ps <= s8;
        end    
    s8: // Max state
        begin
            ReLU_2 <= 0;
            Max <= 1;
            ps <= s9;
        end
    s9: // Max state
        begin
            Max <= 0;
            Done <= 1;
            ps <= s0;
        end                          
endcase     
end

// Top level reset
always@(posedge clk)
begin
    if(rst == 1)
    begin
        prediction <= 0;
    end
end

// Load
always@(posedge clk)
begin
    if(prst == 1)
    begin
        img <= 0;
    end
    else if(load == 1)
    begin
        img <= image;
    end
end

// Mul_1
always@(posedge clk)
begin
    if(prst == 1)
    begin
        for(i = 0; i <30; i = i + 1)
        begin
            Mul_1_out[i] <= 0;
        end
    end
    else if(Mul_1 == 1)
    begin
        for (i = 0; i < 30; i = i + 1)
        begin
            for (j = 0; j < 256; j = j + 1)
            begin
                Mul_1_out[i] = $signed(Mul_1_out[i]) + $signed(w12[i][j])*image[j];
            end
        end
    end
end

// Add_1
always@(posedge clk)
begin
    if(prst == 1)
    begin
        for(i = 0; i <30; i = i + 1)
        begin
            Add_1_out[i] <= 0;
        end
    end
    else if(Add_1 == 1)
    begin
        for (i = 0; i < 30; i = i + 1)
        begin
            Add_1_out[i] = $signed(Mul_1_out[i]) + $signed(b12[i]);
        end
    end
end

// ReLU_1
always@(posedge clk)
begin
    if(prst == 1)
    begin
        for(i = 0; i <30; i = i + 1)
        begin
            ReLU_1_out[i] <= 0;
        end
    end
    else if(ReLU_1 == 1)
    begin
        for (i = 0; i < 30; i = i + 1)
        begin
            if(Add_1_out[i][0] == 0)
            begin
                ReLU_1_out[i] = $signed(Add_1_out[i]) * $signed(11'd256);                  
            end
            else
            begin
                ReLU_1_out[i] = $signed(Add_1_out[i]) * $signed(11'd25);
            end
        end
    end
end

// Mul_2
always@(posedge clk)
begin
    if(prst == 1)
    begin
        for(i = 0; i <10; i = i + 1)
        begin
            Mul_2_out[i] <= 0;
        end
    end
    else if(Mul_2 == 1)
    begin
        for (i = 0; i < 10; i = i + 1)
        begin
            for (j = 0; j < 30; j = j + 1)
            begin
                Mul_2_out[i] = $signed(Mul_2_out[i]) + $signed(w23[i][j]) * $signed(ReLU_1_out[j]);
            end
        end
    end
end

// Add_2
always@(posedge clk)
begin
    if(prst == 1)
    begin
        for(i = 0; i <10; i = i + 1)
        begin
            Add_2_out[i] <= 0;
        end
    end
    else if(Add_2 == 1)
    begin
        for (i = 0; i < 10; i = i + 1)
        begin
            Add_2_out[i] = $signed(Mul_2_out[i]) + $signed(b23[i]);
        end
    end
end

// ReLU_2
always@(posedge clk)
begin
    if(prst == 1)
    begin
        for(i = 0; i <10; i = i + 1)
        begin
            ReLU_2_out[i] <= 0;
        end
    end
    else if(ReLU_2 == 1)
    begin
        for (i = 0; i < 10; i = i + 1)
        begin
            if(Add_2_out[i][0] == 0)
            begin
                ReLU_2_out[i] = $signed(Add_2_out[i]) * $signed(41'd4294967296);                  
            end
            else
            begin
                ReLU_2_out[i] = $signed(Add_2_out[i]) * $signed(41'd429496729);
            end
            Trunc_ReLU_2_out[i] = ReLU_2_out[i] >>> 32;
        end
    end
end

// Max
always@(posedge clk)
begin
    if(prst == 1)
    begin
        Max_out <= 0;
        Max_temp <= 0; 
    end
    else if(Max == 1)
    begin
        Max_temp = Trunc_ReLU_2_out[0];
        for (i = 0; i < 9; i = i + 1)
        begin
            if($signed(Trunc_ReLU_2_out[i+1]) >= $signed(Max_temp))
            begin
                Max_out = i + 1;//Max_out + 1; //i+1;
                Max_temp = Trunc_ReLU_2_out[i+1];
            end
        end
//        Max_out <= 2;
        prediction <= Max_out;
    end
end


endmodule
