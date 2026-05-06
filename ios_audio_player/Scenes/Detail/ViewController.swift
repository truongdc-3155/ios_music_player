//
//  ViewController.swift
//  ios_audio_player
//
//  Created by dang.chi.truong on 4/5/26.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {
    
    @IBOutlet weak var thumbNailImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var performerLabel: UILabel!
    
    @IBOutlet weak var playOrPauseBtn: UIButton!
    
    @IBOutlet weak var slider: UISlider!
    
    private var player : AVAudioPlayer?
    
    private var songs = [Song]()
    
    private var curentIndex = 0
    
    private var isPlaying = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player?.stop()
    }
    
    
    private func initialize() {
        songs = Song.getPlayList()
        configure()
    }
    
    private func setUISong(_ song: Song) {
        thumbNailImageView.image = UIImage(named: song.thumbnail)
        titleLabel.text = song.name
        performerLabel.text = song.performer
        
        slider.maximumValue = Float(player?.duration ?? 0)
        slider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        
        Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
    }
    
    func configSong(songs: [Song], index: Int) {
        self.songs = songs
        self.curentIndex = index
    }
    
    private func configure() {
        let url = Bundle.main.path(forResource: songs[curentIndex].fileName, ofType: "mp3")
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setMode(.default)
            try session.setActive(true, options: .notifyOthersOnDeactivation )
            guard let url = url else {return}
            player = try AVAudioPlayer(contentsOf: URL(string: url) ?? URL(fileURLWithPath: ""))
            guard let player = player else {return}
            player.play()
        } catch {
            print("Error: \(error)")
        }
        setUISong(songs[curentIndex])
    }
    
    

    override func remoteControlReceived(with event: UIEvent?) {
        guard let type = event?.subtype else {return}
        
        switch type {
        case .remoteControlPlay:
            player?.play()
        case .remoteControlPause:
            player?.pause()
        case .remoteControlStop:
            player?.stop()
        case .remoteControlPreviousTrack:
             actionNextOrPrevios(false)
        case .remoteControlNextTrack:
             actionNextOrPrevios(true)
        default :
            break
        }
    }
    
    
    @objc private func updateSlider() {
        slider.value = Float(player?.currentTime ?? 0)
    }
    
    
    @objc private func didSlideSlider(_ slider: UISlider) {
        player?.currentTime = TimeInterval(slider.value)
        player?.prepareToPlay()
        isPlaying = true
        setBtnPlayOrPause()
        player?.play()
    }
    
    private func setBtnPlayOrPause() {
        playOrPauseBtn.setImage(UIImage(named: isPlaying ? "pause_circle" : "play_circle"), for:  .normal)
    }
    
    
    @IBAction func playOrPauseTapped(_ sender: Any) {
        if let player  = player {
            if isPlaying {
                player.pause()
            } else {
                player.play()
            }
            
            isPlaying = !isPlaying
            setBtnPlayOrPause()
        }
    }
    
     
    private func actionNextOrPrevios(_ isNext: Bool) {
        if isNext {
            if(curentIndex == songs.count - 1) {
                curentIndex = 0
            } else {
                if(curentIndex <= songs.count - 1) {
                    curentIndex  += 1
                } else {
                    curentIndex = 0
                }
            }
        } else {
            if(curentIndex == 0) {
                curentIndex = songs.count - 1
            } else {
                if(curentIndex >= 0) {
                    curentIndex  -= 1
                } else {
                    curentIndex = songs.count - 1
                }
            }
        }
        isPlaying = true
        configure()
        setBtnPlayOrPause()
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        actionNextOrPrevios(true)
    }
    
    
    @IBAction func previosTapped(_ sender: Any) {
        actionNextOrPrevios(false)
    }
    
}
