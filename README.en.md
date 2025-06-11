# network

#### Description [中文](README.md)
Harmony OS network 

#### Software Architecture
Based on the system network request library, including http and websocket encapsulation.

#### Installation

`ohpm install @free/network`

#### Instructions


1、Initialization
```
/**
 * GET Request
 */
Http.get("");
/**
 * POST Request
 */
Http.post("");
/**
 * Download GET Request
 */
Http.download("");
/**
 * Upload pictures POST Request
 */
Http.upImage("",{image:""});
/**
 * Upload multiple pictures POST Request
 */
Http.upImages("",[{image:""}]);
/**
 * request Default POST
 */
Http.request("");
/**
 * more requests Asynchronous request Default POST
 */
Http.requests({url:""});
/**
 * more requests Synchronous request Default POST
 */
Http.requestsAsync({url:""});
```

#### Contribution

1.  Fork the repository
2.  Create Feat_xxx branch
3.  Commit your code
4.  Create Pull Request


#### Gitee Feature

1.  You can use Readme\_XXX.md to support different languages, such as Readme\_en.md, Readme\_zh.md
2.  Gitee blog [blog.gitee.com](https://blog.gitee.com)
3.  Explore open source project [https://gitee.com/explore](https://gitee.com/explore)
4.  The most valuable open source project [GVP](https://gitee.com/gvp)
5.  The manual of Gitee [https://gitee.com/help](https://gitee.com/help)
6.  The most popular members  [https://gitee.com/gitee-stars/](https://gitee.com/gitee-stars/)
