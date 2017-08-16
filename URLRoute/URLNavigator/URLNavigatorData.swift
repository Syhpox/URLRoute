//
//  URLNavigationProtocol.swift
//  HiveConsumer
//
//  Created by WZH on 2017/6/9.
//  Copyright © 2017年 Zhihua. All rights reserved.
//

import UIKit

// 解析数据模型
struct URLNavigatorData {
    var scheme: String?             // 协议头
    var urlString: String?          // 源URL 字符串
    var jsonString: String?         // json字符串
    var key: String?                // 映射key
    var localDic: [String: Any] = [:] // 本地字典
}
