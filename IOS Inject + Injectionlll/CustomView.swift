//
//  CustomView.swift
//  IOS Inject + Injectionlll
//
//  Created by Chanon Latt on 6/2/22.
//

import Foundation
import UIKit

final class CustomView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .yellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
