//  ImagePickerController.swift
//  ImageRow ( https://github.com/EurekaCommunity/ImageRow )
//
//  Copyright (c) 2016 Xmartlabs SRL ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Eureka
import Foundation

public protocol ImagePickerProtocol: class {
    var allowEditor: Bool { get set }

    var imageURL: URL? { get set }

    var useEditedImage: Bool { get set }

    var userPickerInfo: [UIImagePickerController.InfoKey:Any]? { get set }
}

/// Selector Controller used to pick an image
open class ImagePickerController: UIImagePickerController, TypedRowControllerType, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// The row that pushed or presented this controller
    public var row: RowOf<UIImage>!
    
    /// A closure to be called when the controller disappears.
    public var onDismissCallback: ((UIViewController) -> ())?

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        allowsEditing = (row as? ImagePickerProtocol)?.allowEditor ?? false
        delegate = self
    }
    
    open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        (row as? ImagePickerProtocol)?.imageURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        row.value = image
        if let _row = row as? ImageRow {
            _row.didSetImage(image)
        }
        row.value = info[ (row as? ImagePickerProtocol)?.useEditedImage ?? false ? UIImagePickerController.InfoKey.editedImage : UIImagePickerController.InfoKey.originalImage] as? UIImage
        (row as? ImagePickerProtocol)?.userPickerInfo = info
        onDismissCallback?(self)
    }
    
    open func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        onDismissCallback?(self)
    }
}
