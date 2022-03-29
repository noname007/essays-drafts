---
layout: post
title:  NYOJ 矩形嵌套
date:   2013-06-23 21:25:14 +0800
---

比如说矩形(a,b),要是能嵌入到矩形（c,d)中,abcd都为矩形的边长，不防假设a<b,c<d

必须要a<c 且b<d.这一种情况。

这样,只需要把所有的矩形按其最长边进行一次升序排列。然后，按其短边构成的序列，找出最长升序子序列就可。


因为a<c,所以是严格的升序且还要b<d.所以在状态转移的是时候条件是：

`input_rec[i].a >input_rec[j].a && input_rec[i].b>input_rec[j].b`


总结起来算法就两步：


1。将矩形排序：取出每个矩形的最长边，按其升序排列，得到新的矩形的排列顺序。
2。最长上升子序列（严格的升序）：按照矩形的短边构成的一个最长上升子序列



```c

    #include<cstdio>
    #include<algorithm>
    using namespace std;
    #define S(a,b) a^=b; b^=a; a^=b
    #define MAX(a,b) a>b?a:b
    typedef struct{
        int a,b;
    }rec;
     
    int cmp(rec A,rec B)
    {
        return A.b<B.b;
    }
     
     
    int main()
    {
        int test,num[1005];
        rec input_rec[1005];
     
        scanf("%d",&test);
        while(test--)
        {
            int tmp,m=0;
            scanf("%d",&tmp);
            for(int i= 0; i < tmp; ++i)
            {
                scanf("%d%d",&input_rec[i].a,&input_rec[i].b);
                if(input_rec[i].a >input_rec[i].b)
                {
                    S(input_rec[i].a,input_rec[i].b);
                }
            }
            sort(input_rec,input_rec+tmp,cmp);
     
            for(int i = 0;i<tmp;++i)
            {
                num[i] =1;
                for(int j = 0;j<i;++j)
                {
                    if(input_rec[i].a >input_rec[j].a&&input_rec[i].b>input_rec[j].b)
                        num[i] = MAX(num[i],num[j]+1);
                }
                if(m<num[i])m=num[i];
            }
            printf("%d\n",m);
        }
     
        return 0;
    }
    
```
