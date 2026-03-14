//
//  DDPingViewController.swift
//  DDKitSwift_Ping
//
//  Created by Damon on 2025/4/14.
//

import UIKit
import DDPingTools

class DDPingViewController: UIViewController {
    private var logList = [String]()
    private var pingTool: DDPingTools?
    var defaultUrl: String? {
        didSet {
            let text = defaultUrl?.replacingOccurrences(of: "http://", with: "")
            self.mTextField.text = text?.replacingOccurrences(of: "https://", with: "")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._createUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.pingTool?.stop()
    }
    

    //MARK: UI
    lazy var mTextField: UITextField = {
        let tTextField = UITextField()
        tTextField.keyboardType = .URL
        tTextField.translatesAutoresizingMaskIntoConstraints = false
        tTextField.font = .systemFont(ofSize: 14)
        tTextField.textColor = UIColor.dd.color(hexValue: 0x000000)
        tTextField.leftViewMode = .always
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 80, height: 40))
        view.backgroundColor = UIColor.dd.color(hexValue: 0xeeeeee)
        let label = UILabel(frame: CGRect.init(x: 10, y: 0, width: 60, height: 40))
        view.addSubview(label)
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.text = "https://"
        tTextField.leftView = view
        tTextField.layer.borderWidth = 1
        tTextField.layer.borderColor = UIColor.dd.color(hexValue: 0xcccccc).cgColor
        return tTextField
    }()
    
    lazy var mStartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start".ZXLocaleString, for: .normal)
        button.backgroundColor =  UIColor.dd.color(hexValue: 0x409eff)
        button.setTitleColor(UIColor.dd.color(hexValue: 0xffffff), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.addTarget(self, action: #selector(_pingStart), for: .touchUpInside)
        return button
    }()
    
    lazy var mResultButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isHidden = true
        button.backgroundColor =  UIColor.dd.color(hexValue: 0x5dae8b)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.dd.color(hexValue: 0xffffff), for: .normal)
        button.setTitle("Stop".ZXLocaleString, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.addTarget(self, action: #selector(_pingStop), for: .touchUpInside)
        button.dd.addLayerShadow(color: UIColor.dd.color(hexValue: 0x000000), offset: CGSize.zero, radius: 4, cornerRadius: 40)
        button.layer.borderColor = UIColor.dd.color(hexValue: 0xffffff).cgColor
        button.layer.borderWidth = 3
        return button
    }()
    
    lazy var mLogTableView: UITableView = {
        let tTableView = UITableView(frame: CGRect.zero, style: .plain)
        tTableView.translatesAutoresizingMaskIntoConstraints = false
        tTableView.contentInsetAdjustmentBehavior = .never
        if #available(iOS 15.0, *) {
            tTableView.sectionHeaderTopPadding = 0
        }
        tTableView.backgroundColor = UIColor.clear
        tTableView.separatorStyle = .singleLine
        tTableView.delegate = self
        tTableView.dataSource = self
        tTableView.register(DDPingTableViewCell.self, forCellReuseIdentifier: "DDPingTableViewCell")
        tTableView.rowHeight = UITableView.automaticDimension
        return tTableView
    }()

}

extension DDPingViewController {
    func _createUI() {
        self.view.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        
        self.view.addSubview(mTextField)
        mTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        mTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        mTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        mTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(mStartButton)
        mStartButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50).isActive = true
        mStartButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50).isActive = true
        mStartButton.topAnchor.constraint(equalTo: self.mTextField.bottomAnchor, constant: 16).isActive = true
        mStartButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(mResultButton)
        mResultButton.centerXAnchor.constraint(equalTo: self.mStartButton.centerXAnchor).isActive = true
        mResultButton.topAnchor.constraint(equalTo: self.mTextField.bottomAnchor, constant: 16).isActive = true
        mResultButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        mResultButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.view.addSubview(mLogTableView)
        mLogTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        mLogTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        mLogTableView.topAnchor.constraint(equalTo: self.mResultButton.bottomAnchor, constant: 16).isActive = true
        mLogTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
    }
    
    @objc func _pingStart() {
        self.mTextField.resignFirstResponder()
        self.mStartButton.isHidden = true
        self.mResultButton.isHidden = false
        self.logList = []
        guard let url = URL(string: "https://" + (self.mTextField.text ?? "")) else { return }
        self.pingTool = DDPingTools(url: url)
        self.pingTool?.debugLog = false
        self.pingTool?.start(pingType: .any, interval: .second(3), complete: { [weak self] response, error in
            guard let self = self else { return }
            if let error = error {
                self.logList.insert("error: \(error)", at: 0)
                let backgroundColor = UIColor.dd.color(hexValue: 0xaa2b1d)  //深红色
                self.mResultButton.backgroundColor = backgroundColor
                self.mResultButton.setTitle("Error".ZXLocaleString, for: .normal)
            } else if let response = response {
                let time = Int(response.responseTime.second * 1000)
                self.logList.insert("ip=\(response.pingAddressIP) bytes=\(response.responseBytes) time=\(time)", at: 0)
                var backgroundColor = UIColor.dd.color(hexValue: 0xF75A5A)  //红色
                var title = "Terrible".ZXLocaleString
                if time <= 50 {
                    backgroundColor = UIColor.dd.color(hexValue: 0x5dae8b)  //绿色
                    title = "Fast".ZXLocaleString
                } else if time <= 100 {
                    backgroundColor = UIColor.dd.color(hexValue: 0x3D90D7)  //蓝色
                    title = "Normal".ZXLocaleString
                } else if time <= 200 {
                    backgroundColor = UIColor.dd.color(hexValue: 0xf0a500)  //黄色
                    title = "Slow".ZXLocaleString
                }
                self.mResultButton.backgroundColor = backgroundColor
                self.mResultButton.setTitle(title, for: .normal)
            }
            self.mLogTableView.reloadData()
        })
    }
    
    @objc func _pingStop() {
        self.pingTool?.stop()
        self.mStartButton.isHidden = false
        self.mResultButton.isHidden = true
    }
}

extension DDPingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.logList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DDPingTableViewCell") as! DDPingTableViewCell
        cell.selectionStyle = .none
        let model = self.logList[indexPath.row]
        cell.updateUI(text: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
