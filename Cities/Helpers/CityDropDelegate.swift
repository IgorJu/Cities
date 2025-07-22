import SwiftUI

struct CityDropDelegate: DropDelegate {
    @Binding var draggingItem: City?
    
    let item: City
    let listVM: CityListViewModel

    func dropEntered(info: DropInfo) {
        guard let dragging = draggingItem, dragging.id != item.id,
              let fromIndex = listVM.currentCities.firstIndex(of: dragging),
              let toIndex = listVM.currentCities.firstIndex(of: item) else { return }

        withAnimation {
            listVM.currentCities.move(
                fromOffsets: IndexSet(integer: fromIndex),
                toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex
            )
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal {
        DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        draggingItem = nil
        return true
    }
}

