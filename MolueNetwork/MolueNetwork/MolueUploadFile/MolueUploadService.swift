//
//  MolueUploadFileService.swift
//  MolueNetwork
//
//  Created by JamesCheng on 2018-12-25.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import Foundation
import MolueUtilities
import Alamofire

typealias MultipartFormDataResult = SessionManager.MultipartFormDataEncodingResult

public class MolueFileService {
    //TODO: 添加Oauth校验
    public static func uploadPicture(with picture: UIImage, prefix: String = "taskitem.png", success: @escaping (Any?) -> Void, failure: @escaping (Error) -> Void)  {
        let path = HTTPConfigure.baseURL + "/core/upload_picture/"
        let fileData = picture.compressedData(quality: 0.2)
        let headers = MolueOauthHelper.queryClientInfoHeaders()
        Alamofire.upload(multipartFormData: { (formData) in
            guard let fileData = fileData else {return}
            formData.append(fileData, withName: "file", fileName: prefix, mimeType: "image/png")
        }, to: path, method: .post, headers: headers) { (result) in
            self.handleFormDataResult(result, success: success, failure: failure)
        }
    }
    
    private static func handleFormDataResult(_ result: MultipartFormDataResult, success: @escaping (Any?) -> Void, failure: @escaping (Error) -> Void) {
        if case let .success(upload, _, _) = result {
            upload.responseHandler(queue: .main, success: success, failure: failure)
        } 
        if case let .failure(error) = result { failure(error) }
    }
}
