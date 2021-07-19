//
//  UIButtonExtension.swift
//  calculadora
//
//  Created by MacBook on 18/07/21.
//

import UIKit

private let orange = UIColor(red: 254/255, green: 148/255, blue: 0/255, alpha: 1)

extension UIButton {
    
    /// Redondeado de boton
    public func round() -> Void {
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
    }
    
    /// Animacion de rebote
    public func bounce() -> Void {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (completion) in
            self.transform = .identity
        }
    }
    
    /// Animacion de billo
    public func shine() -> Void {
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0.5
        }) { (completion) in
            self.alpha = 1
        }
    }
    
    /// Animacion de salto
    public func jump() -> Void {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(translationX: 10, y: 0)
        }) { (completion) in
            self.transform = .identity
        }
    }
    
    /// Apariencia de selecciona de boton de operacion
    /// - Parameter selected: Estado de seleccion
    public func selecteOperation(_ selected: Bool) -> Void {
        backgroundColor = selected ? .white : orange
        setTitleColor(selected ? orange : .white, for: .normal)
    }
}
