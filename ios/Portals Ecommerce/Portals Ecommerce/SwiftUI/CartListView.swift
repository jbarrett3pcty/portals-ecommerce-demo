//
//  CartListView.swift
//  Ecommerce
//
//  Created by Steven Sherry on 2/15/22.
//

import SwiftUI
import IonicPortals

struct CartListView: View {
    @ObservedObject private var viewModel: CartViewModel
    
    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        if viewModel.contents.isEmpty {
           Text("Your cart is empty")
                .font(.title)
        } else {
            List {
                ForEach(viewModel.contents) { item in
                    CartItemView(
                        item: item,
                        image: Image(uiImage: viewModel.image(named: item.product.imageName)),
                        onSelectQuantity: { quantity in
                            viewModel.update(product: item.product, with: quantity)
                        }
                    )
                    .listRowSeparator(.hidden)
                }
                .onDelete(perform: viewModel.deleteProducts)
                
                CartFooterView(total: viewModel.cartTotal) {
                    viewModel.shouldDisplayCheckout = true
                }
                .listSectionSeparator(.hidden)
                .buttonStyle(.plain)
                .padding(.top, 16)
            }
            .listStyle(.plain)
            .sheet(isPresented: $viewModel.shouldDisplayCheckout) {
                PortalView(portal: .checkout)
            }
        }
    }
}

extension Cart.Item: Identifiable {
    var id: Int { product.id }
}

struct CartListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CartListView(viewModel: .debug)
                .navigationTitle("Cart")
                .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            // Register Portals
            PortalsRegistrationManager.shared.register(key: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJiNjVmMTU1MS1mMDAyLTQ5MTEtOGQxOC1mZmM5OTg0NWEwZTYifQ.dL_uqjTN9gFn3A_9g1eV6EaJ-5Uhj5b26Z21b8-DODmr6jsVdjnWH1-sWzjMmKSbIQDqptPpTmXj_YlkgoogQhKJwP8R0ITFzKz61sMo_ViFhcuQ0Y0XisTEO-UIWj8WV7eP3QcZx-DjVrshAuBmF7oIlGLZTKy2ovRFOHCxcVgKWByixbSdLEuuV4nEYrn8lS1Uy1tD3YecUBDMNOuH0IueNE7F6PrxxIPFHEBI04U6gSj0e2lGu0vCGwn-RPiab1evLzDqVzrC3MHcgLdli4iHQG98bS7JsKFlN8_1l0BIsCQf4SWy44XoMfRlkf6OqsLWr6xQH_hT0UxCXe3SrQ");
        }
    }
}

