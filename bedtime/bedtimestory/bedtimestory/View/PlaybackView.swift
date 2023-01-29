import SwiftUI

var pageNumber = 0

struct BookView: View {
    
    @State var shouldHide = false
    let book: Book
    
    @State var pageNum = 0
    var body: some View {
        VStack {
            Text(self.book.title)
                .foregroundColor(.black)
                .font(.system(size: 30 , weight : .bold))
            PageView(page: book.pages[self.pageNum]).frame(alignment: .center)
            
            VStack {
                Text("Page \(self.pageNum+1) / \(self.book.pages.count)")
                
                if !self.$shouldHide.wrappedValue {
                    Button("Next") {
                        pageNumber = pageNumber + 1
                        self.pageNum = self.pageNum + 1
                        if (self.pageNum + 1 == self.book.pages.count) {
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
                page.image.resizable().scaledToFit()
            }.frame(width: r.size.width, height: r.size.height/1.5, alignment: .center).background(Color.mint)
        }
    }
}

struct PlaybackView: View {
    
    let bookID: Int
    @ObservedObject var vm = VoiceViewModel()
    var recording:Recording? {
        print(pageNumber)
        print(self.vm.recordingsList)
        return self.vm.recordingsList[pageNumber]
    }
    // Service to get book from ID
    var bookView = BookView(book: Book(title:"Book name"))
    @State private var showingList = false
    @State private var showingAlert = false
    
    @State private var effect1 = false
    @State private var effect2 = false
    init(newBookID: Int) {
        self.bookID = newBookID
        self.vm = VoiceViewModel(bookid: bookID)
    }
    
    var body: some View {
        
        ZStack{
            VStack{
                
                
                HStack{
                    Spacer()
                    Spacer()
                    Spacer()
                }
                
                Spacer()
                
                VStack{
                    bookView
                }
                
                VStack{
                    HStack{
                        
                        VStack(alignment:.leading) {
                            Text("\(recording!.fileURL.lastPathComponent)")
                        }
                        VStack {
                            Spacer()
                            
                            Button(action: {
                                if self.recording!.isPlaying == true {
                                    vm.pausePlaying(url: self.recording!.fileURL)
                                }else{
                                    vm.startPlaying(url: self.recording!.fileURL)
                                }
                            }) {
                                Image(systemName: ((self.recording!.isPlaying)) ? "stop.fill" : "play.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size:30))
                            }
                            
                        }
                        
                    }.padding()
                }.padding(.horizontal,10)
                    .frame(width: 370, height: 85)
                    .background(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
                    .cornerRadius(30)
                    .shadow(color: Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)).opacity(0.3), radius: 10, x: 0, y: 10)
                Spacer()
                
                
                
                Spacer()
                
            }
            .padding(.leading,25)
            .padding(.trailing,25)
            .padding(.top , 70)

            
            
        }
   
    }
}

