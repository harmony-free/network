import { webSocket } from '@kit.NetworkKit'
import { BusinessError } from '@kit.BasicServicesKit'

class OutValue extends Object {
  status: number = 0
  message: string = ""
}

enum WebSocketStatus {
  normal,
  link,
  unLink,
}

interface WebSocketEvent {

  /**
   * 监听打开事件
   * @param err 错误信息
   * @param value 打开信息
   */
  onOpen(err: BusinessError, value: OutValue): void

  /**
   * 监听消息事件
   * @param err 错误信息
   * @param value 消息信息
   */
  onMessage(err: BusinessError<void>, value: string | ArrayBuffer): void

  /**
   * 监听关闭事件
   * @param err 错误信息
   * @param value 关闭信息
   */
  onClose(err: BusinessError, value: webSocket.CloseResult): void

  /**
   * 监听错误事件
   * @param err 错误信息
   */
  onError(err: BusinessError): void

  /**
   * 监听数据结束事件
   */
  onDataEnd(): void

  /**
   * 监听响应头事件
   * @param value 响应信息
   */
  onHeaderReceive(data: object): void
}

interface WebSocketFace {
  /**
   * socket 接口类
   */
  ws: webSocket.WebSocket
  /**
   * 连接地址
   */
  url: string
  /**
   * 链接参数
   */
  options?: webSocket.WebSocketRequestOptions
  /**
   * WebSocket状态
   */
  status: WebSocketStatus

  /**
   * 开始链接
   * @returns
   */
  connect(): Promise<boolean>

  /**
   * 关闭链接
   * @returns
   */
  close(): Promise<boolean>

  /**
   * 开始监听
   */
  on(): void

  /**
   * 关闭监听
   */
  off(): void
}

export class WebSocketBase implements WebSocketFace, WebSocketEvent {
  ws: webSocket.WebSocket = webSocket.createWebSocket();
  url: string
  options?: webSocket.WebSocketRequestOptions
  status: WebSocketStatus = WebSocketStatus.normal

  constructor(url: string, options?: webSocket.WebSocketRequestOptions) {
    this.url = url
    this.options = options
    this.connect()
  }


  connect(): Promise<boolean> {
    this.on()
    return this.ws.connect(this.url, this.options)
  }

  close(): Promise<boolean> {
    return new Promise<boolean>((res, rej) => {
      this.ws.close().then((v) => {
        this.off()
        res(v)
      }).catch(() => {
        rej("web socket close error")
      })
    })
  }


  on(): void {
    this.ws.on("open", this.onOpen)
    this.ws.on("message", this.onMessage)
    this.ws.on("close", this.onClose)
    this.ws.on("error", this.onError)
    this.ws.on("dataEnd", this.onDataEnd)
    this.ws.on("headerReceive", this.onHeaderReceive)
  }

  off(): void {
    this.ws.off("open", this.onOpen)
    this.ws.off("message", this.onMessage)
    this.ws.off("close", this.onClose)
    this.ws.off("error", this.onError)
    this.ws.off("dataEnd", this.onDataEnd)
    this.ws.off("headerReceive", this.onHeaderReceive)
  }

  onOpen(err: BusinessError, value: Object): void {
    console.log("on open, status:" + (value as OutValue).status + ", message:" + (value as OutValue).message);
    this.status = WebSocketStatus.link
  }

  onMessage(err: BusinessError<void>, value: string | ArrayBuffer): void {
    console.log("on message, message:" + value);
  }

  onClose(err: BusinessError, value: webSocket.CloseResult): void {
    console.log("on close, code is " + value.code + ", reason is " + value.reason);
    this.status = WebSocketStatus.unLink
  }

  onError(err: BusinessError): void {
    console.log("on error, error:" + JSON.stringify(err))
  }

  onDataEnd(): void {
    console.log("on dataEnd")
  }

  onHeaderReceive(data: object): void {
    console.log("on headerReceive " + JSON.stringify(data));
  }
}


interface WebSocketUtilsFace extends WebSocketFace {
  /**
   * 重新连接
   * @param count 连接次数
   * @returns
   */
  reConnect(count: number): Promise<boolean>

  /**
   * 关闭
   */
  dispose(): Promise<boolean>
}

export class WebSocketUtils extends WebSocketBase implements WebSocketUtilsFace {
  setUrl(url: string, options?: webSocket.WebSocketRequestOptions) {
    this.close()
    this.url = url
    this.options = options
    this.connect()
  }


  async reConnect(count: number = 5): Promise<boolean> {
    let con = await this.connect()
    if (!con && count > 0) {
      return await this.reConnect(count--)
    } else {
      return con
    }
  }

  dispose(): Promise<boolean> {
    this.off()
    return this.close()
  }
}

export class WebSocketManage {
  static webSocketMap: Map<string, WebSocketUtils> = new Map()

  static create(url: string, options?: webSocket.WebSocketRequestOptions): WebSocketUtils {
    if (WebSocketManage.webSocketMap.has(url)) {
      WebSocketManage.delete(url)
    }
    let socket = new WebSocketUtils(url, options)
    WebSocketManage.set(socket)
    return socket
  }

  static delete(url: string): boolean {
    if (WebSocketManage.webSocketMap.has(url)) {
      let ws = WebSocketManage.webSocketMap.get(url)!
      ws.dispose()
      WebSocketManage.webSocketMap.delete(url)
      return true
    } else {
      return false
    }
  }

  static get(url: string): WebSocketUtils | undefined {
    return WebSocketManage.webSocketMap.get(url)
  }

  static set(socket: WebSocketUtils) {
    WebSocketManage.webSocketMap.set(socket.url, socket)
  }
}
