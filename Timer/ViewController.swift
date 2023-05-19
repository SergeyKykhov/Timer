//
//  ViewController.swift
//  Timer
//
//  Created by Sergey Kykhov on 19.05.2023.
//

import UIKit

class ViewController: UIViewController {
    private lazy var animation = CABasicAnimation()
    private let circleLayer = CAShapeLayer()
    private lazy var timer = Timer()
    private lazy var timerCount = 0.0
    private lazy var tapButtonCount = 0

    private lazy var buttonStartPause: UIButton = {
        let buttonStartPause = UIButton(frame: CGRect(x: 160, y: 100, width: 100, height: 100))

        buttonStartPause.setTitle("Start", for: .normal)
        buttonStartPause.setTitle("Pause", for: .selected)
        buttonStartPause.setTitleColor(.black, for: .normal)
        buttonStartPause.layer.cornerRadius = 0.1 * buttonStartPause.bounds.size.width
        buttonStartPause.clipsToBounds = true
        buttonStartPause.backgroundColor = .white
        buttonStartPause.layer.masksToBounds = true
        buttonStartPause.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return buttonStartPause
    } ()

    private lazy var labelTimer: UILabel = {
        var label = UILabel(frame: CGRect(x: 160, y: 100, width: 160, height: 100))
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .white
        label.text = "00:00:00"
        return label
    } ()

    private lazy var labelInfo: UILabel = {
        var label = UILabel(frame: CGRect(x: 160, y: 100, width: 160, height: 100))
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textColor = .white
        label.text = "Press to start"
        return label
    } ()

