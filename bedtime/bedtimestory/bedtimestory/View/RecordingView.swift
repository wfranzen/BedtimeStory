import SwiftUI

struct RecordingView: View {
    
    let bookID: Int

    @ObservedObject var vm = VoiceViewModel()
    
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

                    Button(action: {
                        if vm.isRecording == true {
                            vm.stopRecording()
                        }
                        vm.fetchAllRecording()
                        showingList.toggle()
                    }) {
                        Image(systemName: "list.bullet")
                            .foregroundColor(.black)
                            .font(.system(size: 20, weight: .bold))
                    }.sheet(isPresented: $showingList, content: {
                        recordingListView()
                    })
                    Spacer()
                    
                }
                Spacer()
                VStack{
                    BookView(book: Book(title:"Book name"))
                }
                if vm.isRecording {
                    
                    VStack(alignment : .leading , spacing : -5){
                        HStack (spacing : 3) {
                            Image(systemName: vm.isRecording && vm.toggleColor ? "circle.fill" : "circle")
                                .font(.system(size:10))
                                .foregroundColor(.red)
                            Text("Rec")
                        }
                        Text(vm.timer)
                            .font(.system(size:60))
                            .foregroundColor(.black)
                    }
                    
                } else {
                    VStack{
                        Text("Press the Recording Button below")
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                        Text("and Stop when its done")
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                    }.frame(width: 300, height: 100, alignment: .center)
                    
                    
                }
                
                Spacer()

                ZStack {
                    
                    Circle()
                        .frame(width: 150, height: 150)
                        .foregroundColor(Color(#colorLiteral(red: 0.4157493109, green: 0.8572631, blue: 0.9686274529, alpha: 0.4940355314)))
                        .scaleEffect(effect2 ? 1 : 0.8)
                        .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true).speed(1))
                        .onAppear(){
                            self.effect2.toggle()
                        }
                    
                    Circle()
                        .frame(width: 70, height: 70)
                        .foregroundColor(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)))
                        .scaleEffect(effect2 ? 1 : 1.5)
                        .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true).speed(2))
                        .onAppear(){
                            self.effect1.toggle()
                        }
                    
                    
                    Image(systemName: vm.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                        .foregroundColor(.black)
                        .font(.system(size: 65))
                        .onTapGesture {
                            if vm.isRecording == true {
                                vm.stopRecording()
                            } else {
                                vm.startRecording()
                                
                            }
                        }
                    
                }
                
                
                
                Spacer()
                
            }
            .padding(.leading,25)
            .padding(.trailing,25)
            .padding(.top , 70)

            
            
        }
   
    }
}

struct RecordingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView(newBookID: 4803)
            .previewInterfaceOrientation(.landscapeRight)
    }
}
