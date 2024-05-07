//
//  CALayer+Extension.swift
//  JustBoard
//
//  Created by JinwooLee on 4/25/24.
//

import UIKit

extension CALayer{
    func addBorder(_ arr_edge: [UIRectEdge], color:UIColor, width:CGFloat){
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x:0,y:0,width:frame.width,height:width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x:0,y:frame.height-width,width:frame.width,height:width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x:0,y:0,width:width,height:frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x:frame.width-width,y:0,width:width,height:frame.height)
                break
            default:
                break
            }
            border.backgroundColor=color.cgColor;
            self.addSublayer(border)
        }
    }
}

extension UIView {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            border.backgroundColor = color.cgColor
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect(x: 0, y: 0, width: frame.width, height: width)
            case UIRectEdge.bottom:
                border.frame = CGRect(x: 0, y: frame.height - width, width: frame.width, height: width)
            case UIRectEdge.left:
                border.frame = CGRect(x: 0, y: 0, width: width, height: frame.height)
            case UIRectEdge.right:
                border.frame = CGRect(x: frame.width - width, y: 0, width: width, height: frame.height)
            default:
                break
            }
            layer.addSublayer(border)
        }
    }
}
