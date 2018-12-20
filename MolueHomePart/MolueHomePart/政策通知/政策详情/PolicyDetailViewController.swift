//
//  PolicyDetailViewController.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/12/19.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import WebKit
import MolueUtilities
import MolueCommon
import MolueMediator
import MolueFoundation

protocol PolicyDetailPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    var notificationItem: MoluePolicyNotification? {get}
    var selectedNotice: MLPolicyNoticeModel? {get}
}

final class PolicyDetailViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: PolicyDetailPresentableListener?
    @IBOutlet weak var createUserLabel: UILabel!
    @IBOutlet weak var createTimeLabel: UILabel!
    
    @IBOutlet weak var submitButtonHeight: NSLayoutConstraint!
    
    lazy var webview: WKWebView! = {
        let webview = WKWebView()
        self.view.addSubview(webview)
        webview.snp.makeConstraints({ (make) in
            make.bottom.equalTo(self.submitButton.snp.top)
            make.top.equalTo(self.createUserLabel.snp.bottom)
            make.left.right.equalToSuperview()
        })
        webview.navigationDelegate = self
        webview.uiDelegate = self
        return webview
    }()
    
    @IBOutlet weak var submitButton: UIButton! {
        didSet {
            submitButton.setColor(.lightGray, state: .disabled)
            submitButton.setColor(MLCommonColor.appDefault, state: .normal)
        }
    }
    
    lazy var titleLabel: UILabel! = {
        let titleLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 44))
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        self.navigationItem.titleView = titleLabel
        return titleLabel
    } ()
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension PolicyDetailViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        do {
            let listener = try self.listener.unwrap()
            let notification = try listener.notificationItem.unwrap()
            self.refreshSubviewsLayout(with: notification)
            self.loadWebViewRequest(with: notification)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func refreshSubviewsLayout(with notification: MoluePolicyNotification)  {
        func queryTime(with date: String?) -> String? {
            do {
                let format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                let publishDate = try date.unwrap().date(withFormat: format)
                let value = try publishDate.unwrap().string(withFormat: "yyyy-MM-dd")
                return "发布时间: " + value
            } catch { return "发布时间: 暂无数据" }
        }
        
        do {
            let needSignature = try notification.needSignature.unwrap()
            self.submitButtonHeight.constant = needSignature ? 45 : 0
            self.submitButton.isEnabled = true
            let createUser = "发布者: " + notification.createUser.data()
            let published = queryTime(with: notification.published.data())
            self.createTimeLabel.text = published
            self.createUserLabel.text = createUser
            self.titleLabel.text = notification.title.data()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func loadWebViewRequest(with notification: MoluePolicyNotification) {
        do {
            let content = try notification.content.unwrap()
            self.webview.loadHTMLString(content, baseURL: nil)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension PolicyDetailViewController: PolicyDetailPagePresentable {
    
}

extension PolicyDetailViewController: PolicyDetailViewControllable {
    
}

extension PolicyDetailViewController: WKNavigationDelegate {
    
}

extension PolicyDetailViewController: WKUIDelegate {
    
}
