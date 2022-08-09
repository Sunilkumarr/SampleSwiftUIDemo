//
//  ContentView.swift
//  Shared
//
//  Created by Sunil K on 03/08/22.
//

import SwiftUI
import UIKit
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    
    private var items: FetchedResults<Item>
    
    var body: some View {
        VStack {
            NavigationView {
                
                List {
                    if items.count == 0 {
                        HStack {
                            Text("No items right now. Add items to see in the list")
                        }
                    }
                    ForEach(items) {item in
                        NavigationLink {
                            DetailMessagesView(item: item)
                                .navigationTitle(item.name!)
                        } label: {
                            HStack {
                                Image("contactPlaceholder") .scaledToFit()
                                VStack(alignment: .leading){
                                    Text(item.name ?? "")
                                        .bold()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.init(top:0, leading: 5, bottom: 0, trailing: 0))
                                    Text(item.message!)
                                        .italic()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.init(top:0, leading: 5, bottom: 0, trailing: 0))
                                Spacer()
                                VStack {
                                    Text(item.timestamp!, formatter: itemFormatter)
                                        .font(.system(size: 12))
                                        .bold()
                                }
                            }
                        }
                        
                    }
                    .onDelete(perform: deleteItems)
                }
                .toolbar {
#if os(iOS)
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
#endif
                    ToolbarItem {
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                        
                    }
                }.navigationTitle(Text("Items"))
                Text("Select an item")
            }
        }
        
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.name = "Item \(items.count + 1)"
            newItem.message = "Sample item details for \(items.count + 1)"
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

struct DetailMessagesView: View {
    var item : Item
    init(item: Item) {
        self.item = item
    }
    
    var body: some View {
        
        Text("Item added at \(item.timestamp!, formatter: itemFormatter)").padding()
        
        Text((item.message!))
        
    }
}
