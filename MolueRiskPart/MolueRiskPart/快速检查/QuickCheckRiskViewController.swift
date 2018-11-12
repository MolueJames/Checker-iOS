//
//  QuickCheckRiskViewController.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/12.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueFoundation
import Gallery
import Lightbox

protocol QuickCheckRiskPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func jumpToScanQRCodeController()
    func jumpToTakePhotoController()
}

final class QuickCheckRiskViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: QuickCheckRiskPresentableListener?
    
    @IBOutlet weak var scanQRCodeButton: UIButton! {
        didSet {
            scanQRCodeButton.backgroundColor = UIColor.init(hex: 0x1B82D2)
            scanQRCodeButton.layer.cornerRadius = 50
        }
    }
    @IBOutlet weak var takePhotoButton: UIButton! {
        didSet {
            takePhotoButton.backgroundColor = UIColor.init(hex: 0x1B82D2)
            takePhotoButton.layer.cornerRadius = 50
        }
    }
    lazy var titleLabel: UILabel! = {
        let label = UILabel.init()
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    } ()
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func scanQRCodeButtonClicked(_ sender: UIButton) {
        do {
            let listener = try self.listener.unwrap()
            listener.jumpToScanQRCodeController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    @IBAction func takePhotoButtonClicked(_ sender: UIButton) {
        do {
            let listener = try self.listener.unwrap()
            listener.jumpToTakePhotoController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension QuickCheckRiskViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.titleLabel.text = "快速检查"
        self.navigationItem.titleView = self.titleLabel
    }
}

extension QuickCheckRiskViewController: QuickCheckRiskPagePresentable {
    
}

extension QuickCheckRiskViewController: QuickCheckRiskViewControllable {
    func setTakePhotoConfigure(for controller: GalleryController) {
        Config.tabsToShow = [.cameraTab]
        controller.delegate = self
    }
}

extension QuickCheckRiskViewController: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        LightboxConfig.DeleteButton.enabled = true

        Image.resolve(images: images, completion: { [weak self] resolvedImages in
            self?.showLightbox(images: resolvedImages.compactMap({ $0 }), controller: controller)
        })
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func showLightbox(images: [UIImage], controller: GalleryController) {
        guard images.count > 0 else {
            return
        }
        
        let lightboxImages = images.map({ LightboxImage(image: $0) })
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        lightbox.dismissalDelegate = self
        
        controller.present(lightbox, animated: true, completion: nil)
    }
}

extension QuickCheckRiskViewController: LightboxControllerDismissalDelegate {
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        
    }
    
    
}
