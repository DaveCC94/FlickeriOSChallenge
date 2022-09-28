import Foundation

struct RemotePhotoList: Decodable {
    let photo: [RemotePhoto]
    let page: Int
    let pages: Int

    init(photo: [RemotePhoto], page: Int, pages: Int) {
        self.photo = photo
        self.page = page
        self.pages = pages
    }
}
