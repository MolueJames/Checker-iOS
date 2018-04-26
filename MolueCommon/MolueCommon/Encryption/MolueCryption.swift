//
//  MolueCryption.swift
//  MolueUtilities
//
//  Created by James on 2018/4/25.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import CryptoSwift
public class MolueCryption {
    //TODO 将常用的一些加解密方法抽到该类中
    public static func MD5(_ string: String) -> String {
        return string.md5()
    }
}
