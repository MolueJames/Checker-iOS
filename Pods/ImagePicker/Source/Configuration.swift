import UIKit

public struct Configuration {

  // MARK: Colors

  public var backgroundColor = UIColor(red: 0.15, green: 0.19, blue: 0.24, alpha: 1)
  public var gallerySeparatorColor = UIColor.black.withAlphaComponent(0.6)
  public var mainColor = UIColor(red: 0.09, green: 0.11, blue: 0.13, alpha: 1)
  public var noImagesColor = UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1)
  public var noCameraColor = UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1)
  public var settingsColor = UIColor.white
  public var bottomContainerColor = UIColor(red: 0.09, green: 0.11, blue: 0.13, alpha: 1)

  // MARK: Fonts

  public var numberLabelFont = UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.bold)
  public var doneButton = UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.medium)
  public var flashButton = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
  public var noImagesFont = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
  public var noCameraFont = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
  public var settingsFont = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)

  // MARK: Titles

  public var OKButtonTitle = "确定"
  public var cancelButtonTitle = "取消"
  public var doneButtonTitle = "完成"
  public var noImagesTitle = "相册中暂无照片"
  public var noCameraTitle = "无法调用手机相机"
  public var settingsTitle = "设置"
  public var requestPermissionTitle = "未开启权限"
  public var requestPermissionMessage = "请允许App使用您的手机相册"

  // MARK: Dimensions

  public var cellSpacing: CGFloat = 2
  public var indicatorWidth: CGFloat = 41
  public var indicatorHeight: CGFloat = 8

  // MARK: Custom behaviour

  public var canRotateCamera = true
  public var collapseCollectionViewWhileShot = true
  public var recordLocation = true
  public var allowMultiplePhotoSelection = true
  public var allowVideoSelection = false
  public var showsImageCountLabel = true
  public var flashButtonAlwaysHidden = false
  public var managesAudioSession = true
  public var allowPinchToZoom = true

  // MARK: Images
  public var indicatorView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.white.withAlphaComponent(0.6)
    view.layer.cornerRadius = 4
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  public init() {}
}
