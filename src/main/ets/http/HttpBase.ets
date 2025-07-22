import { http } from '@kit.NetworkKit'


type ValueType = object | string | number | boolean

export interface HttpReq{

  url:string

  method?:http.RequestMethod | undefined

  header?:object|undefined

  data?:object | undefined

  multiFormDataList?:Array<http.MultiFormData> | undefined

  resp?:((resp:HttpResp)=>void)|undefined

}

export interface HttpResp<T = object | string | ArrayBuffer>{

  responseCode: number

  code: number|string

  msg: string

  data: T

}

// 应用通过HTTP发起一个数据请求，支持常见的GET、POST、OPTIONS、HEAD、PUT、DELETE、TRACE、CONNECT方法。
export interface HttpFace{

  httpRequest: http.HttpRequest

  request<T>(url:string,options?:http.HttpRequestOptions): Promise<HttpResp<T>>

  get<T>(url:string,options:http.HttpRequestOptions): Promise<HttpResp<T>>

  post<T>(url:string,options:http.HttpRequestOptions): Promise<HttpResp<T>>

  options<T>(url:string,options:http.HttpRequestOptions): Promise<HttpResp<T>>

  head<T>(url:string,options:http.HttpRequestOptions): Promise<HttpResp<T>>

  put<T>(url:string,options:http.HttpRequestOptions): Promise<HttpResp<T>>

  delete<T>(url:string,options:http.HttpRequestOptions): Promise<HttpResp<T>>

  trace<T>(url:string,options:http.HttpRequestOptions): Promise<HttpResp<T>>

  connect<T>(url:string,options:http.HttpRequestOptions): Promise<HttpResp<T>>

  download<T>(url:string): Promise<HttpResp<T>>

  upload<T>(url:string,options:http.HttpRequestOptions,onProgress:((obj: http.DataReceiveProgressInfo) => void) | undefined): Promise<HttpResp<T>>

  clean(): void

  finish():void

}


export interface HttpConfigFace{

  baseUrl: string

  baseHeader: Map<string,ValueType>

  contentType: string

  method: http.RequestMethod

  connectTimeout: number

  readTimeout: number

  changeReq: ((resp:http.HttpRequestOptions)=>http.HttpRequestOptions) | undefined;

  changeResp: ((resp:http.HttpResponse)=>http.HttpResponse) | undefined;

}

export interface HttpListener{

  onHeadersReceive: ((obj:object)=>void) | undefined
  offHeadersReceive: ((obj:object)=>void) | undefined
  onceHeadersReceive: ((obj:object)=>void) | undefined

  onDataReceive: ((obj:ArrayBuffer)=>void) | undefined
  offDataReceive: ((obj:ArrayBuffer)=>void) | undefined

  onDataEnd: ((obj:void)=>void) | undefined
  offDataEnd: ((obj:void)=>void) | undefined

  onDataReceiveProgress: ((obj:http.DataReceiveProgressInfo)=>void) | undefined
  offDataReceiveProgress: ((obj:http.DataReceiveProgressInfo)=>void) | undefined

  onDataSendProgress: ((obj:http.DataSendProgressInfo)=>void) | undefined
  offDataSendProgress: ((obj:http.DataSendProgressInfo)=>void) | undefined

  initListener():void

  clearListener(): void

}

export interface HttpBaseParams{

  baseUrl?: string

  baseHerder?: Map<string,ValueType>

  changeReq?: ((resp:http.HttpRequestOptions)=>http.HttpRequestOptions)|undefined

  changeResp?: ((resp:http.HttpResponse)=>http.HttpResponse)|undefined

}

export class HttpBase implements HttpFace, HttpConfigFace, HttpListener{

  static baseUrl:string = "";

  static baseHeader:Map<string,ValueType> = new Map<string,ValueType>([["Content-Type","application/json"]])

  static changeReq: ((resp:http.HttpRequestOptions)=>http.HttpRequestOptions)|undefined;

  static changeResp: ((resp:http.HttpResponse)=>http.HttpResponse)|undefined;

  constructor(params?:HttpBaseParams) {
    this.baseUrl = params?.baseUrl ?? HttpBase.baseUrl
    this.baseHeader = params?.baseHerder ?? HttpBase.baseHeader
    this.changeReq = params?.changeReq ?? HttpBase.changeReq
    this.changeResp = params?.changeResp ?? HttpBase.changeResp
  }

  onHeadersReceive: ((obj: object) => void) | undefined
  offHeadersReceive: ((obj: object) => void) | undefined
  onceHeadersReceive: ((obj: object) => void) | undefined
  onDataReceive: ((obj: ArrayBuffer) => void) | undefined
  offDataReceive: ((obj: ArrayBuffer) => void) | undefined
  onDataEnd: ((obj: void) => void) | undefined
  offDataEnd: ((obj: void) => void) | undefined
  onDataReceiveProgress: ((obj: http.DataReceiveProgressInfo) => void) | undefined
  offDataReceiveProgress: ((obj: http.DataReceiveProgressInfo) => void) | undefined
  onDataSendProgress: ((obj: http.DataSendProgressInfo) => void) | undefined
  offDataSendProgress: ((obj: http.DataSendProgressInfo) => void) | undefined

