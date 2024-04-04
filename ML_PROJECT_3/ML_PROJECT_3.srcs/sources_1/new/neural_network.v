`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2024 03:20:31
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


module neural_network(clk, rst, start, image, prediction, Done);
input clk;
input rst;
input start;
input [0:255] image;
output reg Done;
output reg [0:3] prediction;

reg [0:9] ps;
reg prst;
reg Mul_1;
reg Add_1;
reg ReLU_1;
reg Mul_2;
reg Add_2;
reg ReLU_2;
reg Max;
reg [0:7] count;

reg signed [0:10] Mul_1_out [0:29];
wire signed [0:14] Shifted_Mul_1_out [0:29];
reg signed [0:14] Add_1_out [0:29];
reg signed [0:28] ReLU_1_out [0:29];
reg signed [0:38] Mul_2_out [0:9];
wire signed [0:33] Shifted_b23 [0:9]; 
reg signed [0:38] Add_2_out [0:9];
reg signed [0:52] ReLU_2_out [0:9];
reg signed [0:52] Max_temp;
reg signed [0:9]  Max_out;
integer i,j;


reg signed [0:10] w12 [0:29][0:255];
reg signed [0:9] w23 [0:9][0:29];
reg signed [0:14] b12 [0:29];
reg signed [0:12] b23 [0:9];

always@(posedge rst)
begin
    $readmemb("w12.mem",w12);
    $readmemb("w23.mem",w23);    
    $readmemb("b12.mem",b12);
    $readmemb("b23.mem",b23);        
end

parameter s0  = 10'b0000000001;
parameter s1  = 10'b0000000010;
parameter s2  = 10'b0000000100;
parameter s3  = 10'b0000001000;
parameter s4  = 10'b0000010000;
parameter s5  = 10'b0000100000;
parameter s6  = 10'b0001000000;
parameter s7  = 10'b0010000000;
parameter s8  = 10'b0100000000;
parameter s9  = 10'b1000000000;


// Control Unit
always@(posedge clk)
begin
    case(ps)
    s0: // Start state
        begin            
            if(start == 0)
                begin
                    ps <= s0;
                    count <= 0;
                end
            else
                begin
                    ps <= s1; 
                    prst   <= 1;
                end
        end
    s1: // Reset state
        begin
            if(count == 29)
                begin
                    ps <= s2;
                    count <= 0;
                    prst   <= 0;
                    Mul_1 <= 1;
                end
            else
                begin
                    ps <= s1;
                    count <= count + 1;
                end 
        end
    s2: // Mul_1 state
        begin
            if(count == 255)
                begin
                    ps <= s3;
                    count <= 0;
                    Mul_1 <= 0;
                    Add_1 <= 1;
                end
            else
                begin
                    ps <= s2;
                    count <= count + 1;
                end 
        end  
    s3: // Add_1 state
        begin
            Add_1 <= 0;
            ps <= s4;
            ReLU_1 <= 1;
        end
    s4: // ReLU_1 state
        begin
            if(count == 29)
                begin
                    ps <= s5;
                    count <= 0;
                    ReLU_1 <= 0;
                    Mul_2 <= 1;
                end
            else
                begin
                    ps <= s4;
                    count <= count + 1;
                end
        end          
    s5: // Mul_2 state
        begin
            if(count == 29)
                begin
                    ps <= s6;
                    Mul_2 <= 0;
                    Add_2 <= 1;
                    count <= 0;
                end
            else
                begin
                    ps <= s5;
                    count <= count + 1;
                end                
        end         
    s6: // Add_2 state
        begin
            Add_2 <= 0;
            ReLU_2 <= 1;
            ps <= s7;
        end
    s7: // ReLU_2 state
        begin
            if(count == 9)
                begin
                    ReLU_2 <= 0;
                    Max <= 1;
                    ps <= s8;
                    count <= 0;
                end
            else
                begin
                    ps <= s7;
                    count <= count + 1;
                end
        end    
    s8: // Max state
        begin
            if(count == 8)
                begin
                    ps <= s9;
                    Max <= 0;
                    Done <= 1;
                    count <= 0;
                end
            else
                begin
                    ps <= s8;
                    count <= count + 1;
                end
        end
    s9: // Done state
        begin
            prediction <= Max_out;
            ps <= s0;
            Done <= 0;
        end 
    default:
        ps <= s0;                         
endcase     
end

// Top level reset
always@(posedge clk)
begin
    if(rst == 1)
    begin
	    prediction <= 0;
	    prst   <= 0;
        Mul_1  <= 0;
        Add_1  <= 0;
        ReLU_1 <= 0;
        Mul_2  <= 0;
        Add_2  <= 0;
        ReLU_2 <= 0;
        Max    <= 0;
        Done   <= 0;
    end
end


always@(posedge clk)
begin
    if(prst == 1)
    begin
        Mul_1_out[count] <= 30'd0;
        Add_1_out[count] <= 30'd0;
        ReLU_1_out[count] <= 30'd0;
        if(count < 10)
        begin
            Mul_2_out[count] <= 10'd0;
            Add_2_out[count] <= 10'd0;
            ReLU_2_out[count] <= 10'd0;
        end
        
        if(count == 0)
        begin
            Max_out  <= 1'd0;
            Max_temp <= 1'd0;
        end
    end
end

// Mul_1
always@(posedge clk)
begin
    if(Mul_1 == 1)
    begin
        Mul_1_out[0] <= Mul_1_out[0] + w12[0][count]*image[count];
        Mul_1_out[1] <= Mul_1_out[1] + w12[1][count]*image[count];
        Mul_1_out[2] <= Mul_1_out[2] + w12[2][count]*image[count];
        Mul_1_out[3] <= Mul_1_out[3] + w12[3][count]*image[count];
        Mul_1_out[4] <= Mul_1_out[4] + w12[4][count]*image[count];
        Mul_1_out[5] <= Mul_1_out[5] + w12[5][count]*image[count];
        Mul_1_out[6] <= Mul_1_out[6] + w12[6][count]*image[count];
        Mul_1_out[7] <= Mul_1_out[7] + w12[7][count]*image[count];
        Mul_1_out[8] <= Mul_1_out[8] + w12[8][count]*image[count];
        Mul_1_out[9] <= Mul_1_out[9] + w12[9][count]*image[count];
        Mul_1_out[10] <= Mul_1_out[10] + w12[10][count]*image[count];
        Mul_1_out[11] <= Mul_1_out[11] + w12[11][count]*image[count];
        Mul_1_out[12] <= Mul_1_out[12] + w12[12][count]*image[count];
        Mul_1_out[13] <= Mul_1_out[13] + w12[13][count]*image[count];
        Mul_1_out[14] <= Mul_1_out[14] + w12[14][count]*image[count];
        Mul_1_out[15] <= Mul_1_out[15] + w12[15][count]*image[count];
        Mul_1_out[16] <= Mul_1_out[16] + w12[16][count]*image[count];
        Mul_1_out[17] <= Mul_1_out[17] + w12[17][count]*image[count];
        Mul_1_out[18] <= Mul_1_out[18] + w12[18][count]*image[count];
        Mul_1_out[19] <= Mul_1_out[19] + w12[19][count]*image[count];
        Mul_1_out[20] <= Mul_1_out[20] + w12[20][count]*image[count];
        Mul_1_out[21] <= Mul_1_out[21] + w12[21][count]*image[count];
        Mul_1_out[22] <= Mul_1_out[22] + w12[22][count]*image[count];
        Mul_1_out[23] <= Mul_1_out[23] + w12[23][count]*image[count];
        Mul_1_out[24] <= Mul_1_out[24] + w12[24][count]*image[count];
        Mul_1_out[25] <= Mul_1_out[25] + w12[25][count]*image[count];
        Mul_1_out[26] <= Mul_1_out[26] + w12[26][count]*image[count];
        Mul_1_out[27] <= Mul_1_out[27] + w12[27][count]*image[count];
        Mul_1_out[28] <= Mul_1_out[28] + w12[28][count]*image[count];
        Mul_1_out[29] <= Mul_1_out[29] + w12[29][count]*image[count];
    end
end


assign Shifted_Mul_1_out[0] = {Mul_1_out[0],4'b0};
assign Shifted_Mul_1_out[1] = {Mul_1_out[1],4'b0};
assign Shifted_Mul_1_out[2] = {Mul_1_out[2],4'b0};
assign Shifted_Mul_1_out[3] = {Mul_1_out[3],4'b0};
assign Shifted_Mul_1_out[4] = {Mul_1_out[4],4'b0};
assign Shifted_Mul_1_out[5] = {Mul_1_out[5],4'b0};
assign Shifted_Mul_1_out[6] = {Mul_1_out[6],4'b0};
assign Shifted_Mul_1_out[7] = {Mul_1_out[7],4'b0};
assign Shifted_Mul_1_out[8] = {Mul_1_out[8],4'b0};
assign Shifted_Mul_1_out[9] = {Mul_1_out[9],4'b0};
assign Shifted_Mul_1_out[10] = {Mul_1_out[10],4'b0};
assign Shifted_Mul_1_out[11] = {Mul_1_out[11],4'b0};
assign Shifted_Mul_1_out[12] = {Mul_1_out[12],4'b0};
assign Shifted_Mul_1_out[13] = {Mul_1_out[13],4'b0};
assign Shifted_Mul_1_out[14] = {Mul_1_out[14],4'b0};
assign Shifted_Mul_1_out[15] = {Mul_1_out[15],4'b0};
assign Shifted_Mul_1_out[16] = {Mul_1_out[16],4'b0};
assign Shifted_Mul_1_out[17] = {Mul_1_out[17],4'b0};
assign Shifted_Mul_1_out[18] = {Mul_1_out[18],4'b0};
assign Shifted_Mul_1_out[19] = {Mul_1_out[19],4'b0};
assign Shifted_Mul_1_out[20] = {Mul_1_out[20],4'b0};
assign Shifted_Mul_1_out[21] = {Mul_1_out[21],4'b0};
assign Shifted_Mul_1_out[22] = {Mul_1_out[22],4'b0};
assign Shifted_Mul_1_out[23] = {Mul_1_out[23],4'b0};
assign Shifted_Mul_1_out[24] = {Mul_1_out[24],4'b0};
assign Shifted_Mul_1_out[25] = {Mul_1_out[25],4'b0};
assign Shifted_Mul_1_out[26] = {Mul_1_out[26],4'b0};
assign Shifted_Mul_1_out[27] = {Mul_1_out[27],4'b0};
assign Shifted_Mul_1_out[28] = {Mul_1_out[28],4'b0};
assign Shifted_Mul_1_out[29] = {Mul_1_out[29],4'b0};

// Add_1
always@(posedge clk)
begin
    if(Add_1 == 1)
    begin
        Add_1_out[0] <= Shifted_Mul_1_out[0] + b12[0];
        Add_1_out[1] <= Shifted_Mul_1_out[1] + b12[1];
        Add_1_out[2] <= Shifted_Mul_1_out[2] + b12[2];
        Add_1_out[3] <= Shifted_Mul_1_out[3] + b12[3];
        Add_1_out[4] <= Shifted_Mul_1_out[4] + b12[4];
        Add_1_out[5] <= Shifted_Mul_1_out[5] + b12[5];
        Add_1_out[6] <= Shifted_Mul_1_out[6] + b12[6];
        Add_1_out[7] <= Shifted_Mul_1_out[7] + b12[7];
        Add_1_out[8] <= Shifted_Mul_1_out[8] + b12[8];
        Add_1_out[9] <= Shifted_Mul_1_out[9] + b12[9];
        Add_1_out[10] <= Shifted_Mul_1_out[10] + b12[10];
        Add_1_out[11] <= Shifted_Mul_1_out[11] + b12[11];
        Add_1_out[12] <= Shifted_Mul_1_out[12] + b12[12];
        Add_1_out[13] <= Shifted_Mul_1_out[13] + b12[13];
        Add_1_out[14] <= Shifted_Mul_1_out[14] + b12[14];
        Add_1_out[15] <= Shifted_Mul_1_out[15] + b12[15];
        Add_1_out[16] <= Shifted_Mul_1_out[16] + b12[16];
        Add_1_out[17] <= Shifted_Mul_1_out[17] + b12[17];
        Add_1_out[18] <= Shifted_Mul_1_out[18] + b12[18];
        Add_1_out[19] <= Shifted_Mul_1_out[19] + b12[19];
        Add_1_out[20] <= Shifted_Mul_1_out[20] + b12[20];
        Add_1_out[21] <= Shifted_Mul_1_out[21] + b12[21];
        Add_1_out[22] <= Shifted_Mul_1_out[22] + b12[22];
        Add_1_out[23] <= Shifted_Mul_1_out[23] + b12[23];
        Add_1_out[24] <= Shifted_Mul_1_out[24] + b12[24];
        Add_1_out[25] <= Shifted_Mul_1_out[25] + b12[25];
        Add_1_out[26] <= Shifted_Mul_1_out[26] + b12[26];
        Add_1_out[27] <= Shifted_Mul_1_out[27] + b12[27];
        Add_1_out[28] <= Shifted_Mul_1_out[28] + b12[28];
        Add_1_out[29] <= Shifted_Mul_1_out[29] + b12[29];
    end
end

// ReLU_1
always@(posedge clk)
begin
    if(ReLU_1 == 1)
    begin
        if(Add_1_out[count][0] == 0)
            begin
                ReLU_1_out[count] <= Add_1_out[count] * $signed(14'd4096);                  
            end
        else
            begin
                ReLU_1_out[count] <= Add_1_out[count] * $signed(14'd409);
            end
    end
end

// Mul_2
always@(posedge clk)
begin
    if(Mul_2 == 1)
    begin
        Mul_2_out[0] <= Mul_2_out[0] + w23[0][count] * ReLU_1_out[count];
        Mul_2_out[1] <= Mul_2_out[1] + w23[1][count] * ReLU_1_out[count];
        Mul_2_out[2] <= Mul_2_out[2] + w23[2][count] * ReLU_1_out[count];
        Mul_2_out[3] <= Mul_2_out[3] + w23[3][count] * ReLU_1_out[count];
        Mul_2_out[4] <= Mul_2_out[4] + w23[4][count] * ReLU_1_out[count];
        Mul_2_out[5] <= Mul_2_out[5] + w23[5][count] * ReLU_1_out[count];
        Mul_2_out[6] <= Mul_2_out[6] + w23[6][count] * ReLU_1_out[count];
        Mul_2_out[7] <= Mul_2_out[7] + w23[7][count] * ReLU_1_out[count];
        Mul_2_out[8] <= Mul_2_out[8] + w23[8][count] * ReLU_1_out[count];
        Mul_2_out[9] <= Mul_2_out[9] + w23[9][count] * ReLU_1_out[count];
    end
end

assign Shifted_b23[0] = {b23[0],21'b0};
assign Shifted_b23[1] = {b23[1],21'b0};
assign Shifted_b23[2] = {b23[2],21'b0};
assign Shifted_b23[3] = {b23[3],21'b0};
assign Shifted_b23[4] = {b23[4],21'b0};
assign Shifted_b23[5] = {b23[5],21'b0};
assign Shifted_b23[6] = {b23[6],21'b0};
assign Shifted_b23[7] = {b23[7],21'b0};
assign Shifted_b23[8] = {b23[8],21'b0};
assign Shifted_b23[9] = {b23[9],21'b0};

// Add_2
always@(posedge clk)
begin
    if(Add_2 == 1)
    begin
        Add_2_out[0] <= Mul_2_out[0] + Shifted_b23[0];
        Add_2_out[1] <= Mul_2_out[1] + Shifted_b23[1];
        Add_2_out[2] <= Mul_2_out[2] + Shifted_b23[2];
        Add_2_out[3] <= Mul_2_out[3] + Shifted_b23[3];
        Add_2_out[4] <= Mul_2_out[4] + Shifted_b23[4];
        Add_2_out[5] <= Mul_2_out[5] + Shifted_b23[5];
        Add_2_out[6] <= Mul_2_out[6] + Shifted_b23[6];
        Add_2_out[7] <= Mul_2_out[7] + Shifted_b23[7];
        Add_2_out[8] <= Mul_2_out[8] + Shifted_b23[8];
        Add_2_out[9] <= Mul_2_out[9] + Shifted_b23[9];
    end
end

// ReLU_2
always@(posedge clk)
begin
    if(ReLU_2 == 1)
    begin
        if(Add_2_out[count][0] == 0)
        begin
            ReLU_2_out[count]<= Add_2_out[count] * $signed(14'd4096);                  
        end
        else
        begin
            ReLU_2_out[count] <= Add_2_out[count] * $signed(14'd409);
        end
    end
end

// Max
always@(posedge clk)
begin
    if(Max == 1)
    begin

        if(count == 0)
        begin
            Max_temp <= ReLU_2_out[0];
        end

        if(ReLU_2_out[count+1] >= Max_temp)
        begin
            Max_out <= count + 1;
            Max_temp <= ReLU_2_out[count+1];
        end
    end
end

endmodule
