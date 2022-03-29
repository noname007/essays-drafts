---
layout: post
title:  数L,在二进制下末尾0的个数k,与fft过程中的码位倒序
date:   2013-03-10 12:35:40 +0800
---

今天看树状数组，突然发现了这个东西，想了一想，然后用文字简要的证明了一下：

`2^k = L and (L xor (L　－　１) )`


    设i在二进制下从末尾数的第 k 位第一次不为0.
    先用 c = i^(i-1)则将第 k 位以左的数变为0，从k位往右都为1
    再用 i & c 因为c的末尾 k位为1,k位以左为0，i的末尾 k-1位为0,第k位为1，k位以左不知道。
    按位与后则剩余的数即为 2^(k - 1)


下面是程序：
```c
    #include <stdio.h>
    #include <math.h>
    #define NUM 16
                            
    //lowbit:计算当 i 在二进制下整数 末尾0的个数为k时求2^k 即 2^k = lowBit(i)
                            
    //设i在二进制下从末尾数的第 k 位第一次不为0.
    //先用 c = i^(i-1)则将第 k 位以左的数变为0，从k位往右都为1
    //再用 i & c 因为c的末尾 k位为1,k位以左为0，i的末尾 k-1位为0,第k位为1，k位以左不知道。
    //按位与后则剩余的数即为 2^(k - 1),
                            
    //从而能计算出当 i 在二进制下整数 末尾0的个数为k时求2^k 即 2^k = lowBit(i)
    //要算k为多少只需再以2为底进行取余即可。 
    int lowBit(int i){
        return i&(i^(i-1));
    }
                            
    int main(int argc, char *argv[])
    {
                                
        for(int i = 1;i < NUM + 1;++i){
            printf("%d:\t%d\n",i,(int)log2(lowBit(i)));
        }
        return 0;
    }

```
在解决完这个问题后，我突然想到了，一个问题，按照这个方法，改改程序，我就可以求出ｆｆｔ里面的那个码位倒序这个过程了。


代码如下：ｆｆｔ中的码位倒序代码, 当然也可以一位一位的去求但是当i为2的k次幂时就会比较费时，至少能起到一个常数系数的优化：
```
    #include <stdio.h>
    #include <math.h>
    #define NUM 16
    #define NUM_WEI 4
               
    int lowBit(int i){
        return i&(i^(i-1));
    }
              
    int ma_wei_dao_xu(int k){
        int l;
        int sum = 0;
        while(k){
                      
            l = lowBit(k);
                      
            sum += (int)pow(2,NUM_WEI - log2(l) - 1);
                      
            k &= (NUM  - l * 2);
        }
        return sum;
    } 
              
              
    int main(int argc, char *argv[])
    {
                  
        for(int i = 0;i < NUM;++i){
            printf("%d:\t%d\n",i,ma_wei_dao_xu(i));
        }
        return 0;
    }

```

后续：

刚才吃饭的时候想了一下以4位数来说节省的时间为C(1,4) + 2*C(2,4) +3* C(3,4) + 4*C(4,4);

对于为N位的二进制数来说总的时间为：  C(1,N) + 2*C(2,N) +.....+ (N-1)*C(N-1,N) + N*C(N,N);

因为节剩的总 时间就为0的总个数。  C(m，N)其实就暗含了，N位二进制中包含m个零的数的个数，包含的零的个数为：m*C(m,N); 

