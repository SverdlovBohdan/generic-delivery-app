import Foundation
import SwiftUI

@dynamicMemberLookup
@Observable
class ViewStateStore<Action, State> where Action: CustomStringConvertible {
    var viewState: State

    private let reduce: (inout State, Action) -> Void

    init(initialState: State, reducer: @escaping (inout State, Action) -> Void) {
        self.viewState = initialState
        self.reduce = reducer
    }

    func dispatch(action: Action) {
        // TODO: Use logger
        print("### \(action)")
        reduce(&viewState, action)
    }

    subscript<T>(dynamicMember keyPath: KeyPath<State, T>) -> T { viewState[keyPath: keyPath] }
}
