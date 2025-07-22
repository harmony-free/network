# network

#### 介绍 [English](README.en.md)
Harmony OS network 鸿蒙网络库

#### 软件架构

基于系统网络请求库，http，websocket 封装。

#### 安装教程

`ohpm install @free/network`

#### 使用说明

1、初始化
```
/**
 * GET请求
 */
Http.get("");
/**
 * POST请求
 */
Http.post("");
/**
 * 下载 GET请求
 */
Http.download("");
/**
 * 上传图片 POST请求
 */
Http.upImage("",{image:""});
/**
 * 上传多张图片 POST请求
 */
Http.upImages("",[{image:""}]);
/**
 * request请求 默认POST
 */
Http.request("");
/**
 * 多个requests异步请求 默认POST
 */
Http.requests({url:""});
/**
 * 多个requests同步请求 默认POST
 */
Http.requestsAsync({url:""});
```

#### 插件明细

hello 各位同学，大家好！ 今天我们来讲讲关于鸿蒙里的network网络http数据请求功能。在日常开发过程中，app和服务端的交互是不可避免的，网络请求也是app开发过程中的重头环节，也是开发app中使用评率最高的工作之一。

一、http网络请求分为请求参数**options**，响应数据**response**两个重要环节。

1、请求参数**options**中有几个比较重要的参数 **RequestMethod**、**header**、**body**，针对这几个参数进行封装。

1.1、**RequestMethod** 请求方法有**OPTIONS**、**GET**、**HEAD**、**POST**、**PUT**、**DELETE**、**TRACE**、**CONNECT**，而最为常用的就是**POST**、**GET**这两个。

```arkts
options.method == http.RequestMethod.GET
options.method == http.RequestMethod.POST
```

1.2、**header**请求头中一般会带有服务端需要的验证签名**token**和数据类型**Content-Type**等等


```arkts
HttpBase.baseHeader.set("Content-Type",this.contentType);
HttpBase.baseHeader.set("token",token);

```

1.3、**body**请求体一般为服务端需要的数据**options.extraData**


```arkts
options.extraData = "data"
```

1.4、请求参数**options**的基本方法。

```arkts
request(url:string,options:http.HttpRequestOptions){
    this.baseHeader.set("Content-Type",this.contentType);
    options.header = assign({},this.baseHeader,options.header??{})
    return this.httpRequest.request(url,options);
}
```

2、响应参数**response**中有几个比较重要的参数 **responseCode**、**result**、**resultType**，针对这几个参数进行封装。

2.1、**responseCode**响应数据状态码，为200时响应成功。

2.2、**result**相应数据在状态码为200是会有服务端传输的数据

2.3、**resultType**响应数据类型分别为**STRING**、**OBJECT**、**ARRAY_BUFFER**

2.4 响应数据获取
```arkts
request(url:string,options:http.HttpRequestOptions){
    this.baseHeader.set("Content-Type",this.contentType);
    options.header = assign({},this.baseHeader,options.header??{})
    return this.httpRequest.request(url,options,(err,data)=>{
        if (err) {
          rej(err)
        }else{
          if (data.responseCode == 200) {
            res(data)
          }else{
            rej(JSON.stringify(data.result))
          }
        }
    });
}
```

二、处理响应数据，在获取到数据的同时希望能够做一些处理，并且希望把数据转化为model的形式直接使用。

1、确认想要获取的类型，通过传入不同的T泛型，默认泛型为 **object | string | ArrayBuffer** 这三种。


```arkts
request<T = object | string | ArrayBuffer>
```

2、根据传入的T泛型进行处理并且返回相对应的model类型HttpResp< T >


```arkts
request<T = object | string | ArrayBuffer>(url:string,options:http.HttpRequestOptions): Promise<HttpResp<T>> {
    return new Promise((res,rej)=>{
      this.httpRequest.request(url,options,(err,data)=>{
        if (err) {
          rej(err)
        }else{
          if (data.responseCode == 200) {
            let resp:HttpResp<T> = {
              responseCode: data.responseCode,
              code: data.responseCode,
              msg: "请求成功",
              data: data.result as T,
            }
            res(resp)
          }else{
            rej(JSON.stringify(data.result))
          }
        }
        this.finish()
      })
    });
}
```

注意：完整代码我已提交到鸿蒙三方库中，其中包括图片上传，多接口请求等等，使用一下命令安装


```
ohpm install @free/network
```


调用方式

```arkts
// get请求
Http.get<object>("url",new Map());
// post请求
Http.post<object>("url",new Map());
// download 下载请求
Http.download<string>("url");
// upimage 上传图片请求
Http.upImage<string>("url",{image:"file"});
// get 上传多个图片请求
Http.upImages("url",[{image:"file"}]);
// get 异步多个请求
Http.requests({url:"url1"},{url:"url2",resp:(resp)=>{}});
// get 同步多个请求
Http.requestsAsync({url:"url1"},{url:"url2",resp:(resp)=>{}});
```

喜欢本篇内容的话给个小爱心！



#### 参与贡献

1.  Fork 本仓库
2.  新建 Feat_xxx 分支
3.  提交代码
4.  新建 Pull Request


#### 特技

1.  使用 Readme\_XXX.md 来支持不同的语言，例如 Readme\_en.md, Readme\_zh.md
2.  Gitee 官方博客 [blog.gitee.com](https://blog.gitee.com)
3.  你可以 [https://gitee.com/explore](https://gitee.com/explore) 这个地址来了解 Gitee 上的优秀开源项目
4.  [GVP](https://gitee.com/gvp) 全称是 Gitee 最有价值开源项目，是综合评定出的优秀开源项目
5.  Gitee 官方提供的使用手册 [https://gitee.com/help](https://gitee.com/help)
6.  Gitee 封面人物是一档用来展示 Gitee 会员风采的栏目 [https://gitee.com/gitee-stars/](https://gitee.com/gitee-stars/)
