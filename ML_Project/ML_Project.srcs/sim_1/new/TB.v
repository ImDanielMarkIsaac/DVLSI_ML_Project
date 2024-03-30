`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2024 12:34:03
// Design Name: 
// Module Name: TB
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


module TB();
reg clk = 0;
reg rst;
reg start = 0;
reg [0:255] image;
wire [0:3] prediction;
reg [0:255] memory [0:1592];
reg [0:9] Labels [0:1592];

integer k;
reg [0:11] tot = 0;
reg [0:11] correct = 0;
reg [0:9] one_hot = 0;
reg Test_complete = 0;

neural_network n1(.clk(clk), .rst(rst), .start(start), .image(image), .prediction(prediction));

initial
begin
    $readmemb("Inputs.mem",memory);
    $readmemb("Labels.mem",Labels);
    #2;
    rst <= 1;
    #2;
    rst <= 0;
    
    for(k = 1100; k < 1593; k = k + 1)
    begin
        image <= memory[k];
        #2;
        start <= 1;
        #2;
        start <= 0;
        #20;
        one_hot[prediction] <= 1;
        #1;
        if( one_hot == Labels[k])
        begin
            correct = correct + 1;
        end
        tot = tot + 1;
        one_hot <= 0;
    end
    
    Test_complete <= 1;
    
end

always@(clk)
begin
    #1 clk <= ~clk;
end

endmodule




//    image <= 256'b0000001111111100000001111110110000001111110001100001111100001111000111101111111000011101111101100011111111000110001111110000110001111110000011000111100000001100011100000011100011100000001100001111000011110000111100011100000010111111100000000001111000000000;
//    image <= 256'b0000000000001111000000000000111100000000000011110000000000001111000000000000111000000000000011100000000000011100000000000011100000000000011110000000000011111000000000011111000000000111111100000000111101110000001111100111000011111000001110001110000000000000;
//    image <= 256'b0000000111111100000000000000111000000000000001110000000000000011000000000000001100000000000000110000000000001111000000000000111000000000111111000000001111100000001111111000000011110000000000001110000000000000111000000000000001111111111111000000011111100000;
//    image <= 256'b0111111111000000111100001110000011000000011000000000000001100000000000001110000000000000110000000000000111111000000000000111111000000000000011110000000000000011000000000000001100000000000000110000000000001110000000000000110000000000111110000000000001110000;
//    image <= 256'b0000000111100000000000111000000000000111100000000000111110000000000111011000000000111001100000000011100111000000011000001100000001100000110000001110000011100000110000000110000011000000011111111100000111111100111111111111110000000000000111000000000000001000;
//    image <= 256'b0000111111111111001111000000000011111000000000000000000000000000000000000000000011000000000000001111111110000000000001111110000000000000111100000000000000111000000000000001110000000000000011000000000000011100000000000001110000000000011110000000000011100000;
//    image <= 256'b0000011110000000000111110000000000111100000000000111100000000000011100000000000011100000000000001110000001111000110011111111111011111110000001111111000000000011111000000000011111110000000111101111111111111100111000110000000001111000000000000001110000000000;
//    image <= 256'b0011111111100000111111001110000010000000011100000000000001110000000000000110000000000000011000000000000001100000000000000110000000000000011000000000001111100000000000011111111100000000111000000000000011100000000000001110000000000000110000000000000011000000;
//    image <= 256'b0000001110000011000001110000011100000110000001110000110000001110000011000001110000011100001110000001110001110000000111111111110000111111100000001111110000000000111011000000000011000110000000001110011110000000011100011100000000011000111100000000000011111000;
//    image <= 256'b0000011111110000001111100011100001110000000110001110000000011111110000000000111111000000000111101110000011111100011111111111100000011111001110000000000001110000000000000111000000000000111000000000000111000000000000011100000000000011100000000000000110000000;
