//
//  ImagePickerController.swift
//  NBP-Baseball App
//
//  Created by iOS System on 20/07/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import UIKit
import Foundation
import AVKit
import MobileCoreServices


class ImagePickerController: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    lazy var picker = UIImagePickerController();
    var alert       = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
    var viewControllers   : UIViewController?
    var pickImageCallback : ((UIImage) -> ())?;
    var openCameraOnly    : Bool?
    var cameraFront       : Bool?
    var flag              : Bool?
    var videoFlag         : Bool?
    var controller = UIImagePickerController()
    let videoFileName = "/video.mp4"
    var pickVideoallback  : ((URL) -> ())?;
    override init(){
        super.init()
    }
    
    func pickImage(_ viewController: UIViewController,isCamraFront:Bool,isvideoFlag:Bool, _ videoCallback: @escaping ((URL) -> ()), _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback;
        self.viewControllers = viewController;
        pickVideoallback  = videoCallback;
        picker.delegate = self
        cameraFront = isCamraFront
        videoFlag = isvideoFlag
        if openCameraOnly ?? false
        {
            self.openCamera()
        }
        else{
            let cameraAction = UIAlertAction(title: "Camera", style: .default){
                UIAlertAction in
                self.openCamera()
            }
            let galleryAction = UIAlertAction(title: "Gallery", style: .default){
                UIAlertAction in
                self.openGallery()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
                UIAlertAction in
            }
            let videoAction = UIAlertAction(title: "Capture Video", style: .default){
                UIAlertAction in
                self.openVideo()
            }
            let pickvideo = UIAlertAction(title: "Pick Video", style: .default){
                UIAlertAction in
                self.openVideoGallery()
            }
            // Add the actions
            alert.addAction(cameraAction)
            alert.addAction(galleryAction)
            alert.addAction(cancelAction)
            if videoFlag ?? false
            {
                alert.addAction(videoAction)
                alert.addAction(pickvideo)
            }
          
            alert.popoverPresentationController?.sourceView = self.viewControllers!.view
            viewController.present(alert, animated: true, completion: nil)
        }
        
    }
    func openVideo()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
//            print("Camera Available")
            self.flag = false
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.allowsEditing = false
            
            self.viewControllers!.present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera UnAvaialable")
        }
    }
    
    func openVideoGallery() {
        picker = UIImagePickerController()
        picker.delegate = self
        self.flag = false
        picker.sourceType = .savedPhotosAlbum
        picker.mediaTypes = ["public.movie"]
        picker.allowsEditing = false
        self.viewControllers!.present(picker, animated: true, completion: nil)
    }
    
    func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            self.flag = true
            picker.modalPresentationStyle = .fullScreen
            picker.allowsEditing = true
            if cameraFront ?? true{
                picker.cameraDevice = UIImagePickerController.isCameraDeviceAvailable(.front) ? .front : .rear
            }
            self.viewControllers!.present(picker, animated: true, completion: nil)
            
        }
        
    }
    func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        self.flag = true
        picker.modalPresentationStyle = .fullScreen
        self.viewControllers!.present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if self.flag == true{
            guard let image = info[.editedImage] as? UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
            self.pickImageCallback?(image)
        }else{
            guard let  videoPath = info[UIImagePickerController.InfoKey.mediaURL]  as? URL else {return}
            self.pickVideoallback?(videoPath)
        }
    }
    
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }
    
}

