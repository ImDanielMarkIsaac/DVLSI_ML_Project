[w12fixedfloat , w12fixedinteger ,err] = fixedpoint1(w12,11,8,1);
[w23fixedfloat , w23fixedinteger ,err] = fixedpoint1(w23,19,16,1);
[b12fixedfloat , b12fixedinteger ,err] = fixedpoint1(b12,11,8,1);
[b23fixedfloat , b23fixedinteger ,err] = fixedpoint1(b23,35,32,1);

% for i = 1:30
%     for j = 1:256
%         fprintf("assign w12[%d][%d] = 16'b%d",i,j,w12fixedinteger)


file = fopen("w12_verilog.txt","w");

 for i=1:256
     fprintf(file,"assign w12[%d][%d] = 16'b%d;\n",mod(i,30),floor(i/30),w12fixedinteger(i));
 end
        