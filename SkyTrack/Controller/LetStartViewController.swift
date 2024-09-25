
import UIKit
import AVFoundation


class LetStartViewController: UIViewController {
   
    
    // Outlet for the view where you want to display the video
       var player: AVPlayer?
       var playerLayer: AVPlayerLayer?
     
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var videoBackgroundView: UIView!
    
    @IBOutlet weak var startButton: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      //  BackgroundImage.isHidden = true
       setupBackgroundVideo()
        configureButton(startButton)
        configureLogoImage(logoImage)
        
        print(" we are here in viewdidload method")
        
    }
    
    func configureLogoImage(_ image: UIImageView) {
        
        image.layer.cornerRadius = image.frame.height / 2
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        
    }
    func configureButton(_ button: UIButton) {
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
    }
    
    
    @IBAction func letstartButtonPressed(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(identifier:"WeatherEntryViewController" ) as? WeatherEntryViewController {
            print("We are going to the WeatherViewController")
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            print("Something went wrong")
        }
    }
    
    
    func setupBackgroundVideo() {
        // Load the video file
        guard let path = Bundle.main.path(forResource: "clearSky", ofType: "mp4") else {
            print("Error: Video file not found!")
            return
        }
        let url = URL(fileURLWithPath: path)

        // Create the AVPlayer
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)

        // Create the AVPlayerLayer
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        playerLayer?.frame = videoBackgroundView.bounds
        videoBackgroundView.layer.insertSublayer(playerLayer!, at: 0)

        // Start playing the video
        player?.play()

        // Call loopVideo to ensure the video loops infinitely
        loopVideo(videoPlayer: player!)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = videoBackgroundView.bounds
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var shouldAutorotate: Bool {
        return false
    }

    deinit {
        // Cleanup
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        player = nil
        NotificationCenter.default.removeObserver(self)
        print("ViewController deinitialized and resources cleaned up")
    }

    // Method to loop the video
    func loopVideo(videoPlayer: AVPlayer) {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: videoPlayer.currentItem, queue: .main) { notification in
            videoPlayer.seek(to: .zero)
            videoPlayer.play()
        }
    }
    
}
