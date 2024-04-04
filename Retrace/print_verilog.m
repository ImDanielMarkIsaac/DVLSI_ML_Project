% % Final optimisation 4
[w12fixedfloat , w12fixedinteger ,err] = fixedpoint1(w12,10,8,1);
[b12fixedfloat , b12fixedinteger ,err] = fixedpoint1(b12,15,12,1);
[w23fixedfloat , w23fixedinteger ,err] = fixedpoint1(w23,10,8,1);
[b23fixedfloat , b23fixedinteger ,err] = fixedpoint1(b23,13,11,1);

file = fopen("w12_verilog.txt","w");

 for i=1:7680
     if(w12fixedinteger(i) < 0)
        fprintf(file,"assign w12[%d][%d] = -10'd%d;\n",mod(i-1,30),floor((i-1)/30),abs(w12fixedinteger(i)));
     else
        fprintf(file,"assign w12[%d][%d] = 10'd%d;\n",mod(i-1,30),floor((i-1)/30),w12fixedinteger(i));
     end
 end


 file = fopen("w23_verilog.txt","w");

 for i=1:300
     if(w23fixedinteger(i) < 0)
        fprintf(file,"assign w23[%d][%d] = -10'd%d;\n",mod(i-1,10),floor((i-1)/10),abs(w23fixedinteger(i)));
     else
        fprintf(file,"assign w23[%d][%d] = 10'd%d;\n",mod(i-1,10),floor((i-1)/10),w23fixedinteger(i));
     end
 end

 file = fopen("b12_verilog.txt","w");

 for i=1:30
     if(b12fixedinteger(i) < 0)
        fprintf(file,"assign b12[%d] = -15'd%d;\n",i-1,abs(b12fixedinteger(i)));
     else
        fprintf(file,"assign b12[%d] = 15'd%d;\n",i-1,b12fixedinteger(i));
     end
 end

file = fopen("b23_verilog.txt","w");

 for i=1:10
     if(b23fixedinteger(i) < 0)
         fprintf(file,"assign b23[%d] = -13'd%d;\n",i-1,abs(b23fixedinteger(i)));
     else
        fprintf(file,"assign b23[%d] = 13'd%d;\n",i-1,b23fixedinteger(i));
     end
 end
        