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
            try session.setCategory(
                .playback,
                mode: .default
            )
            try session.setActive(true, options: .notifyOthersOnDeactivation )
            guard let url = url else {return}
            player = try AVAudioPlayer(contentsOf: URL(string: url) ?? URL(fileURLWithPath: ""))
            guard let player = player else {return}
            player.play()
        } catch {
            print("Error: \(error)")
        }
        setupRemoteCommandCenter()
        updateNowPlayingInfo(song: songs[curentIndex])
        setUISong(songs[curentIndex])
    }

    private func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.removeTarget(nil)
        commandCenter.pauseCommand.removeTarget(nil)
        commandCenter.nextTrackCommand.removeTarget(nil)
        commandCenter.previousTrackCommand.removeTarget(nil)

        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.player?.play()
            self?.isPlaying = true
            self?.setBtnPlayOrPause()
            return .success
        }
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.player?.pause()
            self?.isPlaying = false
            self?.setBtnPlayOrPause()
            return .success
        }
        commandCenter.nextTrackCommand.addTarget { [weak self] _ in
            self?.actionNextOrPrevios(true)
            return .success
        }
        commandCenter.previousTrackCommand.addTarget { [weak self] _ in
            self?.actionNextOrPrevios(false)
            return .success
        }
    }

    private func updateNowPlayingInfo(song: Song) {
        var info = [String: Any]()
        info[MPMediaItemPropertyTitle] = song.name
        info[MPMediaItemPropertyArtist] = song.performer
        info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player?.currentTime
        info[MPMediaItemPropertyPlaybackDuration] = player?.duration
        info[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0

        if let image = UIImage(named: song.thumbnail) {
            info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
        }

        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
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
        if let player = player {
            if isPlaying {
                player.pause()
            } else {
                player.play()
            }
            isPlaying = !isPlaying
            setBtnPlayOrPause()
            updateNowPlayingInfo(song: songs[curentIndex])
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
