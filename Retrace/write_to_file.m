fpw12 = fopen("b23.txt","w");

for i = 1:10
    % for j = 1:1
        temp = dec2bin(b23fixedinteger(i,1),35);
        fprintf(fpw12,"%s \n",temp);    
    end
% end