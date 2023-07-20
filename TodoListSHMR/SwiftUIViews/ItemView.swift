import SwiftUI

struct ItemView: View {

    let item: TodoItem

    var body: some View {
        HStack {
            CircleStatView
            Text(item.text)
            Spacer()
            Image(uiImage: Icon.Shevron.image!)
        }

    }

     private var CircleStatView: some View {
         if item.isCompleted {
             return Image(uiImage: Icon.CircleCompleted.image!)
         } else if item.importancy == .important {
             return Image(uiImage: Icon.CircleImportant.image!)
         } else {
             return Image(uiImage: Icon.CircleEmpty.image!)
         }
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
                ItemView(item: mockData.first!)
                ItemView(item: mockData[2])
                ItemView(item: mockData.last!)
            }
        }
        .previewLayout(.sizeThatFits)
    }
}
