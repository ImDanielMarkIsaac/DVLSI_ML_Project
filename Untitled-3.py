# s = "Mul_1_out[{}] <= Mul_1_out[{}] + w12[{}][count]*image[count];"
# s = "Add_1_out[{}] <= Mul_1_out[{}] + b12[{}];"
# s = "Mul_2_out[{}] <= Mul_2_out[{}] + w23[{}][count] * ReLU_1_out[count];"
# s = "Add_2_out[{}] <= Mul_2_out[{}] + b23[{}];"
s = "assign Shifted_Mul_1_out[{}] = {Mul_1_out[{}],4'b0};"
for i in range(10):
    # print(s.format(i,i,i))
    print("assign Shifted_b23["+str(i)+"] = {b23["+str(i)+"],21'b0};")


# # A = [0x3fccd4,0x022c00,0x3fe37c,0x3ffa3d,0x3fcc70,0x3fb820,0x3ff63c,0x3fe7af,0x3fecaa,0x3fa79f,0x3ff254,0x3feb01,0x00c000,0x3fcfc2,0x3ff2d1,0x3fcefa,0x3fdb93,0x3fdb7a,0x3fdcd8,0x3fd265,0x3fc9ff,0x3ffa88,0x3ffbe6,0x3fd508,0x012200,0x025100,0x00ff00,0x3fdb7a,0x3fcd38,0x010600]
# A = [0xc0332c,0x022c00,0x3fe37c,0x3ffa3d,0x3fcc70,0x3fb820,0x3ff63c,0x3fe7af,0x3fecaa,0x3fa79f,0x3ff254,0x3feb01,0x00c000,0x3fcfc2,0x3ff2d1,0x3fcefa,0x3fdb93,0x3fdb7a,0x3fdcd8,0x3fd265,0x3fc9ff,0x3ffa88,0x3ffbe6,0x3fd508,0x012200,0x025100,0x00ff00,0x3fdb7a,0x3fcd38,0x010600]
# B = [0x01e61,0x0108f,0x00cdc,0x000bc,0x039ba,0x77697,0x01f08,0x0369e,0x7ff2e,0x00c7d,0x00ad0,0x7abb0,0x7f67b,0x00db4,0x03c62,0x7d11c,0x044dd,0x7ed15,0x00f0b,0x00998,0x7e23c,0x7f73a,0x7d44f,0x04c21,0x01f1a,0x7c6ad,0x00b2b,0x0226c,0x0290c,0x776a4]
# C = 0
# for i in range(1):
#     C += A[i]*B[i]

# print(hex(C))



# Mul_2_out[0] <= $signed(Mul_2_out[0]) + $signed(w23[0][count]) * $signed(ReLU_1_out[count]);
# Mul_2_out[1] <= $signed(Mul_2_out[1]) + $signed(w23[1][count]) * $signed(ReLU_1_out[count]);
# Mul_2_out[2] <= $signed(Mul_2_out[2]) + $signed(w23[2][count]) * $signed(ReLU_1_out[count]);
# Mul_2_out[3] <= $signed(Mul_2_out[3]) + $signed(w23[3][count]) * $signed(ReLU_1_out[count]);
# Mul_2_out[4] <= $signed(Mul_2_out[4]) + $signed(w23[4][count]) * $signed(ReLU_1_out[count]);
# Mul_2_out[5] <= $signed(Mul_2_out[5]) + $signed(w23[5][count]) * $signed(ReLU_1_out[count]);
# Mul_2_out[6] <= $signed(Mul_2_out[6]) + $signed(w23[6][count]) * $signed(ReLU_1_out[count]);
# Mul_2_out[7] <= $signed(Mul_2_out[7]) + $signed(w23[7][count]) * $signed(ReLU_1_out[count]);
# Mul_2_out[8] <= $signed(Mul_2_out[8]) + $signed(w23[8][count]) * $signed(ReLU_1_out[count]);
# Mul_2_out[9] <= $signed(Mul_2_out[9]) + $signed(w23[9][count]) * $signed(ReLU_1_out[count]);

# 15393264667564/7777

# 0x1fff9ed7454

# assign Trunc_ReLU_2_out[0] = ReLU_2_out[0:9];
# assign Trunc_ReLU_2_out[1] = ReLU_2_out[0:9];
# assign Trunc_ReLU_2_out[2] = ReLU_2_out[0:9];
# assign Trunc_ReLU_2_out[3] = ReLU_2_out[0:9];
# assign Trunc_ReLU_2_out[4] = ReLU_2_out[0:9];
# assign Trunc_ReLU_2_out[5] = ReLU_2_out[0:9];
# assign Trunc_ReLU_2_out[6] = ReLU_2_out[0:9];
# assign Trunc_ReLU_2_out[7] = ReLU_2_out[0:9];
# assign Trunc_ReLU_2_out[8] = ReLU_2_out[0:9];
# assign Trunc_ReLU_2_out[9] = ReLU_2_out[0:9];