
% % % Final optimisation 4
[w12fixedfloat , w12fixedinteger ,err] = fixedpoint1(w12,10,8,1);
[b12fixedfloat , b12fixedinteger ,err] = fixedpoint1(b12,15,12,1);
[w23fixedfloat , w23fixedinteger ,err] = fixedpoint1(w23,10,8,1);
[b23fixedfloat , b23fixedinteger ,err] = fixedpoint1(b23,13,11,1);

fpw12 = fopen("w12.txt","w");

 for i=1:7680
     temp = dec2bin(w12fixedinteger(i),10);
     fprintf(fpw12,"%s \n",temp);
 end


 fpw23 = fopen("w23.txt","w");

 for i=1:300
     temp = dec2bin(w23fixedinteger(i),10);
     fprintf(fpw23,"%s \n",temp);
 end

 fpb12 = fopen("b12.txt","w");

 for i=1:30
     temp = dec2bin(b12fixedinteger(i),15);
     fprintf(fpb12,"%s \n",temp);
 end

fpb23 = fopen("b23.txt","w");

 for i=1:10
     temp = dec2bin(b23fixedinteger(i),13);
     fprintf(fpb23,"%s \n",temp);
 end
        