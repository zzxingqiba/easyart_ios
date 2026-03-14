//
//  DDRangeSlider.swift
//  easyart
//
//  Created by Damon on 2024/11/26.
//

import UIKit

class DDRangeSlider: UIControl {
    private let trackView = UIView() // 背景轨道视图
    private let rangeView = UIView() // 范围滑块视图
    private let leftThumb = UIImageView(image: UIImage(named: "icon-slider-thumb"))
    private let rightThumb = UIImageView(image: UIImage(named: "icon-slider-thumb"))
    
    private var trackHeight: CGFloat = 4.0 // 轨道高度
    private var thumbSize: CGSize = CGSize(width: 51, height: 36) // 滑块大小
    
    var lowerValue: CGFloat = 0 {
        didSet { updateRangeView() }
    }
    var upperValue: CGFloat = 1.0 {
        didSet { updateRangeView() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        // 添加背景轨道
        trackView.backgroundColor = UIColor.lightGray
        trackView.layer.cornerRadius = trackHeight / 2
        addSubview(trackView)
        trackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(trackHeight)
        }
        
        // 添加范围滑块
        rangeView.backgroundColor = UIColor.blue
        rangeView.layer.cornerRadius = trackHeight / 2
        addSubview(rangeView)
        
        // 添加左侧滑块
        leftThumb.isUserInteractionEnabled = true
        addSubview(leftThumb)
        leftThumb.snp.makeConstraints { make in
            make.centerY.equalTo(trackView)
            make.size.equalTo(thumbSize)
            make.centerX.equalTo(trackView.snp.left)
        }
        
        // 添加右侧滑块
        rightThumb.isUserInteractionEnabled = true
        addSubview(rightThumb)
        rightThumb.snp.makeConstraints { make in
            make.centerY.equalTo(trackView)
            make.size.equalTo(thumbSize)
            make.centerX.equalTo(trackView.snp.right)
        }
        
        // 更新 rangeView 的位置和宽度
        rangeView.snp.makeConstraints({ make in
            make.left.equalTo(leftThumb.snp.centerX)
            make.right.equalTo(rightThumb.snp.centerX)
            make.centerY.equalTo(trackView)
            make.height.equalTo(trackHeight)
        })
        
        // 添加手势
        let leftPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleLeftThumbPan(_:)))
        let rightPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleRightThumbPan(_:)))
        leftThumb.addGestureRecognizer(leftPanGesture)
        rightThumb.addGestureRecognizer(rightPanGesture)
        
        // 更新初始范围
        updateRangeView()
    }
    
    private func updateRangeView() {
        let trackWidth = trackView.bounds.width
        
        // 计算范围滑块的位置
        let rangeStart = trackWidth * lowerValue
        let rangeEnd = trackWidth * (1 - upperValue)
        
        // 更新左右滑块位置
        leftThumb.snp.updateConstraints { make in
            make.centerX.equalTo(trackView.snp.left).offset(rangeStart)
        }
        
        rightThumb.snp.updateConstraints { make in
            make.centerX.equalTo(trackView.snp.right).offset(-rangeEnd)
        }
        
        layoutIfNeeded()
    }
    
    // 左滑块拖动
    @objc private func handleLeftThumbPan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: trackView)
        let trackWidth = trackView.bounds.width
        
        // 计算新的 lowerValue
        let newValue = lowerValue + translation.x / trackWidth
        lowerValue = max(0, min(newValue, upperValue - 0.1))
        
        // 重置拖动位移
        gesture.setTranslation(.zero, in: trackView)
        sendActions(for: .valueChanged)
    }
    
    // 右滑块拖动
    @objc private func handleRightThumbPan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: trackView)
        let trackWidth = trackView.bounds.width
        
        // 计算新的 upperValue
        let newValue = upperValue + translation.x / trackWidth
        upperValue = min(1, max(newValue, lowerValue + 0.1))
        
        // 重置拖动位移
        gesture.setTranslation(.zero, in: trackView)
        sendActions(for: .valueChanged)
    }
}
