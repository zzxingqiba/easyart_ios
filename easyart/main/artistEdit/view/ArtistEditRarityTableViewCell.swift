//
//  ArtistEditRarityTableViewCell.swift
//  easyart
//
//  Created by Damon on 2025/1/16.
//

import UIKit
import RxRelay

class ArtistEditRarityTableViewCell: DDTableViewCell {
    private var numberList: [String] = []
    let clickPublish = PublishRelay<Int>()
    let deletePublish = PublishRelay<Int>()
    let contentSizeChange = PublishRelay<Void>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.mArrowImageView.image = selected ? UIImage(named: "artist_edit_selected") :  UIImage(named: "artist_edit_normal")
        //选中
        self.mNumberContentView.isHidden = !selected
        self.mNumberContentView.snp.updateConstraints { make in
            make.height.lessThanOrEqualTo(selected ? MAXFLOAT : 10)
        }
    }
    
    override func createUI() {
        super.createUI()
        self.contentView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(23)
            make.left.equalToSuperview()
        }
        
        self.contentView.addSubview(mArrowImageView)
        mArrowImageView.snp.makeConstraints { make in
            make.centerY.equalTo(mTitleLabel)
            make.right.equalToSuperview()
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        
        self.contentView.addSubview(mNumberContentView)
        mNumberContentView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mTitleLabel.snp.bottom)
            make.height.lessThanOrEqualTo(10)
        }
        
        mNumberContentView.addSubview(mNumberTitleLabel)
        mNumberTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
        
        mNumberContentView.addSubview(mTextField)
        mTextField.snp.makeConstraints { make in
            make.top.equalTo(mNumberTitleLabel)
            make.right.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        mNumberContentView.addSubview(mNumberCollectionView)
        mNumberCollectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mTextField.snp.bottom).offset(23)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        
        self.contentView.addSubview(mLineView)
        mLineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mNumberContentView.snp.bottom).offset(15)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        self._bindView()
    }
    
    func updateUI(model: DDSearchMulFilterModel, SKUModel: ArtistEditSKUModel) {
        if let attributed = model.attributed {
            mTitleLabel.attributedText = attributed
        } else {
            mTitleLabel.text = model.title
        }
        
        self.numberList = SKUModel.numberList
        self.mNumberCollectionView.reloadData()
        self.mTextField.text = "\(SKUModel.stockNumber)"
    }

    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mArrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "artist_edit_normal"))
        return imageView
    }()
    
    lazy var mNumberContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mNumberTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "Total number of editions\n(Total amount of all editions of this work)".localString
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = ThemeColor.line.color().cgColor
        textField.layer.borderWidth = 0.5
        textField.textColor = ThemeColor.black.color()
        textField.textAlignment = .center
        textField.font = .systemFont(ofSize: 13)
        return textField
    }()
    
    lazy var mNumberCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: 80, height: 60)
        let tCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tCollection.tag = 2
        tCollection.allowsMultipleSelection = false
        tCollection.showsVerticalScrollIndicator = false
        tCollection.backgroundColor = UIColor.clear
        tCollection.delegate = self
        tCollection.dataSource = self
        tCollection.isScrollEnabled = false
        tCollection.register(ArtistEditRarityCollectionViewCell.self, forCellWithReuseIdentifier: "ArtistEditRarityCollectionViewCell")
        return tCollection
    }()
    
    lazy var mLineView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.line.color()
        return view
    }()

}

extension ArtistEditRarityTableViewCell {
    func _bindView() {
        _ = self.mNumberCollectionView.rx.observe(CGSize.self, "contentSize").subscribe(onNext: { [weak self] (contentSize) in
            guard let self = self, let contentSize = contentSize else { return }
                self.mNumberCollectionView.snp.updateConstraints { (make) in
                    make.height.equalTo(max(1, contentSize.height))
                }
            self.contentSizeChange.accept(())
        })
    }
}

extension ArtistEditRarityTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = numberList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistEditRarityCollectionViewCell", for: indexPath) as! ArtistEditRarityCollectionViewCell
        cell.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.clickPublish.accept(indexPath.item)
        }).disposed(by: cell.disposeBag)
        cell.deletePublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.deletePublish.accept(indexPath.item)
        }).disposed(by: cell.disposeBag)
        cell.updateUI(text: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
}
