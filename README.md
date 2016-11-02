# QrCodeScan
使用系统的AVMetadataObject类实现二维码扫描
有关二维码的介绍，我这里不做过多说明， 可以直接去基维百科查看.
IOS7之前，开发者进行扫码编程时，一般会借助第三方库。
常用的是ZBarSDKa和ZXingObjC.
IOS7之后，系统的AVMetadataObject类中，为我们提供了解析二维码的接口。
经过测试，使用原生API扫描和处理的效率非常高，远远高于第三方库。
