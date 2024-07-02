import UIKit

final class CommentDetailView: UIView {
    
    // MARK: - Properties
    
    /// init 시점에 필요한 파라미터가 없으므로 옵셔널 or 강제언래핑이 아닌 객체를 선언하고 시작
    private var viewModel: CommentDetailViewModel = CommentDetailViewModel()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "댓글"
        label.font = UIFont.systemFont(ofSize: 27, weight: .bold)
        return label
    }()
    
    private var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "xmark")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var commentTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        return tableView
    }()
    
    private var handleView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 3
        return view
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewModel.didUpdateComments = { [weak self] in
            DispatchQueue.main.async {
                self?.commentTableView.reloadData()
                self?.activityIndicator.stopAnimating()
            }
        }
        
        setupView()
        setupTableView()
        setupAutoLayout()
        setupPanGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }
    
    private func setupTableView() {
        commentTableView.dataSource = self
        commentTableView.delegate = self
        commentTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "CommentCell")
    }
    
    /// DetailVideoViewController 위에 CommentDetailView 를 올리기 위한 제약조건 함수
    func setupConstraints(relativeTo view: UIView, webView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: webView.bottomAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupAutoLayout() {
        let views = [handleView, label, closeButton, commentTableView, activityIndicator]
        
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        views.forEach(addSubview)
        
        NSLayoutConstraint.activate([
            handleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            handleView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            handleView.widthAnchor.constraint(equalToConstant: 40),
            handleView.heightAnchor.constraint(equalToConstant: 4),
            
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            
            closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            
            commentTableView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            commentTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            commentTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            commentTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        self.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        if gesture.state == .changed {
            self.transform = CGAffineTransform(translationX: 0, y: max(0, translation.y))
        } else if gesture.state == .ended {
            let velocity = gesture.velocity(in: self)
            if translation.y > 100 || velocity.y > 500 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
                }) { _ in
                    self.removeFromSuperview()
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.transform = .identity
                }
            }
        }
    }
    
    @objc private func closeButtonTapped() {
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    // 댓글 데이터를 요청하고 뷰모델을 통해 데이터 업데이트
    func fetchComments(for videoID: String) {
        activityIndicator.startAnimating()
        viewModel.fetchComments(for: videoID)
    }
}

// MARK: - UITableViewDataSource

extension CommentDetailView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfComments()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        
        if let comment = viewModel.comment(at: indexPath.row) {
            cell.configure(comments: comment)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CommentDetailView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
