//
//  ViewController.swift
//  NewsApp
//
//  Created by Grigoriy Korotaev on 29.04.2023.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    var newsData: Welcome!
    let mainView = MainView()
    let refreshControl = UIRefreshControl()
    let webVC = WebViewController()
    var url1 = URL(string: String())
    var activityIndicator : UIActivityIndicatorView!
    
    override func loadView() {
        view = mainView
        createRefresh()
        configurateTable()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        doneNews = UserDefaults.standard.object(forKey: keyID) as? [Int] ?? [Int]()
        updateNews()
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
   func configurateTable() {
       mainView.tableViewNews.delegate = self
       mainView.tableViewNews.dataSource = self
    }
    func createActivityindicator(){
        activityIndicator = UIActivityIndicatorView(style: .large)
        mainView.imageViewNT.addSubview(activityIndicator)
        activityIndicator.layer.zPosition = 1
        activityIndicator.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(150)
        }
    }
// MARK: - Refresh
    func createRefresh() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.tintColor = UIColor.clear
        mainView.tableViewNews.addSubview(refreshControl)
    }
    @objc func refreshData() {
        updateNews()
        refreshControl.endRefreshing()
    }

// MARK: - LoadApi
    func updateNews() {
        createActivityindicator()
        activityIndicator.startAnimating()
        ArrayNews = [localNewsStruct]()
        let session = URLSession.shared
        let url = URL(string:"https://api.nytimes.com/svc/mostpopular/v2/emailed/7.json?api-key=62bDjJ7MWGURnrB7CgD6KEbzvpJsWqgd")!
        let task = session.dataTask(with: url){ (data, response, error) in
            guard error == nil else {
                return }
            do {
                self.newsData = try JSONDecoder().decode(Welcome.self, from: data!)
                DispatchQueue.main.async {
                    self.redefineLocalStruct(data: self.newsData)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    // MARK: - FormatStruct
    
    func redefineLocalStruct(data: Welcome){
        let newsArray = data.results
        var i = 0
        var imageURL = String()
        for news in newsArray {
            imageURL = String()
            
            if newsArray[i].media.isEmpty == false {
                let lastIndex = newsArray[i].media[0].mediaMetadata.endIndex - 1
                imageURL = newsArray[i].media[0].mediaMetadata[lastIndex].url
            }
            var newImage = UIImage()
                if let url = URL(string: imageURL) {
                    do {
                        let data = try Data(contentsOf: url)
                        newImage = UIImage(data: data) ?? UIImage()
                    } catch {
                        print("error loading image")
                    }
                }
            let newsURL = newsArray[i].url
            let newsID = newsArray[i].id
            let newsStatus = checkStasusNews(news: newsArray[i])
            let newNews = localNewsStruct(status: newsStatus, title: news.title, image: newImage, id: newsID, url: newsURL)
                ArrayNews.append(newNews)
                i += 1
            }
        activityIndicator.stopAnimating()
        self.mainView.tableViewNews.reloadData()
    }
    
    func checkStasusNews(news: Result) -> statusNews{
        let newsId = news.id
        var status = statusNews.noRead
        for i in doneNews {
            if i == newsId{
                status = .read
            }
        }
        return status
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrayNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "news", for: indexPath) as! TableViewCellNews
            cell.layer.borderWidth = 1
        cell.cellLabel.text = ArrayNews[indexPath.row].title
        cell.imageViewNews.image = ArrayNews[indexPath.row].image
        cell.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
        mainView.setupStatusView(status: ArrayNews[indexPath.row].status!, label: cell.statusLabel, view: cell.statusView)
            return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        webVC.currentNews = localNewsStruct(title: ArrayNews[indexPath.row].title, url: ArrayNews[indexPath.row].url)
        webVC.configurateWeb()
        shiftStatus(news: ArrayNews[indexPath.row])
        mainView.tableViewNews.reloadData()
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    func shiftStatus(news: localNewsStruct){
        var i = 0
        for n in ArrayNews{
            
            if n.id == news.id {
                var changedNews = n
                changedNews.status = .read
                ArrayNews.remove(at: i)
                ArrayNews.append(changedNews)
                doneNews.append(changedNews.id ?? 0)
                i += 1
                UserDefaults.standard.set(doneNews, forKey: keyID)

            }
        }
    }

}

/*
 https://static01.nyt.com/images/2023/04/25/multimedia/25Freidman-1-gkjl/25Freidman-1-gkjl-superJumbo.jpg?quality=75&auto=webp
 https://static01.nyt.com/images/2023/04/25/multimedia/25Freidman-1-gkjl/25Freidman-1-gkjl-thumbStandard.jpg
 
 https://www.nytimes.com/2023/04/25/opinion/kamala-harris-joe-biden-2024-reelection.html

 Result(uri: "nyt://article/1fb59cf6-4588-50e3-a436-01aeed915e07", url: "https://www.nytimes.com/2023/04/25/opinion/kamala-harris-joe-biden-2024-reelection.html", id: 100000008874437, assetID: 100000008874437, source: NewsApp.Source.newYorkTimes, publishedDate: "2023-04-25", updated: "2023-04-26 12:30:22", section: "Opinion", subsection: "", nytdsection: "opinion", adxKeywords: "Presidential Election of 2024;Vice Presidents and Vice Presidency (US);Biden, Joseph R Jr;Harris, Kamala D;Trump, Donald J;Democratic Party;Republican Party", column: nil, byline: "By Thomas L. Friedman", type: NewsApp.ResultType.article, title: "Why Kamala Harris Matters So Much in 2024", abstract: "America can’t afford for voters worried about Biden’s age to be turned off by his running mate.", desFacet: ["Presidential Election of 2024", "Vice Presidents and Vice Presidency (US)"], orgFacet: ["Democratic Party", "Republican Party"], perFacet: ["Biden, Joseph R Jr", "Harris, Kamala D", "Trump, Donald J"], geoFacet: [], media: [NewsApp.Media(type: NewsApp.MediaType.image, subtype: NewsApp.Subtype.photo, caption: "", copyright: "Doug Mills/The New York Times", approvedForSyndication: 1, mediaMetadata: [NewsApp.MediaMetadatum(url: "https://static01.nyt.com/images/2023/04/25/multimedia/25Freidman-1-gkjl/25Freidman-1-gkjl-thumbStandard.jpg", format: NewsApp.Format.standardThumbnail, height: 75, width: 75), NewsApp.MediaMetadatum(url: "https://static01.nyt.com/images/2023/04/25/multimedia/25Freidman-1-gkjl/25Freidman-1-gkjl-mediumThreeByTwo210.jpg", format: NewsApp.Format.mediumThreeByTwo210, height: 140, width: 210), NewsApp.MediaMetadatum(url: "https://static01.nyt.com/images/2023/04/25/multimedia/25Freidman-1-gkjl/25Freidman-1-gkjl-mediumThreeByTwo440.jpg", format: NewsApp.Format.mediumThreeByTwo440, height: 293, width: 440)])], etaID: 0)

 */
