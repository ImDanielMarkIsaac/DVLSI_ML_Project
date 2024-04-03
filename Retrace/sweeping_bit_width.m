% [w12fixedfloat , w12fixedinteger ,err] = fixedpoint1(w12,11,8,1);
% [w23fixedfloat , w23fixedinteger ,err] = fixedpoint1(w23,11,8,1);
% [b12fixedfloat , b12fixedinteger ,err] = fixedpoint1(b12,11,8,1);
% [b23fixedfloat , b23fixedinteger ,err] = fixedpoint1(b23,11,8,1);

%w12
intbits_needed(1) = length(dec2bin(floor(abs(max(w12,[],"all")))))+1;
intbits_needed(2) = length(dec2bin(floor(abs(min(w12,[],"all")))))+1;
min_int_bits = max(intbits_needed)

for i = 1:32
    [w12fixedfloat , w12fixedinteger ,err] = fixedpoint1(w12,min_int_bits+i,i,1);
    error_val_w12(i) = mean(abs(w12 - w12fixedfloat),"all");
end

%w23
intbits_needed(1) = length(dec2bin(floor(abs(max(w23,[],"all")))))+1;
intbits_needed(2) = length(dec2bin(floor(abs(min(w23,[],"all")))))+1;
min_int_bits = max(intbits_needed)

for i = 1:32
    [w32fixedfloat , w23fixedinteger ,err] = fixedpoint1(w23,min_int_bits+i,i,1);
    error_val_w23(i) = mean(abs(w23 - w23fixedfloat),"all");
end

%b12
intbits_needed(1) = length(dec2bin(floor(abs(max(b12,[],"all")))))+1;
intbits_needed(2) = length(dec2bin(floor(abs(min(b12,[],"all")))))+1;
min_int_bits = max(intbits_needed)

for i = 1:32
    [b12fixedfloat , b12fixedinteger ,err] = fixedpoint1(b12,min_int_bits+i,i,1);
    error_val_b12(i) = mean(abs(b12 - b12fixedfloat),"all");
end


%b23
intbits_needed(1) = length(dec2bin(floor(abs(max(b23,[],"all")))))+1;
intbits_needed(2) = length(dec2bin(floor(abs(min(b23,[],"all")))))+1;
min_int_bits = max(intbits_needed)

for i = 1:32
    [b23fixedfloat , b23fixedinteger ,err] = fixedpoint1(b23,min_int_bits+i,i,1);
    error_val_b23(i) = mean(abs(b23 - b23fixedfloat),"all");
end

%ReLU
intbits_needed(1) = length(dec2bin(floor(abs(max(0.1,[],"all")))))+1;
intbits_needed(2) = length(dec2bin(floor(abs(min(0.1,[],"all")))))+1;
min_int_bits = max(intbits_needed)

for i = 1:32
    [slpfixedfloat , slpfixedinteger ,err] = fixedpoint1(0.1,min_int_bits+i,i,1);
    error_val_slp(i) = mean(abs(0.1 - slpfixedfloat),"all");
end