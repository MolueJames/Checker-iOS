//
//  AppHomeDocument.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/11/25.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import Foundation
import MolueMediator
private let single = AppHomeDocument()
class AppHomeDocument {
    public class var shared: AppHomeDocument {
        return single
    }
    lazy var unitList: [DangerUnitSectionHeaderModel] = {
        var list = [DangerUnitSectionHeaderModel]()
        self.addDangerUnitModel(to: &list)
        return list
    }()
    
    func addDangerUnitModel(to list: inout [DangerUnitSectionHeaderModel]) {
        var model1 = DangerUnitSectionHeaderModel()
        model1.unitName = "生产车间1"
        model1.unitClass = "企业厂址"
        model1.unitNumber = "BTD000001"
        model1.unitRisks = [DangerUnitRiskModel]()
        var item11 = DangerUnitRiskModel()
        item11.riskName = "超声波清洗"
        item11.riskHead = "赵德胜"
        item11.headPhone = "13962624430"
        item11.riskLevel = "D级"
        item11.riskClass = "作业过程"
        item11.riskMeasure = ["1、操作工上岗前必须接受相关的安全教育并熟悉掌握操作规程", "2、加强现场检查，发现问题及时整改", "3、按规定佩戴劳护用品", "4、现场配备足量消防器材", "5、建立健全设备维护保养台账"]
        item11.riskReason = "1、超声波机器故障;\n2、设备漏电;\n3、取工件时水落在地面了;\n4、设备电线电化，绝缘皮击穿引发短路;\n5、硅片边缘锋利完割伤"
        item11.riskClass = "现场管理类事故隐患-通用设备设施缺陷"
        item11.responseUnit = "生产设备检测科"
        item11.accidentType = "火灾、高温灼伤、触电、其他伤害"
        item11.dependence = "生产经营单位安全管理体制、机制及程序"
        item11.riskRemarks = "暂无风险点的其他说明"
        var item12 = DangerUnitRiskModel()
        item12.riskName = "清洗制绒机"
        item12.riskHead = "赵德胜"
        item12.headPhone = "13962624430"
        item12.riskLevel = "D级"
        item12.riskClass = "设备设施"
        item12.riskMeasure = ["1、开机作业前进行各项检查，有故障及时处理", "2、按照操作规程认真", "3、作业人员是穿戴劳动防护用品", "4、做好常规保养，保证设备安全联动设施完好，并做好记录"]
        item12.riskReason = "1、电源线接入顺序不统一;\n2、电气设施过载;\n3、自动排气功能故障;\n4、可燃气体检测报警装置失效;\n5、浓碱废水洒落在地面上;\n6、超温保护失常;\n7、电源短路保护故障;\n8、未设置急停开关;\n9、操作人员接触高温表面"
        item12.riskClass = "现场管理类事故隐患-通用设备设施缺陷"
        item12.responseUnit = "生产设备检测科"
        item12.accidentType = "灼烫、触电、化学灼伤、火灾机械伤害"
        item12.dependence = "生产经营单位安全管理体制、机制及程序"
        item12.riskRemarks = "暂无风险点的其他说明"
        var item13 = DangerUnitRiskModel()
        item13.riskName = "液氧低温储罐"
        item13.riskHead = "赵德胜"
        item13.headPhone = "13962624430"
        item13.riskLevel = "D级"
        item13.riskClass = "设备设施"
        item13.riskMeasure = ["1、使用前对设备行各项检查，及时排查故障", "2、作业员必须穿戴合格的劳动防护用品", "3、操作人员安全操作知识培训常态化", "4、做好常规保养并做好记录"]
        item13.riskReason = "1、储气罐相连管道漏气;\n2、野蛮操作;\n3、作业后未及时关闭设备;\n4、安全附件未及时校验"
        item13.riskClass = "现场管理类事故隐患-通用设备设施缺陷"
        item13.responseUnit = "生产设备检测科"
        item13.accidentType = "噪声、机械伤害"
        item13.dependence = "生产经营单位安全管理体制、机制及程序"
        item13.riskRemarks = "暂无风险点的其他说明"
        model1.unitRisks?.append(item11)
        model1.unitRisks?.append(item12)
        model1.unitRisks?.append(item13)
        list.append(model1)
        var model2 = DangerUnitSectionHeaderModel()
        model2.unitName = "生产车间2"
        model2.unitClass = "企业厂址"
        model2.unitNumber = "BTD000002"
        model2.unitRisks = [DangerUnitRiskModel]()
        var item21 = DangerUnitRiskModel()
        item21.riskName = "丝网印刷机"
        item21.riskHead = "赵德胜"
        item21.headPhone = "13962624430"
        item21.riskLevel = "D级"
        item21.riskClass = "作业过程"
        item21.riskMeasure = ["1、使用前对设备行各项检查，及时排查故障", "2、作业员必须穿戴合格的劳动防护用品", "3、设备运行时随时观察设备状态", "4、操作人员安全操作知识培训常态化", "5、做好常规保养并做好记录"]
        item21.riskReason = "1、新手单独操作;\n2、作业时佩戴手套;\n3、漏电;\n4、电源故障;\n5、违规操作"
        item21.riskClass = "现场管理类事故隐患-通用设备设施缺陷"
        item21.responseUnit = "生产设备检测科"
        item21.accidentType = "触电、机械伤害、火灾"
        item21.dependence = "生产经营单位安全管理体制、机制及程序"
        item21.riskRemarks = "暂无风险点的其他说明"
        model2.unitRisks?.append(item21)
        list.append(model2)
    }
}
