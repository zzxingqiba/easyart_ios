//
//  QAVC.swift
//  easyart
//
//  Created by Damon on 2024/9/24.
//

import UIKit

class QAVC: BaseVC {
    var list: [QAModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self._loadData()
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.contentType = .flex
        
        self.mSafeView.addSubview(mQAView)
        mQAView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
    }
    
    //MARK: UI
    lazy var mQAView: UIView = {
        let view = UIView()
        return view
    }()
}

extension QAVC {
    func updateUI() {
        for view in self.mQAView.subviews {
            view.removeFromSuperview()
        }
        var sectionPosView: UIView?
        for i in 0..<self.list.count {
            let model = self.list[i]
            let sectionView = UIView()
            self.mQAView.addSubview(sectionView)
            sectionView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(30)
                make.right.equalToSuperview().offset(-30)
                if let sectionPosView = sectionPosView {
                    make.top.equalTo(sectionPosView.snp.bottom).offset(30)
                } else {
                    make.top.equalToSuperview().offset(30)
                }
                if i == self.list.count - 1 {
                    make.bottom.equalToSuperview()
                }
            }
            //分割线
            let line = UIView()
            line.backgroundColor = ThemeColor.line.color()
            sectionView.addSubview(line)
            line.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalTo(1)
            }
            
            sectionPosView = sectionView
            //标题
            let titleLabel = PaddingLabel(withInsets: 0, 0, 15, 15)
            titleLabel.layer.masksToBounds = true
            titleLabel.layer.cornerRadius = 15
            titleLabel.backgroundColor = ThemeColor.main.color()
            titleLabel.font = .systemFont(ofSize: 15, weight: .bold)
            titleLabel.textColor = UIColor.dd.color(hexValue: 0xffffff)
            titleLabel.text = model.title
            sectionView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(20)
                make.height.equalTo(30)
            }
            if String.isAvailable(model.content) {
                let label = UILabel()
                label.font = .systemFont(ofSize: 14)
                label.numberOfLines = 0
                label.textColor = ThemeColor.gray.color()
                label.text = model.content
                sectionView.addSubview(label)
                label.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.top.equalTo(titleLabel.snp.bottom).offset(20)
                    make.bottom.equalToSuperview().offset(-20)
                }
            } else {
                //内容
                var posView: UIView = titleLabel
                for index in 0..<model.list.count {
                    let item = model.list[index]
                    //每个回答
                    let itemView = UIView()
                    sectionView.addSubview(itemView)
                    itemView.snp.makeConstraints { make in
                        make.left.equalToSuperview()
                        make.right.equalToSuperview()
                        make.top.equalTo(posView.snp.bottom).offset(20)
                        if index == model.list.count - 1 {
                            make.bottom.equalToSuperview().offset(-20)
                        }
                    }
                    posView = itemView
                    
                    //问题
                    let question = (item["Q"] as? String) ?? ""
                    let questionView = QAView()
                    questionView.updateQuestion(question: question)
                    itemView.addSubview(questionView)
                    questionView.snp.makeConstraints { make in
                        make.left.right.equalToSuperview()
                        make.top.equalToSuperview().offset(23)
                    }
                    //回答
                    let answerList: [String] = (item["A"] as? [String]) ?? []
                    var answerPosView = questionView
                    for aIndex in 0..<answerList.count {
                        let answer = answerList[aIndex]
                        let answerView = QAView()
                        var icon: UIImage?
                        if aIndex == 0 {
                            icon = UIImage(named: "me_A1")
                        } else if aIndex == 1 {
                            icon = UIImage(named: "me_A2")
                        } else if aIndex == 2 {
                            icon = UIImage(named: "me_A3")
                        } else if answerList.count == 1 {
                            icon = UIImage(named: "me_A")
                        }
                        answerView.updateAnswer(icon: icon, answer: answer)
                        itemView.addSubview(answerView)
                        answerView.snp.makeConstraints { make in
                            make.left.right.equalToSuperview()
                            make.top.equalTo(answerPosView.snp.bottom).offset(14)
                            if aIndex == answerList.count - 1 {
                                make.bottom.equalToSuperview()
                            }
                        }
                        answerPosView = answerView
                    }
                    
                }
            }
            
            
            
        }
    }
}

extension QAVC {
    func _loadData() {
        let model = QAModel(title: "支付".localString, content: "")
        model.addQA(Q: "艺直购™ 支持的支付方式？", A: ["微信支付或银行转账支付。"])
        model.addQA(Q: "用户在下单后需多久完成支付？", A: ["下单后请在48小时内付款，逾时未支付订单会自动取消。"])
        model.addQA(Q: "微信为何支付失败？", A: ["微信零钱支付每年限额20万人民币；", "使用微信绑定银行卡支付需注意：不同银行的限额不同，额度无法自行调整，具体请至所在银行查询；", "当出现上述两种情况，或订单金额超过微信支付 限制时，推荐使用银行转账支付。"])
        model.addQA(Q: "如何使用银行转帐支付？", A: ["登录自持银行卡所在的银行手机app进行转账，并在转账时备注订单号及作品信息。"])
        model.addQA(Q: "银行转帐支付后，平台多久会确认支付状态？", A: ["平台将在1个工作日内确认转账支付订单并更新订单支付状态。"])
        self.list.append(model)
        
        self.list.append(model)
        
        let model1 = QAModel(title: "支付".localString, content: "艺直购™ Q&A中的内容构成对艺术品买卖协议的补充。如两者存在不一致之处，以艺直购Q&A中的内容为准；艺直购Q&A中未提及的内容，以艺术品买卖协议的约定为准。")
        self.list.append(model1)
        
        self.updateUI()
    }
}
