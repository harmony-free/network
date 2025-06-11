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
