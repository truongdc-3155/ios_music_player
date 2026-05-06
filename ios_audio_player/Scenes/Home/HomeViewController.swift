//
//  HomeViewController.swift
//  ios_audio_player
//
//  Created by dang.chi.truong on 4/5/26.
//

import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    var songs : [Song] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configTableView()
    }
    
    
    func configTableView() {
        songs = Song.getPlayList()
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "SongTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell") as? SongTableViewCell
        else { return UITableViewCell() }
        cell.configCell(song: songs[indexPath.row])
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        guard let detailViewController = storyboard?.instantiateViewController(withIdentifier: "ViewController") as?
                ViewController else {return}
        
        detailViewController.configSong(songs: songs, index: indexPath.row)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
