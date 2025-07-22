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

#### Plugin Details

Hello everyone, nice to meet you all! Today, we are going to talk about the HTTP data request function of the network in HarmonyOS. During the daily development process, the interaction between the app and the server is inevitable. Network requests are also a crucial part of app development and one of the most frequently used tasks in app development.

一、HTTP network requests consist of two crucial parts: the request parameters (options) and the response data (response).

1、The request parameters **options** contain several important parameters such as **RequestMethod**, **header**, and **body**, and these parameters are encapsulated.

1.1、The **RequestMethod** includes **OPTIONS**, **GET**, **HEAD**, **POST**, **PUT**, **DELETE**, **TRACE**, and **CONNECT**, among which the most commonly used ones are **POST** and **GET**.

```arkts
options.method == http.RequestMethod.GET
options.method == http.RequestMethod.POST
```

1.2、The **header** of the request usually includes the verification signature **token** required by the server as well as the data type **Content-Type**, among other things.


```arkts
HttpBase.baseHeader.set("Content-Type",this.contentType);
HttpBase.baseHeader.set("token",token);

```

1.3、The **body** of the request typically contains the data required by the server. **options.extraData**


```arkts
options.extraData = "data"
```

1.4、The basic method for the request parameter **options**.

```arkts
request(url:string,options:http.HttpRequestOptions){
    this.baseHeader.set("Content-Type",this.contentType);
    options.header = assign({},this.baseHeader,options.header??{})
    return this.httpRequest.request(url,options);
}
```

2、The response parameter **response** contains several important parameters such as **responseCode**, **result**, and **resultType**, and these parameters are encapsulated.

2.1、**responseCode** - Response data status code. A status code of 200 indicates a successful response.

2.2、**Result** The corresponding data will have the data transmitted by the server when the status code is 200.

2.3、The response data types of **resultType** are **STRING**, **OBJECT**, and **ARRAY_BUFFER**.

2.4 Response data acquisition
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

二、Process the response data. While obtaining the data, it is also desired to perform some processing, and it is hoped that the data can be transformed into the form of a model for direct use.

1、Specify the type you want to obtain by passing in different T generics. The default generics are **object | string | ArrayBuffer**.


```arkts
request<T = object | string | ArrayBuffer>
```

2、Process the incoming T generic type and return the corresponding model type HttpResp< T >


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
              msg: "Request successful",
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

Note: The complete code has been submitted to the [HarmonyOS Third-Party Library](https://ohpm.openharmony.cn/). Please use the following command to install it.


```
ohpm install @free/network
```


Calling method

```arkts
// GET request
Http.get<object>("url",new Map());
// POST request
Http.post<object>("url",new Map());
// Download Request
Http.download<string>("url");
// Uploading image request
Http.upImage<string>("url",{image:"file"});
// Get request for uploading multiple images
Http.upImages("url",[{image:"file"}]);
// Perform multiple asynchronous requests
Http.requests({url:"url1"},{url:"url2",resp:(resp)=>{}});
// Perform synchronous execution of multiple requests
Http.requestsAsync({url:"url1"},{url:"url2",resp:(resp)=>{}});
```

If you like this content, please give a little heart!





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