    private lazy var shapeView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Circle")
        return imageView
    } ()

    // MARK: - lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupHierarchy()
        setupLayout()
        view.backgroundColor = .black
    }

    // MARK: - Private functions

    private func setupHierarchy() {
        view.addSubview(labelInfo)
        view.addSubview(labelTimer)
        view.addSubview(shapeView)
        view.addSubview(buttonStartPause)
        view.layer.addSublayer(circleLayer)
        animationShape()
    }

    private func setupLayout() {
        labelInfo.translatesAutoresizingMaskIntoConstraints = false
        labelTimer.translatesAutoresizingMaskIntoConstraints = false
        shapeView.translatesAutoresizingMaskIntoConstraints = false
        buttonStartPause.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            labelTimer.centerXAnchor.constraint(equalTo: shapeView.centerXAnchor, constant: 0),
            labelTimer.centerYAnchor.constraint(equalTo: shapeView.centerYAnchor, constant: -60),
            labelTimer.heightAnchor.constraint(equalToConstant: 150),
            labelTimer.widthAnchor.constraint(equalToConstant: 150),

            labelInfo.centerXAnchor.constraint(equalTo: shapeView.centerXAnchor),
            labelInfo.centerYAnchor.constraint(equalTo: shapeView.centerYAnchor, constant: -200),
            labelInfo.heightAnchor.constraint(equalToConstant: 300),
            labelInfo.widthAnchor.constraint(equalToConstant: 300),

            shapeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shapeView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            shapeView.heightAnchor.constraint(equalToConstant: 300),
            shapeView.widthAnchor.constraint(equalToConstant: 300),

            buttonStartPause.centerXAnchor.constraint(equalTo: shapeView.centerXAnchor, constant: 0),
            buttonStartPause.centerYAnchor.constraint(equalTo: shapeView.centerYAnchor, constant: 0),
            buttonStartPause.heightAnchor.constraint(equalToConstant: 40),
            buttonStartPause.widthAnchor.constraint(equalToConstant: 80)
        ])
    }

    @objc func animationShape() {
        let circlePath = UIBezierPath(arcCenter: view.center, radius: 126, startAngle: CGFloat(-Double.pi / 2), endAngle: CGFloat(3 * ((Double.pi) / 2)), clockwise: true)

        if labelTimer.text == "00:00:00" && labelInfo.text == "Press to start" {
        circleLayer.path = circlePath.cgPath
        circleLayer.lineWidth = 5
        circleLayer.strokeColor = UIColor.red.cgColor
        circleLayer.fillColor =  UIColor.clear.cgColor
        circleLayer.strokeStart = 0
        circleLayer.strokeEnd = 0
        } else if labelTimer.text == "00:00:00" && labelInfo.text == "Work Time" {
            circleLayer.path = circlePath.cgPath
            circleLayer.lineWidth = 5
            circleLayer.strokeColor = UIColor.red.cgColor
            circleLayer.fillColor =  UIColor.white.cgColor
            circleLayer.strokeStart = 0
            circleLayer.strokeEnd = 0
        } else if labelTimer.text == "00:00:00" && labelInfo.text == "Rest Time" {
            circleLayer.path = circlePath.cgPath
            circleLayer.lineWidth = 5
            circleLayer.strokeColor = UIColor.green.cgColor
            circleLayer.fillColor =  UIColor.white.cgColor
            circleLayer.strokeStart = 0
            circleLayer.strokeEnd = 0
        }
    }

    @objc func animationSetup(duration: Double) {
        animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1.07
        animation.duration = duration
        circleLayer.add(animation, forKey: "animation")
    }

    func timerUpdate() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerSetup), userInfo: nil, repeats: true)
    }

    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }

    @objc func timerSetup() {
        timerCount -= 0.01
        labelTimer.text = timeString(time: TimeInterval(timerCount))

        if labelTimer.text == "00:00:00" && labelInfo.text == "Work Time" {
            timer.invalidate()
            timerRest()
        } else if labelTimer.text == "00:00:00" && labelInfo.text == "Rest Time" {
            timerCount = 5
            timer.invalidate()
            timerWork()
        }
    }

    func timerWork() {
        timerCount = 15
        timerUpdate()
        animationSetup(duration: Double(timerCount))
        circleLayer.strokeColor = UIColor.red.cgColor
        labelTimer.text = timeString(time: TimeInterval(timerCount))
        labelInfo.text = "Work Time"
        labelInfo.textColor = .white
    }

    func timerRest() {
        timerCount = 15
        timerUpdate()
        animationSetup(duration: Double(timerCount))
        circleLayer.strokeColor = UIColor.green.cgColor
        labelTimer.text = timeString(time: TimeInterval(timerCount))
        labelInfo.text = "Rest Time"
        labelInfo.textColor = .white
    }

    // MARK: - Actions

    @objc func buttonAction() {
        tapButtonCount = tapButtonCount +  1

        if  labelInfo.text == "Press to start" {
            buttonStartPause.isSelected = true
            timerWork()
        } else if labelInfo.text == "Work Time" {
            buttonStartPause.isSelected = false
            labelInfo.text = "Pause"
            timer.invalidate()
            circleLayer.pauseAnimation()
        } else if tapButtonCount % 2 != 0 && labelInfo.text == "Pause" {
            buttonStartPause.isSelected = true
            timerUpdate()
            labelTimer.text = timeString(time: TimeInterval(timerCount))
            labelInfo.text = "Work Time"
            labelInfo.textColor = .white
            circleLayer.resumeAnimation()
        } else if labelInfo.text == "Rest Time" {
            buttonStartPause.isSelected = false
            labelInfo.text = "Pause"
            timer.invalidate()
            circleLayer.pauseAnimation()
        } else if tapButtonCount % 2 != 0 && labelInfo.text == "Pause" {
            buttonStartPause.isSelected = true
            timerUpdate()
            labelTimer.text = timeString(time: TimeInterval(timerCount))
            labelInfo.text = "Rest Time"
            labelInfo.textColor = .white
            circleLayer.resumeAnimation()
        }
    }
}

extension CALayer
{
    func pauseAnimation() {
        if isPaused() == false {
            let pausedTime = convertTime(CACurrentMediaTime(), from: nil)
            speed = 0.0
            timeOffset = pausedTime
        }
    }

    func resumeAnimation() {
        if isPaused() {
            let pausedTime = timeOffset
            speed = 1.0
            timeOffset = 0.0
            beginTime = 0.0
            let timeSincePause = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
            beginTime = timeSincePause
        }
    }

    func isPaused() -> Bool {
        return speed == 0
    }
}


