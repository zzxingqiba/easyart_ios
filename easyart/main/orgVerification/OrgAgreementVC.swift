//
//  OrgAgreementVC.swift
//  easyart
//
//  Created by 崭新的旧刀 on 2026/3/25.
//

import DDUtils
import RxRelay
import UIKit
import WebKit

class OrgAgreementVC: BaseVC {
    var profileModel = OrgProfileModel()
    var authorModel = OrgIntroModel()
    
    init(profileModel: OrgProfileModel) {
        super.init()
        self.profileModel = profileModel
        // 用户信息
        let userModel = DDUserTools.shared.userInfo.value
        // 审核被拒绝，编辑更新重新审核
        if userModel.role.status == 7 {
            self.authorModel.update(model: userModel.userRoleDetail)
        }
    }
    
    @available(*, unavailable)
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._bindView()
    }
    
    override func createUI() {
        super.createUI()
        
        self.mSafeView.addSubview(self.mRuleContentView)
        self.mRuleContentView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-120 - BottomSafeAreaHeight)
        }
        
        self.mSafeView.addSubview(self.mRuleView)
        self.mRuleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-80 - BottomSafeAreaHeight)
        }
        
        self.view.addSubview(self.mConfirmButton)
        self.mConfirmButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50 + BottomSafeAreaHeight)
        }
    }
    
    // MARK: UI

    lazy var mRuleContentView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences.preferredContentMode = .mobile
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.loadHTMLString(OrgAgreementVC.getOrgAgreementHtml(profile: self.profileModel), baseURL: nil)
        return webView
    }()
    
    lazy var mRuleView: DDRuleView = {
        let view = DDRuleView()
        view.updateRule(text: self._ruleText())
        view.mRuleTextView.delegate = self
        return view
    }()
    
    private(set) lazy var mConfirmButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.setBackgroundImage(UIImage.dd.getImage(color: ThemeColor.black.color()), for: .normal)
        tButton.setBackgroundImage(UIImage.dd.getImage(color: ThemeColor.gray.color()), for: .disabled)
        tButton.titleLabel?.font = .systemFont(ofSize: 14)
        tButton.setTitleColor(UIColor.dd.color(hexValue: 0xffffff), for: .normal)
        tButton.setTitle("Next step".localString, for: .normal)
        return tButton
    }()
}

extension OrgAgreementVC {
    func _ruleText() -> NSAttributedString {
        let mutAttStr = NSMutableAttributedString(string: "I have read and agree to the purchase agreement".localString, attributes: [.foregroundColor: UIColor.dd.color(hexValue: 0x000000)])
        mutAttStr.addAttributes([.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.dd.color(hexValue: 0x000000)], range: NSRange(location: 0, length: mutAttStr.length))
        
        return mutAttStr
    }
    
