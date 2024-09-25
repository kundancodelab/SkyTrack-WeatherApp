
import UIKit
import AVFoundation


class LetStartViewController: UIViewController {
   
    
    // Outlet for the view where you want to display the video
       var player: AVPlayer?
       var playerLayer: AVPlayerLayer?
     
    @IBOutlet weak var videoBackgroundView: UIView!
    
    @IBOutlet weak var BackgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BackgroundImage.isHidden = true
       setupBackgroundVideo()
        
    }
    
    
    @IBAction func letstartButtonPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WeatherEntryViewController") as! WeatherEntryViewController
        self.navigationController?.pushViewController(vc, animated: true)
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
