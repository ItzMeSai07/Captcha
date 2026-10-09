import UIKit
import AVFoundation

class ViewController: UIViewController
{

    @IBOutlet var captchaImageView1: CaptchaImageView!
    @IBOutlet var captchaImageView2: CaptchaImageView!
    @IBOutlet var captchaImageView3: CaptchaImageView!
    @IBOutlet var captchaImageView4: CaptchaImageView!
    
    var correctImageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    
    var audioFiles = ["alien_cku3k", "cassette_t6phm", "chord_e6jv9", "electricity_bp5k6", "helicopter_nt6v5", "magic_x6tj8", "ocean_8cd65", "robot_cgy3e", "scratched_rv6te"]
    var audioPlayer: AVAudioPlayer?

    var correctAudioAnswer: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("❌ Audio session error: \(error.localizedDescription)")
        }
        
        loadRandomCaptchaImages()
        addTapGestures()
        
    }

    func loadRandomCaptchaImages() {
        // Use your image names as both the image names and the correct answers
        let imageNames = ["2b827", "2bg48", "2cegf", "2cg58", "2cgyx", "2en7g", "2enf4", "2fxgd", "2g7nm", "2g783"]
        
        // Randomly shuffle image names and pick 4 to display
        let shuffledImageNames = imageNames.shuffled().prefix(4)
        
        // Load the images using the correct filenames
        let images = shuffledImageNames.compactMap { UIImage(named: "\($0).png") } // Assuming images are named like 2b827.png
        
        if images.count == 4 {
            captchaImageView1.image = images[0]
            captchaImageView2.image = images[1]
            captchaImageView3.image = images[2]
            captchaImageView4.image = images[3]
            
            // Randomly pick one image as the correct one (the corresponding answer)
            let correctIndex = Int.random(in: 0..<4)
            correctImageView = [captchaImageView1, captchaImageView2, captchaImageView3, captchaImageView4][correctIndex]
            
            // The correct audio answer should match the correct image name
            correctAudioAnswer = shuffledImageNames[correctIndex]
            
            // Set the label with the correct image name (this is the correct answer)
            answerLabel.text = "Select: \(correctAudioAnswer ?? "")" // Show the correct image name as the answer
        }
    }
    
    func addTapGestures()
    {
        [captchaImageView1, captchaImageView2, captchaImageView3, captchaImageView4].forEach { imageView in
            imageView?.isUserInteractionEnabled = true
            imageView?.gestureRecognizers?.removeAll()
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageTap(_:)))
            imageView?.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func handleImageTap(_ sender: UITapGestureRecognizer) {
        if let tappedImageView = sender.view as? CaptchaImageView {
            if tappedImageView == correctImageView {
                print("Correct! Proceeding to the next screen...")
                answerLabel.text = "✅ You got it!"
                answerLabel.textColor = .green
            } else {
                print("Incorrect! Try again.")
                answerLabel.text = "❌ Try again!"
                answerLabel.textColor = .red
                tappedImageView.shake()
                loadRandomCaptchaImages()
            }
        }
    }
    
    func playRandomAudioCaptcha() {
        guard let randomFile = audioFiles.randomElement() else {
            print("❌ No audio files found!")
            return
        }

        correctAudioAnswer = randomFile
        answerLabel.text = "Select: \(randomFile)" // ✅ Update the label with the correct answer

        if let asset = NSDataAsset(name: randomFile) {
            do {
                audioPlayer = try AVAudioPlayer(data: asset.data)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
                print("✅ Playing audio: \(randomFile)")
            } catch {
                print("❌ Error playing audio: \(error.localizedDescription)")
            }
        } else {
            print("❌ Error: Audio asset '\(randomFile)' not found!")
        }
    }
    
    @IBAction func captchaButtonTapped(_ sender: CaptchaButton)
    {
        print("🎯 Button tapped!") // Debug print statement
        playRandomAudioCaptcha() // Play the audio
        
        answerLabel.text = "Select: \(correctAudioAnswer ?? "")" // Show the answer the user needs to pick
            answerLabel.textColor = .black // Optionally set the text color to black
    }
    
    func transitionToSuperCoolScreen()
    {
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "NextScreenID") {
            nextVC.modalPresentationStyle = .fullScreen
            present(nextVC, animated: true)
        }
    }
}
