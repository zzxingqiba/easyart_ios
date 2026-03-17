import RxRelay
import SnapKit
import UIKit

// MARK: - 主类

class MineMenuTabView: DDView {
    let clickPublish = PublishRelay<Int>()
    /// 记录指示器约束
    private var indicatorLeadingConstraint: Constraint?
    /// 多语言标题
    private let tabTitles = [
        "My Collection".localString,
        "My Artworks".localString
    ]

    private var currentIndex: Int = 0
    override func createUI() {
        super.createUI()
        let tap = UITapGestureRecognizer(target: self, action: #selector(testTap))
           self.addGestureRecognizer(tap)
        addSubview(indicatorView)
        addSubview(tabCollectionView)
        tabCollectionView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
      
        indicatorView.snp.makeConstraints { make in
            make.top.equalTo(tabCollectionView.snp.bottom)
            make.height.equalTo(4)
            make.width.equalTo(10)
            indicatorLeadingConstraint = make.leading.equalToSuperview().constraint // ⭐️ 保存约束引用
        }
    }
    @objc func testTap() {
        print("整个视图被点击了")
    }
    // MARK: UI

    lazy var tabCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isUserInteractionEnabled = true
        cv.backgroundColor = ThemeColor.white.color()
        cv.showsHorizontalScrollIndicator = false
        cv.register(MineMenuTabItemView.self, forCellWithReuseIdentifier: "MineMenuTabCell")
        cv.delegate = self
        cv.dataSource = self
        cv.isScrollEnabled = false
        cv.backgroundColor = .red

        return cv
    }()

    lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.black.color()
        view.layer.borderWidth = 2
        view.isUserInteractionEnabled = false
        return view
    }()
}

extension MineMenuTabView {
    private func updateIndicator(to index: Int, animated: Bool = true) {
        let itemWidth = tabCollectionView.bounds.width / CGFloat(tabTitles.count)
        let targetX = CGFloat(index) * itemWidth

        indicatorLeadingConstraint?.update(offset: targetX)

        if animated {
            UIView.animate(withDuration: 0.25) {
                self.layoutIfNeeded()
            }
        } else {
            layoutIfNeeded()
        }
    }
}

extension MineMenuTabView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabTitles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MineMenuTabCell", for: indexPath) as! MineMenuTabItemView

        cell.title = tabTitles[indexPath.row]
        cell.isChoosed = indexPath.row == currentIndex
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentIndex = indexPath.row
        updateIndicator(to: indexPath.row)
        collectionView.reloadData()
        clickPublish.accept(indexPath.row) // 发送点击
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / CGFloat(tabTitles.count)
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
}
