import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myButton = UIButton(type: .system)
        myButton.setTitle("Load Films", for: .normal)
        myButton.frame = CGRect(x: 100, y: 350, width: 200, height: 40)
        myButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        view.addSubview(myButton)
        
    }

    @objc func buttonTapped() {
        let filmViewController = FilmViewController()
        let navigationController = UINavigationController(rootViewController: filmViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
}

