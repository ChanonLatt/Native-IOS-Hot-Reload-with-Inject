//
//  ViewController.swift
//  IOS Inject + Injectionlll
//
//  Created by Chanon Latt on 5/13/22.
//

import UIKit
import Inject

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        let avata = UIImageView()
            .chainable
            .tintColor(.white)
            .image(UIImage(systemName: "person")?.withRenderingMode(.alwaysTemplate))
            .contentMode(.scaleAspectFit)
            .isClipsToBounds(true)
            .wrapped
        
        let avataWrapper = VStack { avata }
            .margin(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
            .withBackground(.systemPink)
        
        avataWrapper
            .chainable
            .cornerRadius(150)
            .wrapped
            .snp
            .make {
            $0.size.equalTo(300)
        }
        
        let name = UILabel()
            .chainable
            .text("Chanon latt")
            .font(.boldSystemFont(ofSize: 30))
            .textColor(.white)
            .textAlignment(.center)
            .wrapped
        
        let des = UILabel()
            .chainable
            .text("IOS Developer")
            .numberOfLines(2)
            .textColor(.white)
            .textAlignment(.center)
            .wrapped
        
        let testHotReloadCustomView = Inject.ViewHost(CustomView())
        testHotReloadCustomView.snp.makeConstraints {
            $0.height.equalTo(200.0)
        }
        
        let container = VStack {
            avataWrapper
            name
            des
            testHotReloadCustomView
        }.spacing(8.0)
        
        view.addSubview(container)
        container.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
    }
}

