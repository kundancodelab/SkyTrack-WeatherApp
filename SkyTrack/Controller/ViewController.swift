
import UIKit


class ViewController: UIViewController {

    
    @IBOutlet weak var weatherForecastingView: UIView!
    
    
    @IBOutlet weak var uiView: UIView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
         setUpBorderForUiView(uiView)
        setUpBorderForUiView(weatherForecastingView)
        
        // Create the gradient layer
        let gradientLayer = CAGradientLayer()

        // Define the gradient colors
        gradientLayer.colors = [
            UIColor(red: 8/255, green: 36/255, blue: 79/255, alpha: 1).cgColor,  // #08244F
            UIColor(red: 19/255, green: 76/255, blue: 181/255, alpha: 1).cgColor, // #134CB5
            UIColor(red: 11/255, green: 66/255, blue: 171/255, alpha: 1).cgColor  // #0B42AB
        ]
        

        // Define the start and end points
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)

        // Set the gradient's frame to the view's bounds
        gradientLayer.frame = view.bounds

        // Add the gradient layer to the view's layer
        view.layer.insertSublayer(gradientLayer, at: 0)
        // Auto layout, variables, and unit scale are not yet supported
        var view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 152, height: 27)

        var parent = self.view!
        parent.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 152).isActive = true
        view.heightAnchor.constraint(equalToConstant: 27).isActive = true
        view.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 41).isActive = true
        view.topAnchor.constraint(equalTo: parent.topAnchor, constant: 44).isActive = true
    }
    
    func setUpBorderForUiView(_ uiView:UIView){
        uiView.layer.borderWidth = 0.2
        uiView.layer.cornerRadius = 20
        uiView.layer.borderColor = UIColor.white.cgColor
        uiView.clipsToBounds = true
        //print("here comes uiview")
    }
}
