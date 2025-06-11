import { HttpBase, HttpBaseParams, HttpReq, HttpResp } from './HttpBase'
import { http } from '@kit.NetworkKit';
import { buffer, url } from '@kit.ArkTS';

// 应用通过HTTP发起一个数据请求，支持常见的GET、POST、OPTIONS、HEAD、PUT、DELETE、TRACE、CONNECT方法。

export enum ImageEnum{
  PNG = "image/png",
  JPEG = "image/jpeg",
}

export  type ImageData = string | Object | ArrayBuffer | Uint8Array

export interface ImageParams{
  name?:string
  path?:string
  image:ImageData
  type?:ImageEnum | undefined
}


export interface HttpActionFace{

  upFile<T>(url: string, dataList: Array<http.MultiFormData>,header:object|undefined,
    onProgress: ((obj: http.DataReceiveProgressInfo) => void) | undefined): Promise<HttpResp<T>>
}


export class HttpUtils extends HttpBase implements HttpActionFace{

  upFile<T>(url: string, dataList: Array<http.MultiFormData>,header?:object | undefined,
    onProgress?: ((obj: http.DataReceiveProgressInfo) => void) | undefined): Promise<HttpResp<T>> {
    return this.upload<T>(url,{
      header: header,
      multiFormDataList:dataList
    },onProgress);
  }

}


export class Http{

  static init(params?:HttpBaseParams):HttpUtils{
    return new HttpUtils(params);
  }

  static request<T = object | string | ArrayBuffer>(url:string,options?: http.HttpRequestOptions | undefined): Promise<HttpResp<T>>{
    return new HttpUtils().request<T>(url,options);
  }

  static post<T = object | string | ArrayBuffer>(url:string,data?:object,header?:object): Promise<HttpResp<T>>{
		return new HttpUtils().post<T>(url,{extraData:data,header:header});
	}

  static get<T = object | string | ArrayBuffer>(url:string,data?:object,header?:object): Promise<HttpResp<T>>{
    return new HttpUtils().get<T>(url,{extraData:data,header});
  }

  static download<T = ArrayBuffer>(url:string){
    return new HttpUtils().download<T>(url);
  }

  static upImage<T = object | string | ArrayBuffer>(url: string,params:ImageParams,onProgress?: ((obj: http.DataReceiveProgressInfo) => void) | undefined):Promise<HttpResp<T>>{
    let data:http.MultiFormData = {
      name: params.name ?? "",
      contentType: params.type ?? ImageEnum.PNG,
      remoteFileName: `${params.path}${params.name}${params.type!=ImageEnum.JPEG ? ".png" : ".jpeg"}`
    }
    if (typeof params.image == "string") {
      if (params.image.startsWith("file")) {
        data.filePath = params.image;
      }else if (params.image.startsWith("data")){
        data.data = buffer.from(params.image).toString('base64');
      }
    }else {
      data.data = params.image
    }
    return new HttpUtils().upFile<T>(url,[data],onProgress);
  }

  static upImages<T = object | string | ArrayBuffer>(url: string,params:Array<ImageParams>,onProgress?: ((obj: http.DataReceiveProgressInfo) => void) | undefined){
    let  dataList:Array<http.MultiFormData> = [];
    for (let index = 0; index < params.length; index++) {
      const param = params[index];
      let data:http.MultiFormData = {
        name: param.name ?? "",
        contentType: param.type ?? ImageEnum.PNG,
        remoteFileName: `${param.path}${param.name}${param.type!=ImageEnum.JPEG ? ".png" : ".jpeg"}`
      }
      if (typeof param.image == "string") {
        if (param.image.startsWith("file")) {
          data.filePath = param.image;
        }else if (param.image.startsWith("data")){
          data.data = buffer.from(param.image).toString('base64');
        }
      }else {
        data.data = param.image
      }
      dataList.push(data);
    }
    return new HttpUtils().upFile<T>(url,dataList,onProgress);
  }

  static requests(...reqs:Array<HttpReq>): Promise<Map<string,HttpResp>> {
    return new Promise<Map<string,HttpResp>>((res,rej)=>{
      let errNum = 0;
      let respMap:Map<string,HttpResp> = new Map<string,HttpResp>();
      for (let index = 0; index < reqs.length; index++) {
        const req:HttpReq = reqs[index];
        let h: HttpUtils = new HttpUtils();
        h.request(req.url,{
          header:req.header,
          extraData:req.data,
          method:req.method ?? http.RequestMethod.POST,
          multiFormDataList:req.multiFormDataList
        }).then((resp)=>{
          if (req.resp!=undefined) {
            req.resp(resp);
          }
          respMap.set(req.url,resp);
          if (respMap.size + errNum >= reqs.length) {
            res(respMap)
          }
        }).catch(()=>{
          errNum += 1;
          if (respMap.size + errNum >= reqs.length) {
            res(respMap)
          }
        })
      }
    })

  }

  static async requestsAsync(...reqs:Array<HttpReq>): Promise<Map<string,HttpResp>> {
    let respMap:Map<string,HttpResp> = new Map<string,HttpResp>();
    for (let index = 0; index < reqs.length; index++) {
      const req:HttpReq = reqs[index];
      let h: HttpUtils = new HttpUtils();
      let resp:HttpResp = await h.request(req.url,{
        header:req.header,
        extraData:req.data,
        method:req.method ?? http.RequestMethod.POST,
        multiFormDataList:req.multiFormDataList
      })
      if (req.resp!=undefined) {
        req.resp(resp);
      }
      respMap.set(req.url,resp);
    }
    return respMap;
  }

}


