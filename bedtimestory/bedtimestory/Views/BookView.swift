import SwiftUI
struct BookView: View {
    @State var currentPage = 0
    @State var shouldHide = false
    let book: Book
    var body: some View {
        VStack {
            Text(self.book.title)
                .foregroundColor(.black)
                .font(.system(size: 30 , weight : .bold))
            PageView(page: book.pages[currentPage]).frame(alignment: .center)
            VStack {
                Text("Page \(self.currentPage+1) / \(self.book.pages.count)")
                if !self.$shouldHide.wrappedValue {
                    Button("Next") {
                    self.currentPage += 1
                    if (self.currentPage+1 == self.book.pages.count) {
                        self.shouldHide = true
                    }
                    }.background(Color.mint).hoverEffect(.lift)
            }
        }
    }
}
}

struct PageView: View {
    let page: Page
    var body: some View {
        GeometryReader{r in
            VStack(alignment: .center) {
                Text(page.text)
        }.frame(width:r.size.width, height: r.size.height/1.5, alignment: .center).background(Color.mint)
        }
    }
}
