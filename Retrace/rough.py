L = [1658036227 ,-3.283861e+08 ,-2.870523e+08 ,-2.759494e+08 ,-8.520068e+07 ,-3.863289e+08 ,-1.538640e+08 ,719291479 ,728697924 ,1129641494 ]
# print(bin(((1 << 11) - 1) & -5)[2:].zfill(11))
# Temp = ""
for i in L:
    print(hex(int(bin(((1 << 44) - 1) & i)[2:].zfill(44),2)))

# print(Temp)
    
# 62d3a00300000000,fffec6d39f5a8a3d7_74,fffeee3edfecd0ed2_70,fffef8d58b3e2afe_bcb,ffffaebf0d604dec_163,fffe8f916d956f64_3b8,ffff6d438c49d6d1_1cc,2adf845700000000,2b6f0c4400000000,4354f61600000000
# 62d3a00300000000,fffec6d39f5a8a3d7_00,fffeee3edfecd0ed2_00,fffef8d58b3e2afe_c00,ffffaebf0d604dec_180,fffe8f916d956f64_400,ffff6d438c49d6d1_200,2adf845700000000,2b6f0c4400000000,4354f61600000000
#                          2                       3                  4                      5                 6                      7                                                                 
# 0000000000062d3a003,00000000fffec6d39f5,00000000fffeee3edfe,00000000fffef8d58b3,00000000ffffaebf0d6,00000000fffe8f916d9,00000000ffff6d438c4,000000000002adf8457,000000000002b6f0c44,000000000004354f616

# 2 -> 1ff3c444394 -> 2195739394964
    
# MATLAB multiplies: 429496729 x -3283860588 




