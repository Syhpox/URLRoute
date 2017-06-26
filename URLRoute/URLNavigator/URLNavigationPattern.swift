//
//  URLNavigationPattern.swift
//  HiveConsumer
//
//  Created by WZH on 2017/6/9.
//  Copyright © 2017年 Zhihua. All rights reserved.
//

import UIKit

fileprivate let SchemeCut = "://"
fileprivate let KeyCut = "?"
fileprivate let ParamCut = "?param="

// 映射模型
struct URLNavigationPattern {
    /// 源URL
    var url: String?
    /// 协议头
    var scheme: String? {
        didSet {
            if let scheme = self.scheme, scheme.contains(SchemeCut) {
                self.scheme = scheme.components(separatedBy: SchemeCut)[0]
            }
        }
    }
    /// key
    var key: String?
    
    /// 处理方式回调
    var handler: ((URLNavigatorData) -> UIViewController?)?
    
    /// 导航弹出方式
    var navigatorAction: URLNavigatorAction?
    
    // 注册 解析
    static func analysis(_ url: String, handler: ((URLNavigatorData) -> UIViewController?)? = nil) -> URLNavigationPattern {
        var pattern = URLNavigationPattern.init()
        pattern.scheme = url
        pattern.url = url
        pattern.handler = handler
        pattern.key = url.contains(KeyCut) ? url.components(separatedBy: KeyCut).first! : url
        return pattern
    }
}

// URL解析 数据解析 scheme://url?param=jsonString
public struct URLAnalysis {
    /// 分离 scheme key和value
    static func analysis(_ url: String) -> URLNavigatorData {
        let scheme = url.contains(SchemeCut) ? url.components(separatedBy: SchemeCut).first! : nil
        var key: String?
        if url.hasPrefix("http") {
            if url.contains("://") {
                key = url.components(separatedBy: "://").first! + "://"
            }
        } else {
            key = url.contains(KeyCut) ? url.components(separatedBy: KeyCut).first! : url
        }
        var json: String?
        if url.contains(ParamCut) {
            var totalStr = ""
            for i in 0..<url.components(separatedBy: ParamCut).count {
                if i == 0 {
                    continue
                }
                totalStr += url.components(separatedBy: ParamCut)[i]
            }
            json = totalStr
        }
        return URLNavigatorData(scheme: scheme, urlString: url, jsonString: json, key: key)
    }
}












