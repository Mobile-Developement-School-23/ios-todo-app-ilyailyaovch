import SwiftUI

struct RootView: View {

    @State var items = mockData
    @State var showAll = true

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                // Список дел
                List {
                    Section {
                        // Элементы списка
                        ForEach(items, id: \.id) { item in
                            ItemView(item: item)
                        }
                        // Поледний элемент
                        Text("Новое")
                    } header: {
                        HStack(alignment: .bottom) {
                            Text("Выполнено — \(items.filter({ $0.isCompleted }).count)")
                            Spacer()
                            Button {
                                showAll.toggle()
                                items = showAll ? mockData : items.filter({ !$0.isCompleted })
                            } label: {
                                Text(showAll ? "Скрыть" : "Показать")
                            }
                        }
                        .padding(.bottom, 10)
                    }
                }
                .listStyle(.insetGrouped)
                // Кнопка добавления
                Button {
                    
                } label: {
                    Image(uiImage: Icon.PlusButton.image!)
                }
            }
            .shadow(radius: 5)
            .navigationTitle("Мои дела")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
