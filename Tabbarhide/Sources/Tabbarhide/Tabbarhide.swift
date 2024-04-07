// The Swift Programming Language
// https://docs.swift.org/swift-book

//
//  TabExtension.swift
//  Tabbarhide
//
//  Created by Doğanay Şahin on 7.04.2024.
//

import Foundation
import UIKit
import SwiftUI

public extension UITabBar {

    static func isHidden(_ completion: @escaping (Bool) -> Void)  {
        DispatchQueue.main.async {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            windowScene?.windows.first(where: { $0.isKeyWindow })?.allSubviews().forEach({ (v) in
                if let view = v as? UITabBar {
                    completion(view.isHidden)
                }
            })
        }
    }

    static func toogleTabBarVisibility(animated: Bool = true) {
        UITabBar.isHidden { isHidden in
            if isHidden {
                UITabBar.showTabBar(animated: animated)
            }
            else {
                UITabBar.hideTabBar(animated: animated)
            }
        }
    }

    static func showTabBar(animated: Bool = true) {
        DispatchQueue.main.async {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            windowScene?.windows.first(where: { $0.isKeyWindow })?.allSubviews().forEach({ (v) in
                if let view = v as? UITabBar {
                    view.setIsHidden(false, animated: animated)
                }
            })
        }
    }

    static func hideTabBar(animated: Bool = true) {
        DispatchQueue.main.async {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            windowScene?.windows.first(where: { $0.isKeyWindow })?.allSubviews().forEach({ (v) in
                if let view = v as? UITabBar {
                    view.setIsHidden(true, animated: animated)
                }
            })
        }
    }

    private static func updateFrame(_ view: UIView) {
        if let sv =  view.superview {
            let currentFrame = sv.frame
            sv.frame = currentFrame.insetBy(dx: 0, dy: 1)
            sv.frame = currentFrame
        }
    }

    private func setIsHidden(_ hidden: Bool, animated: Bool) {
        let isViewHidden = self.isHidden

        if animated {
            if self.isHidden && !hidden {
                self.isHidden = false
                Self.updateFrame(self)
                self.frame.origin.y = UIScreen.main.bounds.height + 200
            }

            if isViewHidden && !hidden {
                self.alpha = 0.0
            }

            UIView.animate(withDuration: 0.8, animations: {
                self.alpha = hidden ? 0.0 : 1.0
            })
            UIView.animate(withDuration: 0.6, animations: {

                if !isViewHidden && hidden {
                    self.frame.origin.y = UIScreen.main.bounds.height + 200
                }
                else if isViewHidden && !hidden {
                    self.frame.origin.y = UIScreen.main.bounds.height - self.frame.height
                }
            }) { _ in
                if hidden && !self.isHidden {
                    self.isHidden = true
                    Self.updateFrame(self)
                }
            }
        } else {
            if !isViewHidden && hidden {
                self.frame.origin.y = UIScreen.main.bounds.height + 200
            }
            else if isViewHidden && !hidden {
                self.frame.origin.y = UIScreen.main.bounds.height - self.frame.height
            }
            self.isHidden = hidden
            Self.updateFrame(self)
            self.alpha = 1
        }
    }
}




extension UIView {

    func allSubviews() -> [UIView] {
        var allSubviews = subviews
        for subview in subviews {
            allSubviews.append(contentsOf: subview.allSubviews())
        }
        return allSubviews
    }
}


public extension View {
    func showTabBar(animated: Bool = true) -> some View {
        return self.modifier(ShowTabBar(animated: animated))
    }
    func hideTabBar(animated: Bool = true) -> some View {
        return self.modifier(HiddenTabBar(animated: animated))
    }

    func shouldHideTabBar(_ hidden: Bool, animated: Bool = true) -> AnyView {
        if hidden {
            return AnyView(hideTabBar(animated: animated))
        } else {
            return AnyView(showTabBar(animated: animated))
        }
    }
}



struct ShowTabBar: ViewModifier {
    var animated = true
    func body(content: Content) -> some View {
        return content.padding(.zero).onAppear {
            UITabBar.showTabBar(animated: animated)
        }
    }
}


struct HiddenTabBar: ViewModifier {
    var animated = true

    func body(content: Content) -> some View {
        return content.padding(.zero).onAppear {
            UITabBar.hideTabBar(animated: animated)
        }
    }
}
