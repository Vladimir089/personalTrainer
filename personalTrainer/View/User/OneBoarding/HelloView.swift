import UIKit

class HelloView: UIView {

    var currentIndex: Int = 0

    var dots: [UIView] = []

    var mainLabel, secondaryLabel: UILabel?

    var phoneImageView: UIImageView?

    weak var delegate: HelloViewControllerDelegate?
    
    var goButton: UIButton?
    
    private var shadowLayer: CAGradientLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        createInterface()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createInterface() {
        let backgroundImage = UIImage(named: "HelloVCBG")
        let backgroundImageView = UIImageView(image: backgroundImage)

        addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .equalSpacing

        for _ in 0..<3 {
            let dot = createDot()
            dots.append(dot)
            stackView.addArrangedSubview(dot)
        }

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(70)
        }

        mainLabel = UILabel()
        mainLabel?.text = "Track the results"
        mainLabel?.font = .systemFont(ofSize: 32, weight: .bold)
        mainLabel?.textColor = .white
        mainLabel?.textAlignment = .center
        addSubview(mainLabel ?? UIView())
        mainLabel?.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(30)
            make.top.equalTo(stackView.snp.bottom).inset(-15)
        })

        secondaryLabel = UILabel()
        secondaryLabel?.text = "Your athletes and teams"
        secondaryLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        secondaryLabel?.textColor = .white
        secondaryLabel?.textAlignment = .center
        addSubview(secondaryLabel ?? UIView())
        secondaryLabel?.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(30)
            make.top.equalTo(mainLabel!.snp.bottom).inset(-5)
        })
        
        let image = UIImage(named: "phone1")
        
        phoneImageView = UIImageView(image: image)
        addSubview(phoneImageView ?? UIView())
        phoneImageView?.snp.makeConstraints({ make in
            make.top.equalTo((secondaryLabel ?? UIView()).snp.bottom).offset(-70)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(phoneImageView!.snp.width).multipliedBy(2)
        })
        
        goButton = UIButton(type: .system)
        goButton?.setTitle("Next", for: .normal)
        goButton?.setTitleColor(.white, for: .normal)
        goButton?.backgroundColor = .primary
        goButton?.layer.cornerRadius = 8
        goButton?.addTarget(self, action: #selector(goNext), for: .touchUpInside)
        addSubview(goButton ?? UIView())
        goButton?.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        goButton?.snp.makeConstraints({ make in
            make.height.equalTo(48)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(50)
        })
    }

    func createDot() -> UIView {
        let dot = UIView()
        dot.layer.cornerRadius = 4
        dot.snp.makeConstraints { make in
            make.width.height.equalTo(8)
        }
        return dot
    }
    
    @objc func goNext() {
        delegate?.increment()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        addShadowLayer()
        if let goButton = goButton {
            bringSubviewToFront(goButton)
        }
    }

    func addShadowLayer() {
        shadowLayer?.removeFromSuperlayer()

        let newShadowLayer = CAGradientLayer()
        newShadowLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        newShadowLayer.startPoint = CGPoint(x: 0.5, y: 0.4)
        newShadowLayer.endPoint = CGPoint(x: 0.5, y: 0.9)
        newShadowLayer.frame = bounds

        layer.addSublayer(newShadowLayer)
        shadowLayer = newShadowLayer
    }
}
