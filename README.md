# CloudInfinite sdk for ios

### 相关资源

* SDK源码以及demo 请参考： [CloudInfinite iOS SDK](https://github.com/tencentyun/cloud-Infinite-sdk-ios.git)
* SDK接口与参数文档请参考： [数据万象 SDK API](https://cloud.tencent.com/document/product/460/36540)
* 云闪图片分发介绍请参考：[云闪图片分发](https://cloud.tencent.com/solution/image-delivery)
* TPG功能介绍：[TPG](https://cloud.tencent.com/document/product/460/43680)
* AVIF功能介绍：[AVIF](https://cloud.tencent.com/document/product/460/60527)
* SDK更新日志请参考：[更新日志](#changelog)

## 文档概览

* [快速入门](#1)
* [图片转换](#2)
* [加载TPG图片](#3)
* [加载AVIF图片](#4)
* [与SDWebImage配合使用](#5)


<div id="1">
</div>

## 快速入门

为了使开发者更方便快速是使用数据万象和云闪图片分发功能，我们提供了5个SDK，开发者可根据具体需求进行选择。

序号|模块|功能
--:|:--:|:--
1|CloudInfinite(默认模块)|该模块包含数据万象对图片的基础操作，并支持各个操作可以相互组合，并构建URL进行网络请求；
2|Loader |使用CIImageLoadRequest实例，请求网络图片并返回图片data数据；
3|TPG|解码TPG格式图片并显示；即可用于显示普通图片，也可用于TPG图；
4|AVIF|解码 AVIF 格式图片并显示，可用于显示普通图片，也可用于 AVIF 图（v1.3.8及以上）。
5|SDWebImage-CloudInfinite|依赖于SDWebImage、CloudInfinite模块，提供了数据万象图片基础操作功能；


CloudInfinite 模块主要功能：
* 包含数据万象的图片基础操作，主要有：图片缩放、剪裁、旋转、格式转换、质量变换、高斯模糊、锐化、水印、获取图片主题色等；
* 将每一个操作封装为一个TransformItem，而且支持各个基础操作可以组合使用，并将组合好的操作集合构建出可以直接进行网络请求的URL;

#### 第一步 安装 SDK CloudInfinite模块

推荐使用cocoapod方式（下面涉及集成相关模块步骤一致，不再重复）
在您工程Podfile文件中使用：

```
    pod 'CloudInfinite'
```
在终端执行安装命令：
```
    pod install
```


#### 第二步 构建CIImageLoadRequest实例

1. 在使用CloudInfinite 构建具有数据万象功能的图片url时，首先需要实例化 CloudInfinite类。

```
    CloudInfinite * cloudInfinite = [CloudInfinite new];
```

2. 实例化图片转换类 CITransformation，并设置相关操作，这里以TPG为例；更多功能见：[图片转换](#2)。

```
    CITransformation * transform = [CITransformation new];
    [transform setFormatWith:CIImageTypeTPG options:CILoadTypeUrlFooter];
```

3. 使用cloudInfinite 实例构建具有万象功能的图片url；
* 同步方式构建：
```
    CIImageLoadRequest * imageloadRequest = [cloudInfinite requestWithBaseUrl:@"图片链接" transform:transform];
    // 图片url
    NSURL * imageURL = imageloadRequest.url;
    // header参数
    NSString * heaer = imageloadRequest.header;
```

* 异步方式构建
```
    [cloudInfinite requestWithBaseUrl:@"图片链接" transform:transform request:^(CIImageLoadRequest * _Nonnull request) {
        // 图片url
        request.url;
        // header参数
        request.header;
    }];
```
>？
> CIImageLoadRequest 的header参数仅在图片格式转换时 options 指定为CILoadTypeAcceptHeader时有值；
> 在使用自定义loader请求图片时，如果需要使用到header，则header需要拼接为：
```
    NSDictionary * header = @{@"accept":[NSString stringWithFormat:@"image/%@",request.header]};
```

#### 第三步 构建成功CIImageLoadRequest 实例后，使用CloudInfinite/Loader 模块进行图片加载；
集成 CloudInfinite/Loader模块：

```
    pod 'CloudInfinite/Loader' 
```

* 请求图片NSData数据 - 适用于请求TPG、AVIF图片（需集成TPG、AVIF解码模块）或者需要对图片二进制数据进行额外处理的图片；
```
    // request 为上一步构建成功的CIImageLoadRequest实例；
    [[CIImageLoader shareLoader] loadData:request loadComplete:^(NSData * _Nullable data, NSError * _Nullable error) {

     // data：请求到的图片data数据；
    }];
```

* 请求并显示图片 - 适用于请求普通图片
```
    // 传入图片控件 imageView 以及 构建成功的CIImageLoadRequest实例；
     [[CIImageLoader shareLoader]display:imageView loadRequest:request placeHolder:nil loadComplete:^(NSData * _Nullable data, NSError * _Nullable error) {
    // data：请求到的图片data数据；
    }];
```


<div id="2">
</div>

## 图片转换

1. 自适应加载 CIResponsiveTransformation
* 根据当前imageView控件尺寸自动调整图片大小；
* 根据系统版本自动调整最优图片格式，iOS11以下加载原格式，iOS11及以上加载heic格式；

```
    CIResponsiveTransformation * sTransform = [[CIResponsiveTransformation alloc]initWithView:imageView 
                                                                                    scaleType:ScaleTypeAUTOFit]
```

2. CloudInfinite 模块中的 CITransformation类封装了万象的图片转换功能，其中包含如下功能：


* [缩放](#ci_suofang)
* [裁剪](#ci_caijian)
* [旋转](#ci_xuanzhuan)
* [格式转换](#ci_geshizhuanhuan)
* [质量变换](#ci_zhiliangbianhuan)
* [高斯模糊](#ci_gaosimohua)
* [锐化](#ci_ruihua)
* [水印](#ci_shuiyin)
* [获取图片主题色](#ci_zhutise)
* [去除图片元信息](#ci_yuanxinxi)


<div id="ci_suofang"><div>

### 一 缩放
相关链接：[缩放功能接口](https://cloud.tencent.com/document/product/460/36540)
在使用万象图片转换功能时首先实例化 CITransformation 类，下面所有操作一致，不再重复；
```
    CITransformation * transform = [CITransformation new];
```
* 图片百分比缩放
```
    // 以缩放百分之50为例
    [transform setZoomWithPercent:50 scaleType:ScalePercentTypeALL];

    // scaleType 可以指定如下类型：
        // 仅缩放宽度，高度不变
        ScalePercentTypeOnlyWidth = 1, 
        // 仅缩放高度，宽度不变
        ScalePercentTypeOnlyHeight,
        //指定图片的宽高同时缩放
        ScalePercentTypeALL,
```

* 指定宽高缩放
```
    // 以宽高都指定为100 并且缩放类型为ScaleTypeAUTOFit等比缩放
    [transform setZoomWithWidth:100 height:100 scaleType:ScaleTypeAUTOFit];

    // 在指定宽高缩放时，scaleType可以指定的类型：
        // 忽略原图宽高比例，指定图片宽度为 Width，高度为 Height ，强行缩放图片，可能导致目标图片变形
        ScaleTypeAUTOFill = 1,
        
        // 限定缩略图的宽度和高度的最大值分别为 Width 和 Height，进行等比缩放
        ScaleTypeAUTOFit,
        
        // 限定缩略图的宽度和高度的最小值分别为 Width 和 Height，进行等比缩放
        ScaleTypeAUTOFITWithMin,
        
        // 指定目标图片宽度为 Width，高度传入0， 高度等比压缩
        ScaleTypeOnlyWidth,
        
        // 指定目标图片高度为 Height，宽度传0，宽度等比压缩
        ScaleTypeOnlyHeight
```

* 限制像素缩放-等比缩放图片，缩放后的图像，总像素数量不超过指定数量
```
    // 缩放后的图像，总像素数量不超过1000 为例；
    [transform setZoomWithArea:1000]; 
```

<div id="ci_caijian"><div>

### 二 裁剪
相关链接：[裁剪功能接口](https://cloud.tencent.com/document/product/460/36541)

* 普通裁剪
```
    // 指定目标图片宽度、高度、相对于图片左上顶点水平向右偏移、相对于图片左上顶点水平向下偏移 进行裁剪 为例；
    [transform setCutWithWidth:100 height:100 dx:30 dy:30];
```

* 内切圆裁剪功能，radius 是内切圆的半径，取值范围为大于0且小于原图最小边一半的整数。内切圆的圆心为图片的中心。图片格式为 gif 时，不支持该参数。
```
    // 指定半径为100 为例
    [transform setCutWithIRadius:100];
```

* 圆角裁剪功能，radius 为图片圆角边缘的半径，取值范围为大于0且小于原图最小边一半的整数。圆角与原图边缘相切。图片格式为 gif 时，不支持该参数。
```
    // 指定圆角半径 100为例
    [transform setCutWithRRadius:100];
```

* 缩放裁剪 
    相关链接：[gravity 介绍](https://cloud.tencent.com/document/product/460/36541#.E4.B9.9D.E5.AE.AB.E6.A0.BC.E6.96.B9.E4.BD.8D.E5.9B.BE)
```
    // 指定宽高缩放裁剪，如果为0 则不变；
    [transform setCutWithCrop:100 height:100];

    // 指定宽高以及gravity缩放裁剪；
    [transform setCutWithCrop:100 height:100 gravity:CIGravityCenter];
```

* 人脸智能裁剪,基于图片中的人脸位置进行缩放裁剪。目标图片的宽度为 Width、高度为 Height。
``` 
    // 裁剪人脸并宽高指定100缩放为例；
    [transform setCutWithScrop:100 height:100];
```

<div id="ci_xuanzhuan"><div>

### 三 旋转
相关链接：[旋转功能接口](https://cloud.tencent.com/document/product/460/36542)

* 普通旋转：图片顺时针旋转角度，取值范围0 - 360 ，默认不旋转。
```
    // 以旋转45度为例；
    [transform setRotateWith:45];
```

* 自适应旋转：根据原图 EXIF 信息将图片自适应旋转回正。
```
    [transform setRotateAutoOrient];
```
<div id="ci_geshizhuanhuan"><div>

### 四 格式转换
相关链接：[格式转换接口](https://cloud.tencent.com/document/product/460/36543)
* 格式转换：目标缩略图的图片格式可为：tpg、jpg、bmp、gif、png、heif、webp、yjpeg、avif 等，其中 yjpeg 为数据万象针对 jpeg 格式进行的优化，本质为 jpg 格式；缺省为原图格式。
   
1. 使用图片格式转换，如果需要转为TPG格式，则需要依赖 'CloudInfinite/TPG' 模块；

```
    pod 'CloudInfinite/TPG'
```
2. 使用图片格式转换，如果需要转为AVIF格式，则需要依赖 'CloudInfinite/AVIF' 模块；

```
    pod 'CloudInfinite/AVIF'
```

3. 使用图片格式转换，如果需要转为WEBP格式，则需要依赖 'SDWebImageWebPCoder' 库；
```
    pod 'SDWebImageWebPCoder'
```

> 注意
> 使用heic格式，需要在iOS11及以上，并且不支持gif格式图片转为heif。
```
    // 以转为JPG为例
    [transform setFormatWith:CIImageTypeJPG];

    // 指定传参方式：
    [transform setFormatWith:CIImageTypeTPG options:CILoadTypeUrlFooter];
```

CILoadTypeEnum:
```
     // 加载类型 方式一：带 accept 头部 accept:image/ ***
     CILoadTypeAcceptHeader = 0,
        
     // 加载类型 方式二：在 url 后面中拼接 imageMogr2/format/ ***
     // 如果需要方式二，则使用该值；不传默认为第一种方式
     CILoadTypeUrlFooter,
```

> 注意
> 当指定为CILoadTypeAcceptHeader 方式传参时，并且组合了其他的转换则header失效，并且在sdk内部自动转换为footer的方式

    


* gif 格式优化： 只针对原图为 gif 格式，对 gif 图片格式进行的优化，降帧降颜色。
    FrameNumber=1，则按照默认帧数30处理，如果图片帧数大于该帧数则截取。
    FrameNumber 取值( 1,100 ]，则将图片压缩到指定帧数 （FrameNumber）。
```
    [transform setCgif:50];
```

* 输出为渐进式 jpg 格式
Mode 可为0或1。0：表示不开启渐进式；1：表示开启渐进式。该参数仅在输出图片格式为 jpg 格式时有效。如果输出非 jpg 图片格式，会忽略该参数，默认值0。

```
    [transform setInterlace:YES];
```

<div id="ci_zhiliangbianhuan"><div>

### 五 质量变换
相关链接：[质量变换接口](https://cloud.tencent.com/document/product/460/36544)
```
    // 以图片的绝对质量变换为 60为例
    // type 为变换类型，下面具体介绍
    [transform setQualityWithQuality:60 type:CIQualityChangeAbsolute];
```

> 注意
> 质量变换仅针对JPG和WEBP格式图片。

数据万象提供三种变换类型：绝对变换、相对变换、最低质量变换，其中绝对变换分为强制制定制定和不指定两种，如下：
```
   // 图片的绝对质量，取值范围0 - 100 ，默认值为原图质量；
    CIQualityChangeAbsolute = 1,
    
    // 图片的绝对质量，取值范围0 - 100 ，强制使用指定值，例如：90!。
    CIQualityChangeAbsoluteFix,
    
    // 图片的相对质量，取值范围0 - 100 ，数值以原图质量为标准。例如原图质量为80，将 rquality 设置为80后，得到处理结果图的图片质量为64（80x80%）
    CIQualityChangeRelative,
    
    // 图片的最低质量，取值范围0 - 100 ，设置结果图的质量参数最小值。
    // 例如原图质量为85，将 lquality 设置为80后，处理结果图的图片质量为85。
    // 例如原图质量为60，将 lquality 设置为80后，处理结果图的图片质量会被提升至80。
    CIQualityChangeLowest,
```

<div id="ci_gaosimohua"><div>

### 六 高斯模糊
相关链接：[高斯模糊接口](https://cloud.tencent.com/document/product/460/36545)
* 高斯模糊功能
模糊半径，取值范围为1 - 50;
正态分布的标准差，必须大于0;

```
    // 模糊半径20 ,正态分布的标准差20 为例
    [transform setBlurRadius:20 sigma:20];
```

> 注意
> 图片格式为 gif 时，不支持该参数。

<div id="ci_ruihua"><div>

### 七 锐化
相关链接：[锐化接口](https://cloud.tencent.com/document/product/460/36546)
* 图片锐化功能，value 为锐化参数值，取值范围为10 - 300间的整数。参数值越大，锐化效果越明显。（推荐使用70）
```
    // 以锐化值100 为例
    [transform setSharpenWith:10];
```
<div id="ci_shuiyin"><div>

### 八 水印

相关链接：[gravity](https://cloud.tencent.com/document/product/460/6951#1)
相关链接：[图片水印接口](https://cloud.tencent.com/document/product/460/6930)
相关链接：[文字水印接口](https://cloud.tencent.com/document/product/460/6951)

* #### 图片水印
```
    //imageUrl 水印图片地址
    // gravity 文字水印位置，九宫格位置（参考九宫格方位图 ），默认值 SouthEast
    // dx 水平（横轴）边距，单位为像素，缺省值为0
    // dy 垂直（纵轴）边距，单位为像素，默认值为0
    // blogo 水印图适配功能，适用于水印图尺寸过大的场景（如水印墙）。共有两种类型：
    ///    当 blogo 设置为1时，水印图会被缩放至与原图相似大小后添加
    ///    当 blogo 设置为2时，水印图会被直接裁剪至与原图相似大小后添加
    [tran setWaterMarkWithImageUrl:@"http://tpg-1253653367.cos.ap-guangzhou.myqcloud.com/google.jpg" gravity:0 dx:0 dy:0 blogo:0];
```

* #### 文字水印

```
    // text 水印内容
    // font 水印字体
    // color 字体颜色，默认值为 #3D3D3D
    // dissolve 文字透明度，取值1 - 100 ，默认90
    // gravity 文字水印位置，默认值 SouthEast
    // dx 水平（横轴）边距，单位为像素，缺省值为0
    // dy 垂直（纵轴）边距，单位为像素，默认值为0
    // batch 平铺水印功能，可将文字水印平铺至整张图片。当 batch 设置为1时，开启平铺水印功能
    // degree 文字水印的旋转角度设置，取值范围为0 - 360，默认0
    [transform setWaterMarkText:@"腾讯云·万象优图" font:nil textColor:nil dissolve:90 gravity:CIGravitySouth dx:100 dy:100 batch:YES degree:45];
```
<div id="ci_zhutise"><div>

### 九 获取图片主题色
相关链接：[获取主题色接口](https://cloud.tencent.com/document/product/460/6928)
* 腾讯云数据万象通过 imageAve 接口获取图片主色调信息。
```
    [transform setViewBackgroudColorWithImageAveColor:YES]
```

<div id="ci_yuanxinxi"><div>

### 十 去除图片元信息
相关链接：[去除图片元信息接口](https://cloud.tencent.com/document/product/460/36547)
* 腾讯云数据万象通过 imageMogr2 接口可去除图片元信息，包括 exif 信息。
```
    [transform setImageStrip];
```

<div id="3">
</div>

## 加载TPG图片

### 方式一 加载网络TPG图片

1. 集成 CloudInfinite；
```
    pod 'CloudInfinite'
```

2. 在CloudInfinite模块中构建出请求TPG格式图片的链接，然后[与SDWebImage配合使用](#4)加载网络TPG图片

```
    // 实例化CloudInfinite，用来构建请求图片请求连接；
    CloudInfinite * cloudInfinite = [CloudInfinite new];

    // 根据用户所选万象基础功能options 进行构建CIImageLoadRequest；
    CITransformation * transform = [CITransformation new];
    [transform setFormatWith:CIImageTypeTPG options:CILoadTypeAcceptHeader];

    // 构建图片CIImageLoadRequest
    [cloudInfinite requestWithBaseUrl:@"图片链接" transform:transform request:^(CIImageLoadRequest * _Nonnull request) {
        // request 构建成功的 CIImageLoadRequest 实例，
    }];
```

### 方式二 使用TPG模块加载TPG图片Data数据（支持TPG动图加载，无需额外处理）
1. 集成 TPG 模块；
```
    pod 'CloudInfinite/TPG'
```
2. 如果已经获取到TPG图片data数据，则直接使用TPG模块UIImageView+TPG类进行解码并显示；
```
    [self.tpgImageView setTpgImageWithData:data loadComplete:^(NSData * _Nullable data，UIImage * _Nullable image, NSError * _Nullable error) {
        
}]; 
```
        
<div id="4">
</div>

## 加载AVIF图片

### 方式一：加载网络 AVIF 图片

>! CloudInfinite SDK 版本需要大于等于 v1.3.8。

1. 首先集成 CloudInfinite。

```
    pod 'CloudInfinite'
```

2. 在 CloudInfinite 模块中构建出请求 AVIF 格式图片的链接，然后与 [SDWebImage](https://cloud.tencent.com/document/product/460/47733) 配合使用，加载网络 AVIF 图片。

**Objective-C**
```
    // 实例化 CloudInfinite，用来构建请求图片请求连接；
    CloudInfinite * cloudInfinite = [CloudInfinite new];

    // 根据用户所选万象基础功能 options 进行构建 CIImageLoadRequest；
    CITransformation * transform = [CITransformation new];
    [transform setFormatWith:CIImageTypeAVIF options:CILoadTypeUrlFooter];

    // 构建图片 CIImageLoadRequest
    [cloudInfinite requestWithBaseUrl:@"图片链接" transform:transform request:^(CIImageLoadRequest * _Nonnull request) {
        // request 构建成功的 CIImageLoadRequest 实例，
    }];
```

**swift**
```
    // 实例化 CloudInfinite，用来构建请求图片请求连接；
    let cloudInfinite = CloudInfinite();

    // 根据用户所选的数据万象基础功能 options 进行构建 CIImageLoadRequest；
    let transform = CITransformation();
    transform.setFormatWith(CIImageFormat.typeAVIF, options: CILoadTypeEnum.urlFooter);

    // 构建图片 CIImageLoadRequest
    cloudInfinite.request(withBaseUrl: "图片链接", transform: transform) { (request) in
        // request 构建成功的 CIImageLoadRequest 实例，
    }  
```

### 方式二：使用 AVIF 模块加载本地 AVIF 图片

使用 AVIF 模块加载 AVIF 图片 Data 数据，支持加载 AVIF 动图，无需额外处理。

1. 首先集成 AVIF 模块。
```
    pod 'CloudInfinite/AVIF'
```
2. 如果已经获取到 AVIF 图片 data 数据，则直接使用 AVIF 模块 UIImageView+AVIF 类进行解码并显示。
   **Objective-C**
```
    [self.avifImageView setAvifImageWithData:data loadComplete:^(NSData * _Nullable data，UIImage * _Nullable image, NSError * _Nullable error) {

    }];
```
   **swift**
```
    imageView.setAvifImageWith(data) { (data, image, error) in

    }
```


<div id="5">
</div>



## 与SDWebImage配合使用

* #### 与SDWebImage 配合使用数据万象图片基础操作（除TPG、AVIF、WEBP相关功能外）；

1. 在使用数据万象图片基础操作时需要集成 CloudInfinite/SDWebImage-CloudInfinite 模块；
```
    pod 'CloudInfinite/SDWebImage-CloudInfinite'
```

2. 使用（UIImageView+CI： 模仿SDWebImage调用风格，封装了一组可以传入transform的方法）
    
```
    实例化CITransformation 类并添加需要使用的操作；
    CITransformation * transform = [CITransformation new];

    // 加入缩放功能
    [transform setZoomWithPercent:50 scaleType:ScalePercentTypeOnlyWidth];

    // 加入圆角功能
    [transform setCutWithRRadius:100];

    // 根据实际需求加入相应的功能
    ...

    // 使用UIImageView+CI类种方法，加载图片
    [self.imageView sd_CI_setImageWithURL:[NSURL URLWithString:@"图片链接"] transformation:transform];
```

* ### 与SDWebImage 配合使用数据万象TPG功能（支持TPG动图加载，无需额外处理）；

#### 准备工作
    在使用TPG功能时 SDWebImage-CloudInfinite 需要依赖CloudInfinite/TPG 模块
```
    pod 'CloudInfinite/TPG'
```

#### 加载TPG图片
SDWebImage-CloudInfinite提供了两种加载TPG图片的方式；

##### 方式一 调用 ```UIImageView+CI``` 加载TPG
```
    // 构建 CITransformation实例
    CITransformation * tran = [CITransformation new];

    // 设置TPG格式以及传参方式
    [tran setFormatWith:CIImageTypeTPG options:CILoadTypeUrlFooter];

    // 调用UIImageView+CI 类种方法，加载图片
    [self.imageView sd_CI_setImageWithURL:[NSURL URLWithString:@"图片链接"] transformation:transform];
```

##### 方式二 全局配置加载TPG 
###### 使用场景
1. 如果整个项目都需要使用TPG，或为已有项目接入TPG；
2. 或者某些固定模式的图片链接需要使用TPG;

###### 具体使用
```
    // 在项目启动时给CIDownloaderConfig添加需要使用TPG图片的链接正则表达式；满足这个正则的图片链接都使用TPG格式加载；
    // 所有图片都使用TPG加载
    [[CIDownloaderConfig sharedConfig] addTPGRegularExpress:@"http(s)?:.*" paramsType:CILoadTypeUrlFooter];

    // 如果有的链接不需要使用TPG，给CIDownloaderConfig 添加排除的正则；
    // 请求图片主题色排除
    [[CIDownloaderConfig sharedConfig] addExcloudeTPGRegularExpress:@"http(s)?:.*imageAve"];
```
* ### 与SDWebImage 配合使用数据万象WEBP功能（支持WEBP动图加载，无需额外处理）；
#### 准备工作
在使用WEBP功能时 SDWebImage-CloudInfinite 需要依赖 SDWebImageWebPCoder 库；
```
    pod 'SDWebImageWebPCoder'
```

#### 加载WEBP图片
```
    // 实例化 CITransformation 类
    CITransformation * tran = [CITransformation new];
    // 设置转换为webp格式
    [tran setFormatWith:CIImageTypeWEBP options:CILoadTypeUrlFooter];
    // 加载图片
    [self.imageView sd_CI_setImageWithURL:[NSURL URLWithString:@"图片链接"] transformation:tran];
```


* ###    与 SDWebImage 配合使用数据万象 AVIF 功能，支持 AVIF 动图加载，无需额外处理。

#### 准备工作

在使用 AVIF 功能时，SDWebImage-CloudInfinite 需要依赖 CloudInfinite/AVIF 模块。
```
    pod 'CloudInfinite/AVIF'
```

### 调用 UIImageView+CI 加载 AVIF

**Objective-C**

```
    // 构建 CITransformation实例
    CITransformation * tran = [CITransformation new];

    // 设置AVIF格式以及传参方式
    [tran setFormatWith:CIImageTypeAVIF options:CILoadTypeUrlFooter];

    // 调用UIImageView+CI 类种方法，加载图片
    [self.imageView sd_CI_setImageWithURL:[NSURL URLWithString:@"图片链接"] transformation:transform];
```

**swift**

```
    // 构建 CITransformation 实例
    let transform = CITransformation();

    // 设置 AVIF 格式以及传参方式
    transform.setFormatWith(CIImageFormat.typeAVIF, options: CILoadTypeEnum.urlFooter);

    // 调用 UIImageView+CI 类种方法，加载图片
    imageView.sd_CI_setImage(with: NSURL.init(string: "图片链接"), transformation: transform)
```


<div id="changelog"></div>

## 更新日志
(最低版本号1.5.0)
* #### Version 1.5.6
    修复avif动图duration。

* #### Version 1.5.5
    修复avif解码过程中icc数据异常导致的crash
  
* #### Version 1.5.4
    修复avif解码饱和度丢失问题
  
* #### Version 1.5.3
    简化AVIF解码器
    
* #### Version 1.5.2
    优化灯塔上报逻辑

* #### Version 1.5.1

    1 新增cloudavif.a&cloudtpg.a

* #### Version 1.5.0
    2022-05-24
    1 新增自定义网络层。
    2 接入quic、HTTPDNS。
    3 支持配置重试、并发数以及tpg、avif原图保护。


## 卸载SDK
在您工程Podfile文件中删除本sdk的依赖，然后执行
```
pod install
```

## 示例
完整例子请参考CIImageLoaderDemo示例工程

## 感谢
使用过程中如果您遇到了问题或者有更好的建议欢迎提 issue以及pull request;
