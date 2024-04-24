//
//  BoardDetailView.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/24/24.
//

import UIKit
import Then
import SnapKit
import Kingfisher

final class BoardDetailView: BaseView {
    
    private let textViewDefaultHeight : Double = 300
    
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = DesignSystem.commonColorSet.white
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = true
        $0.bounces = false
    }
    
    private let contentsView = UIView().then {
        $0.backgroundColor = DesignSystem.commonColorSet.white
    }
    
    let title = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .heavy)
        $0.text = "[일반] 노엘 : 작년에 30만정도에 이어폰 샀는데 소리가"
        $0.numberOfLines = 2
    }
    
    let author = UIButton().then {
        $0.setTitle("가영짱짱", for: .normal)
        $0.setTitleColor(DesignSystem.commonColorSet.gray, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    private let createdAt = UILabel().then {
        $0.text = "2024.04.25 (목)"
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = DesignSystem.commonColorSet.gray
        $0.textAlignment = .left
    }
    
    let commentCountButton = CompleteButton(title: "0", image: UIImage(systemName: "note.text"), fontSize: 16, disable: false).then {
        $0.frame = CGRect(x: 0, y: 0, width: 80, height: 20)
    }
    
    lazy var textView = UITextView().then {
        $0.text = "아아아아"
        $0.font = .systemFont(ofSize: 18.5, weight: .bold)
        $0.isEditable = false
        $0.backgroundColor = .red
        $0.delegate = self
        $0.isScrollEnabled = false // 스크롤 비활성화
    }
    
    override func configureHierarchy() {
        
        addSubview(scrollView)
        scrollView.addSubview(contentsView)
        [title, author, createdAt, commentCountButton, textView].forEach { contentsView.addSubview($0) }
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        contentsView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
        
        title.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.lessThanOrEqualTo(120)
        }
        
        author.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(10)
            make.height.equalTo(30)
            make.width.equalTo(60)
            make.leading.equalTo(title)
        }
        
        createdAt.snp.makeConstraints { make in
            make.centerY.equalTo(author)
            make.height.equalTo(author)
            make.width.equalTo(130)
            make.leading.equalTo(author.snp.trailing).offset(10)
        }
        
        commentCountButton.snp.makeConstraints { make in
            make.centerY.equalTo(author)
            make.trailing.equalToSuperview().inset(10)
            make.size.equalTo(author)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(commentCountButton.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(5)
            make.height.equalTo(300)
            make.bottom.equalToSuperview()
        }
    }

    func updateUI(_ data : PostResponse) {
        title.text = data.title
        author.setTitle(data.creator.nick, for: .normal)
        createdAt.text = data.createdAt
        commentCountButton.setTitle(String(data.comments.count), for: .normal)
        
        textView.text = data.content1
        addTextViewImage(data)
    }
    
    private func addTextViewImage(_ data : PostResponse) {
        //MARK: - 특정 위치에 이미지 넣기
        let urlList = data.filesToUrl
        let imageLocation = data.content3ToImageLocation
        
        if !urlList.isEmpty && !imageLocation.isEmpty {
            (0..<urlList.count).forEach { _addTextViewImage(url: urlList[$0], location: imageLocation[$0])}
        } else if !urlList.isEmpty && imageLocation.isEmpty {
            var testLastLocation = data.content1.count
            
            (0..<urlList.count).forEach {
                _addTextViewImage(url: urlList[$0], location: imageLocation[testLastLocation])
                testLastLocation += 1
            }
        }
    }
    
    private func _addTextViewImage(url : URL, location: Int) {
        
        KingfisherManager.shared.downloader.downloadImage(with: url, options: [.requestModifier(AuthManager.kingfisherAuth())] ) { [weak self] result in
            
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                // 이미지 다운로드 성공 시 NSAttributedString을 만들어서 UITextView에 삽입
                let attachment = NSTextAttachment()
                attachment.image = imageResult.image
                let imageAttributedString = NSAttributedString(attachment: attachment)
                
                // 원하는 위치에 이미지 삽입
                let mutableAttributedString = NSMutableAttributedString(attributedString: textView.attributedText)
                let range = NSRange(location: location, length: 0) // 특정 위치 (예: 10번째 문자 뒤)
                mutableAttributedString.insert(imageAttributedString, at: range.location)
                textView.attributedText = mutableAttributedString
                textViewDidChange(textView)
                
            case .failure(let error):
                print("Image download failed: \(error)")
                
            }
        }
    }

}

extension BoardDetailView : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let sizeToFit = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        
        if sizeToFit.height > textViewDefaultHeight {
            textView.snp.updateConstraints { make in
                make.height.equalTo(sizeToFit)
            }
        }
    }
}