  initListener(): void {
    if (this.onHeadersReceive != undefined) {
      this.httpRequest.on("headerReceive",this.onHeadersReceive)
    }
    if (this.onDataReceive != undefined) {
      this.httpRequest.on("dataReceive",this.onDataReceive)
    }
    if (this.onDataEnd != undefined) {
      this.httpRequest.on('dataEnd',this.onDataEnd)
    }
    if (this.onDataReceiveProgress != undefined) {
      this.httpRequest.on('dataReceiveProgress',this.onDataReceiveProgress)
    }
    if (this.onDataSendProgress != undefined) {
      this.httpRequest.on('dataSendProgress',this.onDataSendProgress)
    }
  }

  clearListener(): void {
    if (this.onHeadersReceive != undefined) {
      this.httpRequest.off("headerReceive",this.onHeadersReceive)
    }
    if (this.onDataReceive != undefined) {
      this.httpRequest.off("dataReceive",this.onDataReceive)
    }
    if (this.onDataEnd != undefined) {
      this.httpRequest.off('dataEnd',this.onDataEnd)
    }
    if (this.onDataReceiveProgress != undefined) {
      this.httpRequest.off('dataReceiveProgress',this.onDataReceiveProgress)
    }
    if (this.onDataSendProgress != undefined) {
      this.httpRequest.off('dataSendProgress',this.onDataSendProgress)
    }
  }

  baseUrl: string
  baseHeader: Map<string,ValueType>
  contentType: string = "application/json"
  method: http.RequestMethod = http.RequestMethod.POST
  connectTimeout: number = 6000
  readTimeout: number = 6000
  httpRequest: http.HttpRequest = http.createHttp()
  changeReq: ((req:http.HttpRequestOptions)=>http.HttpRequestOptions) | undefined;
  changeResp: ((resp:http.HttpResponse)=>http.HttpResponse) | undefined;
  baseOptions:http.HttpRequestOptions = {
    connectTimeout: this.connectTimeout,
    readTimeout: this.readTimeout
  }

  request<T = object | string | ArrayBuffer>(url:string,options:http.HttpRequestOptions = this.baseOptions): Promise<HttpResp<T>> {
    this.baseHeader.set("Content-Type",this.contentType);
    options.header = assign({},this.baseHeader,options.header??{})
    options = assign({},this.baseOptions,options)
    if (this.changeReq != undefined) {
      options = this.changeReq(options);
    }
    console.info("options:",JSON.stringify(options));
    return new Promise((res,rej)=>{
      this.httpRequest.request(url,options,(err,data)=>{
        if (err) {
          rej(err)
        }else{
          if (this.changeResp != undefined) {
            data = this.changeResp(data);
          }
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

  get<T = object | string | ArrayBuffer>(url:string,options:http.HttpRequestOptions = this.baseOptions): Promise<HttpResp<T>> {
    options.method == http.RequestMethod.GET
    return this.request<T>(url,options);
  }

  post<T = object | string | ArrayBuffer>(url:string,options:http.HttpRequestOptions = this.baseOptions): Promise<HttpResp<T>> {
    options.method == http.RequestMethod.POST
    return this.request<T>(url,options);
  }

  options<T = object | string | ArrayBuffer>(): Promise<HttpResp<T>> {
    throw new Error('Method not implemented.')
  }

  head<T = object | string | ArrayBuffer>(): Promise<HttpResp<T>> {
    throw new Error('Method not implemented.')
  }

  put<T = object | string | ArrayBuffer>(): Promise<HttpResp<T>> {
    throw new Error('Method not implemented.')
  }

  delete<T = object | string | ArrayBuffer>(): Promise<HttpResp<T>> {
    throw new Error('Method not implemented.')
  }

  trace<T = object | string | ArrayBuffer>(): Promise<HttpResp<T>> {
    throw new Error('Method not implemented.')
  }

  connect<T = object | string | ArrayBuffer>(): Promise<HttpResp<T>> {
    throw new Error('Method not implemented.')
  }

  download<T = ArrayBuffer>(url: string,onProgress?: ((obj: http.DataReceiveProgressInfo) => void) | undefined): Promise<HttpResp<T>> {
    this.onDataReceiveProgress = onProgress
    this.initListener()
    return this.request<T>(url,{extraData:ArrayBuffer});
  }

  upload<T = object | string | ArrayBuffer>(url: string, options: http.HttpRequestOptions = this.baseOptions,
    onProgress?: ((obj: http.DataReceiveProgressInfo) => void) | undefined): Promise<HttpResp<T>> {
    this.contentType = "multipart/form-data";
    this.onDataReceiveProgress = onProgress
    this.initListener()
    return this.post<T>(url,options);
  }

  finish(): void {
    this.clearListener()
  }

  clean(){
    this.clearListener()
    this.httpRequest.destroy();
  }

  cancel(){
    this.clearListener()
    this.httpRequest.destroy();
  }
}


export function assign(target: Record<string, object>, ...source: object[]): Record<string, Object> {
  for (const items of source) {
    for (const key of Object.keys(items)) {
      target[key] = Reflect.get(items, key)
    }
  }
  return target;
}