    func _bindView() {
        _ = self.mRuleView.selectChange.subscribe(onNext: { [weak self] isSelected in
            guard let self = self else { return }
            if isSelected {
                self.mConfirmButton.isEnabled = true
            } else {
                self.mConfirmButton.isEnabled = false
            }
        })
        
        _ = self.mConfirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            
            let vc = OrgUpdateCoverVC(profileModel: self.profileModel, model: self.authorModel)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
    
    static func getOrgAgreementHtml(profile: OrgProfileModel) -> String {
        return """
        <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
        <div style=" word-wrap: break-word;
        white-space: pre-line;
        font-size: 12px;
        font-family: sans-serif, system-ui;
                display: flex;
                flex-direction: column;">
                
                        <b>User Registration and Publishing Agreement
        
        </b>
                <p style="margin: 0;">In accordance with the applicable laws of Japan, and based on the principles of equality, voluntariness, fairness and reasonableness, this agreement is reached on matters related to Party A (artist)'s entry into Party B's (EURO-ASIA CAPITAL JAPAN CO., LTD.) platform (referring to Easyart Mobile Applications (APP), or other online sales platforms such as websites and WeChat Mini Programs Weixin Mini Programs developed or authorized by Party B). The specific terms and conditions are as follows:
        
                </p>
        
        <b>Registered Artist:</b>
        <p style="margin: 0;">If Party A needs to sell on Party B's platform, it shall submit a written application to Party B and provide corresponding materials according to Party B's requirements. After the application materials submitted by Party A are reviewed and approved by Party B in its own judgment, Party A will become a registered artist on Party B's platform. Party A irrevocably agrees that after Party A becomes a registered artist on Party B's platform, it shall abide by the applicable legal provisions, the provisions of this agreement and the platform management rules formulated by Party B's platform from time to time (if there is any conflict between such platform management rules and this agreement, this agreement shall govern; any and all matters not stipulated in this agreement shall govern the platform management rules and apply to all artists of the same type on Party B's platform).
        
        To complete the qualification review for Party A as a registered artist, Party A shall provide at least the following documents:
        
        </p>
        
        <b>Artist (Individual):</b>
        <p style="margin: 0;">Name: \(profile.name)
        Identification Document (Personal ID): \(profile.idNumber)
        Phone: \(profile.mobile)
        Contact Address: \(profile.address)
        Whether Party B purchases the artwork from Party A or licenses the copyright of the artwork, the Parties agree that Party B's payment to Party A is conditional upon the art buyer paying the full amount to Party B. Within seven(7) working days after Party B receives the full payment from the art buyer and Party A provides Party B with a valid full invoice, Party B will pay the corresponding amount to Party A. If Party B is required to withhold and pay income tax when making payments to Party A, Party B has the right to deduct such taxes and pay the remaining amount to Party A.
        
        If the art buyer (or licensee) ultimately fails to complete the transaction or the transaction is canceled for any reason, Party A's artwork or copyright license will be considered unsold and will revert to its pre-sale status for continued trading on Party B's platform; in this case, Party B has no obligation to pay Party A any amount related to the artwork.
        
        </p>
        
        <b>Breach of Contract:</b>
        <p style="margin: 0;">If Party A's art is not original, and/or Party A does not enjoy the complete intellectual property rights of the art (Except for rights defects that have been clearly notified to Party B when Party A uploads the art work), it shall be regarded as a material breach of contract by Party A, and Party B has the right to immediately unilaterally terminate this agreement and/or require Party A to bear any and all losses caused to Party B thereby, and Party A shall refund any and all of the funds received, including but not limited to income from sales of art works, art copyright authorizations, etc.
        If Party A fails to deliver the art to the place designated by Party B within a reasonable time as required by Party B as stipulated in this agreement, it shall be deemed a breach of contract by Party A, and Party B has the right to require Party A to pay a penalty of 14.6% per year based on the selling price of the art; If the art is still not delivered to the place designated by Party B within thirty(30) days, Party B has the right to immediately unilaterally terminate this agreement and/or require Party A to bear any and all losses caused to Party B thereby.
        
        </p>
        
        <b>Other Provisions:</b>
        <p style="margin: 0;">Term of Agreement: Unless this agreement is terminated early by either party in accordance with applicable laws or the provisions of this agreement, this agreement shall take effect after Party A reads and confirms the submission of the application, with a validity period of three(3) years. If neither party raises an objection after the expiration of the validity period, this agreement will automatically extend for one cycle, and all terms will continue to be effective.
        Artwork Preservation: During the term of the agreement, the artwork shall still be preserved by Party A in a manner that meets the preservation requirements of the artwork, and the risk shall be borne by the party preserving the artwork.
        
        </p>
        
        <b>Notice:</b>
        <p style="margin: 0;">Any and all documents, replies, and other communications sent by either party to the other party in accordance with this agreement shall be delivered in writing to the address or email address listed in this agreement for the other party. If either party intends to change the contact information, it shall notify in writing.
        
        </p>
        
        <b>Confidentiality Obligation:</b>
        <p style="margin: 0;">The Parties have a confidentiality obligation regarding this cooperation and the specific content of this agreement. Without the prior written consent of one party, the other party shall not disclose the content under this agreement to any third party, except as required by law.
        For the purpose of fulfilling this agreement, either party may disclose the aforementioned confidential information to employees or contractors who need it to perform their duties, but shall require them to maintain confidentiality.
        Party B may disclose the names of Party A and the original artist, as well as brief information about the artwork, to the public for the purpose of promoting the artwork. Such disclosure shall not be considered a breach of the confidentiality agreement.
        The confidentiality obligations are not limited by the term of this agreement and shall remain effective after the termination or dissolution of the agreement.
        
        </p>
        
        <b>Dispute Resolution and Applicable Law:</b>
        <p style="margin: 0;">This agreement shall be governed by and construed in accordance with the laws of Japan. Any and all disputes arising therefrom shall be resolved through negotiation between the Parties; if negotiation fails, the Tokyo District Court shall be the exclusive court of first instance for the agreement.
        
        </p>
        
        <b>Supplementary Provisions:</b>
        <p style="margin: 0;">The annexes (if any) to this agreement are an integral part of the agreement and have the same legal effect as the agreement.
        This agreement creates an independent contractual relationship solely between the Parties, and no provision shall be interpreted as forming a partnership or any other relationship that results in joint liability.
        
        </p>
        </div>
        """
    }
}

extension OrgAgreementVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if url.scheme == "HDRulePopUserRule" {
            return false
        } else if url.scheme == "HDRulePopPrivacy" {
            let vc = QLWebViewController(url: URL(string: WWWUrl_Base + "privacy/" + DDConfigTools.shared.getLanguage())!)
            DDUtils.shared.getCurrentVC()?.present(vc, animated: true)
            return false
        }
        return false
    }
}
