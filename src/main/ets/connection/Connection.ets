import { connection } from '@kit.NetworkKit';

export class Connection{

  constructor() {
    // 关注默认网络, 不需要传参
    let netConnection = connection.createNetConnection();

    // 关注蜂窝网络，需要传入相关网络特征，timeout参数未传入说明未使用超时时间，此时timeout为0
    let netConnectionCellular = connection.createNetConnection({
      netCapabilities: {
        bearerTypes: [connection.NetBearType.BEARER_CELLULAR]
      }
    });
  }
}