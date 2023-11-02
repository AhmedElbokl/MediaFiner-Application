//
//  MediaVC.swift
//  Media Finder
//
//  Created by ReMoSTos on 26/05/2023.
//

import UIKit
import SDWebImage
import AVKit

class MediaVC: UIViewController {
    
    //MARK: properties
    var segmentControlValue: String = ""
    var resultsArr: [ArtistData] = []
    var navigationBar: UINavigationBar!
    var baseURL: String = ""
    var artistName: [String] = []
    var lonDescription: [String] = []
    var picArr: [URL] = []
    var convertPic: [Data] = []
    
    //MARK: outlets
    @IBOutlet weak var mediaTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: segmented Function
    
    @IBAction func segmentedControllerValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            segmentControlValue = ""
        case 1:
            segmentControlValue = "&media=music"
        case 2:
            segmentControlValue = "&media=movie"
        case 3:
            segmentControlValue = "&media=tvShow"
        default:
            segmentControlValue = "&media=all"
        }
        handelSearchProcess()
    }
  
    
    //MARK: lifeCycleMethode
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        let def = UserDefaults.standard
        def.setValue(true, forKey: UserDefaultsKeys.isLoggedIn)
        mediaTableView.delegate = self
        mediaTableView.dataSource = self
        searchBar.delegate = self
        mediaTableView.register(UINib(nibName: "MediaTableViewCell", bundle: nil), forCellReuseIdentifier: "MediaTableViewCell")
        
       
        
        // handel navigation bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Go Profile", style: .plain, target: self, action: #selector(GoToProfileVCTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Go History", style: .plain, target: self, action: #selector(GoToHistoryVCTapped))
       
    }
    
    @objc func GoToProfileVCTapped() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.main, bundle: nil)
        let profilVC: ProfileVC = mainStoryboard.instantiateViewController(withIdentifier: Views.profileVC) as! ProfileVC
        self.navigationController?.pushViewController(profilVC, animated: true)
    }
    @objc func GoToHistoryVCTapped() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.main, bundle: nil)
        let historyVC: HistoryVC = mainStoryboard.instantiateViewController(withIdentifier: Views.historyVC) as! HistoryVC
        self.navigationController?.pushViewController(historyVC, animated: true)
    }
    
    
    //MARK: playing function
    private func playingPreview(for media: ArtistData) {
        if let previewUrl = URL(string: media.previewUrl ?? "") {
            let player = AVPlayer(url: previewUrl)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            present(playerViewController, animated: true) {
                playerViewController.player?.play()
                if media.kind == "song" {
                    let imageView = UIImageView(image: UIImage(named: "image"))
                    imageView.contentMode = .scaleAspectFit
                    playerViewController.contentOverlayView?.addSubview(imageView)
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        imageView.leadingAnchor.constraint(equalTo: playerViewController.contentOverlayView!.leadingAnchor),
                        imageView.trailingAnchor.constraint(equalTo: playerViewController.contentOverlayView!.trailingAnchor),
                        imageView.topAnchor.constraint(equalTo: playerViewController.contentOverlayView!.topAnchor),
                        imageView.bottomAnchor.constraint(equalTo: playerViewController.contentOverlayView!.bottomAnchor)
                    ])
                }
            }
        }
    }
    
    
}


//MARK: Extention for search bar
extension MediaVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        handelSearchProcess()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        handelSearchProcess()
    }
    
    private func handelSearchProcess(){
        guard let searchText = searchBar.text else {
            return
        }
        
        let convertedSearchText = convertSearchBarText(searchText)
        let  baseURL = "https://itunes.apple.com/search?term=\(convertedSearchText)\(segmentControlValue)"
        APIManager.shared.getArtistData(baseURL: baseURL) { error, artistArr in
            if let error = error {
                print(error.localizedDescription)
            } else if let artistArr = artistArr {
                self.resultsArr = artistArr
               // self.lastSearchString.append(baseURL)
                print("got data\(artistArr)")
                self.mediaTableView.reloadData()
            }
        }
    }
    
    private func convertSearchBarText(_ text: String) -> String {
        let convertedText = text.replacingOccurrences(of: " ", with: "+")
        return convertedText
    }
}


//MARK: extension for table view
extension MediaVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mediaTableView.dequeueReusableCell(withIdentifier: "MediaTableViewCell", for: indexPath) as? MediaTableViewCell else {return UITableViewCell() }
        // let item = movies[indexPath.row]
        let media = resultsArr[indexPath.row]
        let kind = media.kind
        cell.mediaImageView.sd_setImage(with: URL(string: media.artworkUrl100 ?? ""))
        if kind == "song" {
            cell.mediaTitleLabel.text = media.trackName
            cell.mediaDescriptionLabel.text = media.artistName
        } else if kind == "feature-movie" {
            cell.mediaTitleLabel.text = media.trackName
            cell.mediaDescriptionLabel.text = media.longDescription
        } else if kind == "tv-episode" {
            cell.mediaTitleLabel.text = media.artistName
            cell.mediaDescriptionLabel.text = media.longDescription
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let media = resultsArr[indexPath.row]
        playingPreview(for: media)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Hide") { action, indexPath in
            self.resultsArr.remove(at: indexPath.row)
            self.mediaTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return [deleteAction]
    }
    
}
