import RxRelay
import SnapKit
import UIKit

// MARK: - 主类

class MineMenuTabView: DDView {
    let indexChange = PublishRelay<Int>()
    /// 记录指示器约束
    private var indicatorLeadingConstraint: Constraint?
    private var hasPerformedInitialLayout = false
    /// 多语言标题
    private let tabTitles = [
        "My Collection".localString,
        "My Artworks".localString
    ]

    private var currentIndex: Int = 0
    override func createUI() {
        super.createUI()

        addSubview(tabCollectionView)
        tabCollectionView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.bottom.equalTo(tabCollectionView.snp.bottom)
            make.height.equalTo(4)
            make.width.equalTo(30)
            make.bottom.equalToSuperview()
            indicatorLeadingConstraint = make.centerX.equalTo(tabCollectionView.snp.left).offset(0).constraint
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // 当collectionView的宽度确定后，更新指示器位置
        if !hasPerformedInitialLayout && tabCollectionView.bounds.width > 0 {
            // 使用当前选中的index
            hasPerformedInitialLayout = true
            updateIndicator(to: currentIndex, animated: false)
        }
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
        return cv
    }()

    lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.black.color()
        view.layer.cornerRadius = 2.5
        view.isUserInteractionEnabled = false
        return view
    }()
}

extension MineMenuTabView {
    private func updateIndicator(to index: Int, animated: Bool = true) {
        guard tabCollectionView.bounds.width > 0 else { return }
        let itemWidth = tabCollectionView.bounds.width / CGFloat(tabTitles.count)

        let centerX = CGFloat(index) * itemWidth + itemWidth / 2

        // 指示器左边距 = cell中心点 - 指示器一半宽度
        indicatorLeadingConstraint?.update(offset: centerX)

        if animated {
            // 弹性动画
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseInOut) {
                self.layoutIfNeeded()
            }

            // 添加微小的缩放脉冲
            UIView.animate(withDuration: 0.2, animations: {
                self.indicatorView.transform = CGAffineTransform(scaleX: 1.3, y: 1.2)
            }) { _ in
                UIView.animate(withDuration: 0.2) {
                    self.indicatorView.transform = .identity
                }
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
        indexChange.accept(indexPath.row) // 发送点击
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / CGFloat(tabTitles.count)
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
}
