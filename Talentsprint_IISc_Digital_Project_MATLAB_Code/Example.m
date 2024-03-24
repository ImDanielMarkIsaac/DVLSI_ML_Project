% clear all;
% weights1 = [2.3,  3,  4, 5.6,  1.2,  -2.1];
% weights2 = [15.3, 31, 4, 15.6, -11.2,-21.1];
% x1 = [1.2, 3.2, 4.3, -2.2, -10.2, -7.3];
%
% [weights1floatfixed , weights1fixedinteger , error1] = fixedpoint1(weights1,16,8,1);
% [weights2floatfixed , weights2fixedinteger , error2] = fixedpoint1(weights2,16,7,1);
% [x1floatfixed , x1fixedinteger , error3] = fixedpoint1(x1,16,8,1);
%
% outputset1 = weights1*(x1');
% outputset2 = weights2*(x1');
%
% outputset1floatfixed = weights1floatfixed*(x1floatfixed');
% outputset2floatfixed = weights2floatfixed*(x1floatfixed');
%
% outputset1fixedinteger = weights1fixedinteger*(x1fixedinteger');
% outputset2fixedinteger = weights2fixedinteger*(x1fixedinteger');
%
% finaloutput = outputset1 + outputset2;
% finaloutputfloatfixed = outputset1floatfixed+outputset2floatfixed;
%
% finaloutputfixedinteger = outputset1fixedinteger+outputset2fixedinteger;
%
% fpw1 = fopen("weights1.txt","w");
% fpw2 = fopen("weights2.txt","w");
% fpw3 = fopen("datamemory.txt","w");
%
% for i=1:1:6
%     fprintf(fpw1,"%d\n",(weights1fixedinteger(i)));
%     fprintf(fpw2,"%d\n",(weights2fixedinteger(i)));
%     fprintf(fpw3,"%d\n",(x1fixedinteger(i)));
% end



clear all;
weights1=[2.3 , 3,4 ,5.6,1.2,-2.1];
weights2=[15.3 , 31,4 ,15.6,-11.2,-21.1];

x1 = [1.2,3.2,4.3,-2.2,-10.2,-7.3];


[weights1floatfixed , weights1fixedinteger , error1]=fixedpoint1(weights1,16,8,1);
 [weights2floatfixed , weights2fixedinteger , error2]=fixedpoint1(weights2,16,7,1);
 [x1floatfixed , x1fixedinteger , error3]=fixedpoint1(x1,16,8,1);

 outputset1 = weights1*(x1'); %Q(8+8)=Q16
 outputset2 = weights2*(x1'); %Q(8+7)=Q15

 outputset1floatfixed = weights1floatfixed*(x1floatfixed');
 outputset2floatfixed = weights2floatfixed*(x1floatfixed');


 outputset1fixedinteger = weights1fixedinteger*(x1fixedinteger');
 outputset2fixedinteger = weights2fixedinteger*(x1fixedinteger');

 finaloutput = outputset1+outputset2;
 finaloutputfloatfixed = outputset1floatfixed+outputset2floatfixed;

 finaloutputfixedinteger1 = outputset1fixedinteger+outputset2fixedinteger*2; %Q16 + Q16
 finaloutputfixedinteger = outputset1fixedinteger/2+outputset2fixedinteger; %Q15 + Q15

 fpw1 = fopen("weights1.txt","w");
 fpw2 = fopen("weights2.txt","w");
 fpw3 = fopen("datamemory.txt","w");

 for i=1:1:6
     fprintf(fpw1,"%d\n",(weights1fixedinteger(i)));
     fprintf(fpw2,"%d\n",(weights2fixedinteger(i)));
     fprintf(fpw3,"%d\n",(x1fixedinteger(i)));
 end



