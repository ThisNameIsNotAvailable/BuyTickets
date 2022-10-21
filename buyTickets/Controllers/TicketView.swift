//
//  TicketView.swift
//  buyTickets
//
//  Created by Alex on 10/06/2022.
//

import Foundation
import UIKit

class TicketView {
    private let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        return backgroundView
    }()
    private let ticketView: UIView = {
        let ticketView = UIView()
        ticketView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        ticketView.layer.masksToBounds = true
        ticketView.layer.cornerRadius = 12
        return ticketView
    }()
    
    private var myTargetView: UIView?
    private let backgroundAlphaTo: CGFloat = 0.6
    
    func generateBarcode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    func showTicketView(title: String,
                        seat: Int,
                        start: String,
                        target: String,
                        date: String,
                        on viewController: UIViewController) {
        guard let targetView = viewController.view else {
            return
        }
        myTargetView = targetView
        backgroundView.frame = targetView.bounds
        targetView.addSubview(backgroundView)
        
        
        ticketView.frame = CGRect(x: 40, y: -400, width: targetView.frame.size.width-80, height: 400)
        targetView.addSubview(ticketView)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: ticketView.frame.size.width, height: 60))
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 30)
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        titleLabel.textColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        ticketView.addSubview(titleLabel)
        
        let seatLabel = UILabel(frame: CGRect(x: 5, y: 50, width: ticketView.frame.size.width, height: 70))
        seatLabel.text = "SEAT: \(seat)"
        seatLabel.font = UIFont.systemFont(ofSize: 28)
        seatLabel.textAlignment = .left
        seatLabel.textColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        ticketView.addSubview(seatLabel)
        
        let startLabel = UILabel(frame: CGRect(x: 5, y: 100, width: ticketView.frame.size.width, height: 70))
        startLabel.text = "From: \(start)"
        startLabel.font = UIFont.systemFont(ofSize: 20)
        startLabel.textAlignment = .left
        startLabel.textColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        ticketView.addSubview(startLabel)
        
        let targetLabel = UILabel(frame: CGRect(x: 5, y: 140, width: ticketView.frame.size.width, height: 70))
        targetLabel.text = "To: \(target)"
        targetLabel.font = UIFont.systemFont(ofSize: 20)
        targetLabel.textAlignment = .left
        targetLabel.textColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        ticketView.addSubview(targetLabel)
        
        let dateLabel = UILabel(frame: CGRect(x: 5, y: 180, width: ticketView.frame.size.width, height: 70))
        dateLabel.text = "Date: \(date)"
        dateLabel.font = UIFont.systemFont(ofSize: 20)
        dateLabel.textAlignment = .left
        dateLabel.textColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        ticketView.addSubview(dateLabel)
        
        let barcodeImage = generateBarcode(from: "\(start) \(target) \(seat)")
        let imageView = UIImageView(image: barcodeImage)
        imageView.frame = CGRect(x: ticketView.frame.width / 2 - 50, y: 240, width: 100, height: 100)
        
        ticketView.addSubview(imageView)
        
        let button = UIButton(frame: CGRect(x: 0, y: ticketView.frame.size.height - 50, width: ticketView.frame.size.width, height: 50))
        
        ticketView.addSubview(button)
        button.setTitle("Dismiss", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), for: .normal)
        
        button.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        button.addTarget(self, action: #selector(dismissTicket), for: .touchUpInside)
        UIView.animate(withDuration: 0.25, animations: {
            
            self.backgroundView.alpha = self.backgroundAlphaTo
        }, completion: { done in
            if done {
                UIView.animate(withDuration: 0.25, animations: {
                    self.ticketView.center = targetView.center
                })
            }
        })
    }
    
    @objc func dismissTicket() {
        guard let targetView = myTargetView else {
            return
        }

        UIView.animate(withDuration: 0.25, animations: {
            
            self.ticketView.frame = CGRect(x: 40, y: targetView.frame.size.height, width: targetView.frame.size.width-80, height: 400)
        }, completion: { done in
            if done {
                UIView.animate(withDuration: 0.25, animations: {
                    self.backgroundView.alpha = 0
                }) { done in
                    if done {
                        self.ticketView.removeFromSuperview()
                        self.backgroundView.removeFromSuperview()
                    }
                }
            }
        })
    }
}
