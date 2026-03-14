import UIKit
import Kingfisher
import DDUtils
import SwiftyJSON
import RxRelay
import MJRefresh
import FSPagerView

// 正确：显式声明遵守 FSPagerViewDataSource 和 FSPagerViewDelegate
class HomeBanner: DDView, FSPagerViewDataSource, FSPagerViewDelegate {

    // MARK: - 事件发布
    let clickPublish = PublishRelay<Int>()
    let scrollPublish = PublishRelay<Void>()

    // MARK: - 数据
    private var mList: [JSON] = []

    // MARK: - UI 组件
    public lazy var pagerView: FSPagerView = {
        let view = FSPagerView()
        view.dataSource = self
        view.delegate = self
        view.isInfinite = true
        view.automaticSlidingInterval = 3.0  // 使用 FSPagerView 自带的自动轮播
        view.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        
        // 全屏 itemSize
        let screenSize = UIScreen.main.bounds.size
        view.itemSize = screenSize
        view.interitemSpacing = 0
        
        return view
    }()

    public lazy var mPageControl: DDPageControl = {
        let pageControl = DDPageControl()
        return pageControl
    }()

    lazy var mBottomView: UIButton = {
        let btn = UIButton(type: .custom)
        return btn
    }()

    public lazy var mLogoButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.isUserInteractionEnabled = false
        btn.setImage(UIImage(named: "home_logo"), for: .normal)
        return btn
    }()

    public lazy var mNextButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.isUserInteractionEnabled = false
        btn.setImage(UIImage(named: "home_arrow"), for: .normal)
        return btn
    }()

    // MARK: - 生命周期
    override func createUI() {
        super.createUI()
        setupPagerView()
        setupPageControl()
        setupBottomView()
        bindEvents()
        addSwipeGesture()  // 添加上滑手势
    }

    // MARK: - 布局
    private func setupPagerView() {
        addSubview(pagerView)
        pagerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupPageControl() {
        addSubview(mPageControl)
        mPageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(40)
            make.width.equalToSuperview()
            make.height.equalTo(20)
        }
    }

    private func setupBottomView() {
        addSubview(mBottomView)
        mBottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(100)
        }

        mBottomView.addSubview(mNextButton)
        mNextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
            make.width.height.equalTo(18)
        }

        mBottomView.addSubview(mLogoButton)
        mLogoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(mNextButton.snp.top).offset(-10)
            make.width.equalTo(140)
            make.height.equalTo(18)
        }
    }

    // MARK: - 事件绑定
    private func bindEvents() {
        _ = mBottomView.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.scrollPublish.accept(())
        })
    }

    // MARK: - 添加上滑手势
    private func addSwipeGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        pagerView.addGestureRecognizer(panGesture)
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: pagerView)
        switch gesture.state {
        case .ended, .cancelled:
            if translation.y < -50 {  // 上滑超过 50pt 触发
                scrollPublish.accept(())
            }
        default:
            break
        }
    }

    // MARK: - 外部接口
    func updateUI(list: [JSON]) {
        mList = list
        mPageControl.numberOfPages = list.count
        pagerView.reloadData()
    }

    // MARK: - FSPagerViewDataSource
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return mList.count
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = nil
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true

        let urlString = mList[index]["banner_url"].stringValue
        if let url = URL(string: urlString) {
            cell.imageView?.kf.setImage(with: url)
        }
        return cell
    }

    // MARK: - FSPagerViewDelegate
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        clickPublish.accept(index)
    }

    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        mPageControl.currentPage = pagerView.currentIndex
    }
}
