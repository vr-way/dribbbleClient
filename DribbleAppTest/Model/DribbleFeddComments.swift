import Foundation
import SwiftyJSON
import SDWebImage

struct DribbleFeedComments {

    let id: String
    let body: String
    let date: String
    let userAvatar: URL?
    let userName: String

}

func mapDribbleFeedComments(_ input: JSON) -> DribbleFeedComments? {

    let id = input["id"].stringValue

    let body = input["body"].stringValue
    let date = input["created_at"].stringValue
    let avatarUrl = URL(string: input["user", "avatar_url"].stringValue)
    let username = input["user", "name"].stringValue

    let comment = DribbleFeedComments(id: id, body: body, date: date, userAvatar: avatarUrl, userName: username  )

    return comment
}

// MARK: Test data
extension DribbleFeedComments {

    static var `default`: DribbleFeedComments {
        let id = "12334"
        let body = "Could he somehow make the shape of an \"S\" with his arms? I feel like i see potential for some hidden shapes in here...</p>\n\n<p>Looks fun!\n"
        let date = "2017-05-21T04:24:39Z"
        let avatarUrl = URL(string: "https://pp.userapi.com/c631516/v631516986/4d92e/3XIunDJtYwQ.jpg")
        let username = "Vlad Starodubov"

        let comment = DribbleFeedComments(id: id, body: body, date: date, userAvatar: avatarUrl, userName: username  )
        return comment
    }
}
