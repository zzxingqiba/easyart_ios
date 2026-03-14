//
//  OrderQRScanVC.swift
//  easyart
//
//  Created by Damon on 2025/6/24.
//

import UIKit
import AVFoundation
import DDUtils
import HDHUD


class OrderQRScanVC: BaseVC, AVCaptureMetadataOutputObjectsDelegate {
    var model = LogisticsModel()

    lazy var mSession: AVCaptureSession = {
        let tSession = AVCaptureSession()
        tSession.sessionPreset = AVCaptureSession.Preset.high
        return tSession
    }()
    
    lazy var mPreviewLayer: AVCaptureVideoPreviewLayer = {
        let tPreviewLayer = AVCaptureVideoPreviewLayer(session: self.mSession)
        tPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        return tPreviewLayer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadBarTitle(title: "扫码识别")
        DDUtils.shared.requestPermission(type: .video) { [weak self] (status) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if status == .authorized {
                    self.p_scanCode()
                } else {
                    let alertPop = HDAlertView(title: "权限不足", content: "您未允许访问您的摄像头，将无法使用摄像头扫描条码,是否现在去系统设置中开启？")
                    alertPop.mConfirmButton.setTitle("去开启", for: .normal)
                    _ = alertPop.clickEvent.emit(onNext: { (clickInfo) in
                        DDUtils.shared.openSystemSetting()
                    })
                    HDPopView.show(view: alertPop)
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationBarTransparentType = .none
    }
    
    override func createUI() {
        super.createUI()
        let posView = UIView()
        posView.layer.borderWidth = 1.5
        posView.layer.borderColor = UIColor.green.cgColor
        self.mSafeView.addSubview(posView)
        posView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-40)
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.height.equalTo(100)
        }
    }
    
    func p_scanCode() -> Void {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("device创建失败")
            return
        }
        let input = try! AVCaptureDeviceInput(device: device)
        mSession.addInput(input)
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        mSession.addOutput(output)
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr,//二维码
        //以下为条形码，如果项目只需要扫描二维码，下面都不要写
            AVMetadataObject.ObjectType.ean13,
            AVMetadataObject.ObjectType.ean8,
            AVMetadataObject.ObjectType.upce,
            AVMetadataObject.ObjectType.code39,
            AVMetadataObject.ObjectType.code39Mod43,
            AVMetadataObject.ObjectType.code93,
            AVMetadataObject.ObjectType.code128,
            AVMetadataObject.ObjectType.pdf417];
        
        self.mPreviewLayer.frame = self.view.layer.bounds
        self.mSafeView.layer.insertSublayer(self.mPreviewLayer, at: 0)
        self.mSession.startRunning()
    }
    
    //MARK:AVCaptureMetadataOutputObjectsDelegate
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            if let object: AVMetadataMachineReadableCodeObject = metadataObjects.first! as? AVMetadataMachineReadableCodeObject, let number = object.stringValue {
                self.model.number = number
            } else {
                HDHUD.show("条码识别错误，请重试", icon: .error)
            }
        } else {
            HDHUD.show("条码识别错误，请重试", icon: .error)
        }
        self.mSession.stopRunning()
        self.mPreviewLayer.removeFromSuperlayer()
        self.navigationController?.popViewController(animated: true)
    }
}
