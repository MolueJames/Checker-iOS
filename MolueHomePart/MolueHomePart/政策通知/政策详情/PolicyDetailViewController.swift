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
    
    func signCurrentNotification()
    
    func readCurrentNotification()
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
            let appDefault = MLCommonColor.appDefault
            submitButton.setColor(appDefault, state: .normal)
            submitButton.setColor(.lightGray, state: .disabled)
            submitButton.layer.masksToBounds = true
            submitButton.setTitle("签阅", for: .normal)
            submitButton.setTitle("已签阅", for: .disabled)
        }
    }
    
    lazy var titleLabel: UILabel! = {
        let titleLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 44))
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        return titleLabel
    } ()
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        do {
            let listener = try self.listener.unwrap()
            listener.signCurrentNotification()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension PolicyDetailViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        do {
            let listener = try self.listener.unwrap()
            listener.readCurrentNotification()
        } catch {
            MolueLogger.UIModule.message(error)
        }
    }
    
    func updateUserInterfaceElements() {
        do {
            self.navigationItem.titleView = self.titleLabel
            let listener = try self.listener.unwrap()
            let notification = try listener.notificationItem.unwrap()
            self.refreshSubviews(with: notification)
            let policyNotice = try listener.selectedNotice.unwrap()
            self.refreshSubviews(with: policyNotice)
            self.loadWebViewRequest(with: notification)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func refreshSubviews(with notification: MoluePolicyNotification)  {
        func queryTime(with date: String?) -> String? {
            do {
                let aDate = try date.unwrap()
                let publish = try aDate.transfer(to: "yyyy-MM-dd")
                return "发布时间: " + publish
            } catch { return "发布时间: 暂无数据" }
        }
        
        do {
            let needSignature = try notification.needSignature.unwrap()
            self.submitButtonHeight.constant = needSignature ? 45 : 0
            
            let published = queryTime(with: notification.published)
            self.createTimeLabel.text = published
            
            self.titleLabel.text = notification.title.data()
            
            let user = try notification.createUser.unwrap()
            let createUser = "发布者: " + user.screenName.data()
            self.createUserLabel.text = createUser
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func loadWebViewRequest(with notification: MoluePolicyNotification) {
        do {
            let header = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
            let content = try notification.content.unwrap()
            self.webview.loadHTMLString(header + content, baseURL: nil)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension PolicyDetailViewController: PolicyDetailPagePresentable {
    func refreshSubviews(with notice: MLPolicyNoticeModel) {
        let isSigned: Bool = notice.signed ?? false
        self.submitButton.isEnabled = !isSigned
    }
}

extension PolicyDetailViewController: PolicyDetailViewControllable {
    
}

extension PolicyDetailViewController: WKNavigationDelegate {
    
}

extension PolicyDetailViewController: WKUIDelegate {
    
}
