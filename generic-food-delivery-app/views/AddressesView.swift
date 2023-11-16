//
//  AddressesView.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 08.11.2023.
//

import SwiftUI

struct AddressesView: View {
    var addresses: [Customer.Address]
    let editable: Bool

    // TODO: Extract to viewStore
    @State private var street: String = ""
    @State private var appartment: String = ""
    @State private var canAddNewAddress: Bool = true

    typealias NewAddressCallback = (Customer.Address) -> Void
    let willAdd: NewAddressCallback?

    typealias RemoveAddressCallback = (IndexSet) -> Void
    let willRemove: RemoveAddressCallback?

    typealias ChangeDefaultAddressCallback = (Int) -> Void
    let willDefaultChange: ChangeDefaultAddressCallback?

    init(addresses: [Customer.Address], editable: Bool = true, didAdd: NewAddressCallback? = nil,
         didRemove: RemoveAddressCallback? = nil,
         didDefaultChange: ChangeDefaultAddressCallback? = nil)
    {
        self.addresses = addresses
        self.editable = editable
        willAdd = didAdd
        willRemove = didRemove
        willDefaultChange = didDefaultChange
    }

    private var addressesList: some DynamicViewContent {
        ForEach(addresses.indices, id: \.self) { idx in
            HStack {
                Text("\(addresses[idx].street) \(addresses[idx].appartment)")
                    .lineLimit(2)

                Spacer()

                Text("✅")
                    .opacity(addresses[idx].isDefault ? 1.0 : 0.0)
                    .animation(.easeOut, value: addresses[idx].isDefault)
            }
            .onTapGesture {
                willDefaultChange?(idx)
            }
        }
    }

    var body: some View {
        if editable {
            addressesList
                .onDelete(perform: { indexSet in
                    willRemove?(indexSet)
                })
                .animation(.easeOut, value: addresses)
        } else {
            addressesList
                .animation(.easeOut, value: addresses)
        }

        if editable {
            HStack {
                TextField(String(localized: "Street"), text: $street)
                    .lineLimit(1)

                TextField(String(localized: "Appartment"), text: $appartment)
                    .lineLimit(1)
            }

            Button(String(localized: "Add address")) {
                willAdd?(.init(street: street, appartment: appartment))
                street.removeAll()
                appartment.removeAll()
            }
            .disabled(street.isEmpty)
        }
    }
}

#Preview {
    List {
        AddressesView(addresses: [])
    }
}
