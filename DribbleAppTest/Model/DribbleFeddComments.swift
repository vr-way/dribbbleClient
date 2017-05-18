

import Foundation


struct DribbleFeedComments{
    
    let id: UInt
    let body: String
    let date: String
    //let user: UserId
    let userAvatar : URL?
    let userName : String
    
    
    
}


func mapDribbleFeedComments() -> DribbleFeedComments? {
    
    
    
    let id = 12334
    let body = "Could he somehow make the shape of an \"S\" with his arms? I feel like i see potential for some hidden shapes in here...</p>\n\n<p>Looks fun!\n"
    let date = "2012-03-15T04:24:39Z"
    let avatarUrl = URL(string: "https://d13yacurqjgara.cloudfront.net/users/1/avatars/normal/dc.jpg?1371679243")
    let username = "Vlad Starodubov"
    
    
    
    
    let commentList = DribbleFeedComments(id: UInt(id), body: body, date: date, userAvatar: avatarUrl, userName: username  )
    return commentList
}

