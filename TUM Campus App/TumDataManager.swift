//
//  TumManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/1/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Sweeft

class TumDataManager {
    
    var cardItems: [TumDataItems] {
        return PersistentCardOrder.value.managers
    }
    
    lazy var calendarManager: CalendarManager = { CalendarManager(config: self.config) }()
    lazy var movieManager: MovieManager = { MovieManager(config: self.config) }()
    lazy var newsManager: NewsManager = { NewsManager(config: self.config) }()
    lazy var tuitionManager: TuitionStatusManager = { TuitionStatusManager(config: self.config) }()
    lazy var bookRentalManager: NewBookRentalManager = { NewBookRentalManager(config: self.config) }()
    lazy var studyRoomsManager: StudyRoomsManager = { StudyRoomsManager(config: self.config) }()
    lazy var lecturesManager: PersonalLectureManager = { PersonalLectureManager(config: self.config) }()
    lazy var tumSexyManager: TumSexyManager = { TumSexyManager(config: self.config) }()
    
    lazy var lectureDetailsManager: LectureDetailsManager = { LectureDetailsManager(config: self.config) }()
    lazy var personDetailsManager: PersonDetailDataManager = { PersonDetailDataManager(config: self.config) }()
    
    lazy var roomSearchManager: RoomSearchManager = { RoomSearchManager(config: self.config) }()
    lazy var personSearchManager: PersonSearchManager = { PersonSearchManager(config: self.config) }()
    lazy var lectureSearchManager: LectureSearchManager = { LectureSearchManager(config: self.config) }()
    
    var isLoggedIn: Bool {
        return user?.token != nil
    }
    
    var config: Config
    var user: User?
    
    var cardManager: [SimpleSingleManager] {
        return [
            calendarManager,
            movieManager,
            newsManager,
            tuitionManager,
//            bookRentalManager,
        ]
    }
    
    var searchManagers: [SimpleSearchManager] {
        return [
            roomSearchManager,
            personSearchManager,
            lectureSearchManager
        ]
    }
    
    func getToken() -> String {
        return user?.token ?? ""
    }
    
    init(user: User?) {
        self.user = user
        self.config = Config(tumCabeURL: "https://tumcabe.in.tum.de/Api",
                             tumOnlineURL: "https://campus.tum.de/tumonline",
                             tumSexyURL: "http://json.tum.sexy",
                             roomsURL: "http://www.devapp.it.tum.de/iris",
                             rentalsURL: "https://opac.ub.tum.de/InfoGuideClient.tumsis",
                             user: user)
        
        roomSearchManager.search(query: "MI HS").onResult { result in
            print(result)
        }
        
        studyRoomsManager.fetch().onResult { result in
            print(result)
        }
        
    }
    
    func getCardItems() -> Response<[DataElement]> {
        // TODO: Sort
        return (self.cardManager => { $0.fetchSingle() }).bulk.map(completionQueue: .main) { $0.flatMap { $0 } }
    }
    
    func search(query: String) -> Response<[DataElement]> {
        // TODO: Handle more
        return (self.searchManagers => { $0.search(query: query) }).bulk.map(completionQueue: .main) { $0.flatMap { $0 } }
    }
    
}
