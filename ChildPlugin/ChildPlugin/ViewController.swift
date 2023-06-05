//
//  ViewController.swift
//  ChildPlugin
//
//  Created by yuhua Tang on 2023/6/5.
//

import UIKit

class LoadingViewController: UIViewController {
    private lazy var activityIndicator = UIActivityIndicatorView(style: .gray)

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // We use a 0.5 second delay to not show an activity indicator
        // in case our data loads very quickly.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.activityIndicator.startAnimating()
        }
    }
}

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

class ErrorViewController: UIViewController {
    var reloadHandler: () -> Void = {}
    var button = UIButton(type: .custom)
    override func viewDidLoad() {
         super.viewDidLoad()
        view.addSubview(button)
        button.setTitle("reTry", for: .normal)
        button.addTarget(self, action: #selector(retry), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
    @objc func retry() {
        reloadHandler()
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadItems()
    }
    
    private func loadItems() {
        let loadingViewController = LoadingViewController()
        add(loadingViewController)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            loadingViewController.remove()
            self?.handle()
        }
        
       
    }
}

private extension ViewController {
    func handle() {
        let errorViewController = ErrorViewController()

        errorViewController.reloadHandler = { [weak self] in
            self?.loadItems()
        }

        add(errorViewController)
    }
}
