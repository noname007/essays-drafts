---
layout: post
title:  python 视频流提取人脸
date:   2021-02-26 12:50:54 +0800
categories:
- 技术
tags:
- Python
- 音视频
- 软件工具
description: opencv
---


#### upgrade pip ####

``` shell
pip install pip -U
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
```

c

``` python
import cv2    #引入cv2，也就是引入opencv的一些包和处理类，不然下面的一些操作都无法完成
def facedetect(windowname,camera_id):
#命名和打开摄像头
    cv2.namedWindow(windowname) # 创建一个已windowname为名字的窗口

    cap=cv2.VideoCapture(camera_id) # camera_id为设备摄像头的id，默认是0，如果有usb摄像头可能会变为1
    # Face Detection using Haar Cascades http://opencv-python-tutroals.readthedocs.io/en/latest/py_tutorials/py_objdetect/py_face_detection/py_face_detection.html?highlight=cascadeclassifier
    classfier=cv2.CascadeClassifier('/home/soul11201/.local/lib/python3.9/site-packages/cv2/data/haarcascade_frontalface_alt.xml') # 加载分类器，分类器位置可以自行更改，注意这里用opencv库文件夹下的绝对路径也不行，在库文件夹里找到这个文件复制到这个程序的同目录下，参考：https://blog.csdn.net/GAN_player/article/details/77993872

    color=(0,225,0)#人脸框的颜色，采用rgb模型，这里表示g取255，为绿色框

    while cap.isOpened():
        ok,frame=cap.read() # 读取一帧数据，ok表示摄像头读取状态，frame表示摄像头读取的图像矩阵mat类型
        if not ok:
            break
        # 灰度化在后面检测时可以降低计算量，cvtColor changing colorspace
        gray=cv2.cvtColor(frame,cv2.COLOR_BGR2GRAY)#图像灰度化，cv2.cvtColor(input_image, flag) where flag determines the type of conversion.

        # detectMultiScale完成人脸探测工作，returns the positions of detected faces as Rect(x,y,w,h)，x、y是左上角起始坐标，h、w是高和宽
        # grey是要识别的图像数据，scaleFactor图像缩放比例，可以理解为同一个物体与相机距离不同，其大小亦不同，必须将其缩放到一定大小才方便识别，该参数指定每次缩放的比例

        faceRects = classfier.detectMultiScale(gray, scaleFactor=1.2, minNeighbors=3,
                                               minSize=(32, 32))  # 利用分类器检测灰度图像中的人脸矩阵数，1.2和3分别为图片缩放比例和需要检测的有效点数

        if len(faceRects) > 0:  # 大于0则检测到人脸
            for faceRect in faceRects:  # 可能检测到多个人脸，用for循环单独框出每一张人脸
                x, y, w, h = faceRect  # 获取框的左上的坐标，框的长宽
                # cv2.rectangle()完成画框的工作，这里外扩了10个像素以框出比人脸稍大一点的区域，从而得到相对完整一点的人脸图像；cv2.rectangle()函数的最后两个参数一个用于指定矩形边框的颜色，一个用于指定矩形边框线条的粗细程度。
                cv2.rectangle(frame, (x - 10, y - 10), (x + w - 10, y + h - 10), color, 2)

        cv2.imshow(windowname, frame)  # 显示图像

        c = cv2.waitKey(10)
        if c & 0xFF == ord('q'):  # 退出条件
            break
    cap.release()  # 释放摄像头并销毁所有窗口
    cv2.destroyAllWindows()


if __name__ == '__main__':#主程序
    print ('face detecting... ')
    facedetect('facedetect',0)

```

ref[^1][^2][^3][^4][^5][^6][^7]

[^1]: https://mirrors.tuna.tsinghua.edu.cn/help/pypi/
[^2]: https://www.imooc.com/article/67961
[^3]: https://cloud.tencent.com/developer/article/1631566
[^4]: https://blog.csdn.net/GAN_player/article/details/77993872
[^5]: https://blog.csdn.net/mahoon411/article/details/106183362
[^6]: https://blog.csdn.net/weixin_39450145/article/details/104801730

[^7]: https://juejin.cn/post/6878578714834124808
