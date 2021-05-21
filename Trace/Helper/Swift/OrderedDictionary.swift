//
//  OrderedDictionary.swift
//  Trace
//
//  Created by Shams Ahmed on 11/10/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Native dictionary class in Swift and Objective-C prefer to avoid ordering since it slows down performance
/// So this class creaet ordered dictionary while trying to optimise for speed etc..
/// Most apps don't require this feature but we have to since the order is important for metric data models.
struct OrderedDictionary<Key: Hashable, Value>: BidirectionalCollection {

    // MARK: - Typealias
    
    typealias Element = (key: Key, value: Value)
    typealias Index = Int
    typealias Indices = CountableRange<Int>
    typealias SubSequence = Slice<Key, Value>
    typealias Values<Key: Hashable, Value> = LazyMapCollection<OrderedDictionary<Key, Value>, Value>
    typealias Keys<Key: Hashable, Value> = LazyMapCollection<OrderedDictionary<Key, Value>, Key>
    typealias Slice<Key: Hashable, Value> = Swift.Slice<OrderedDictionary<Key, Value>>

    // MARK: - Property
    
    fileprivate var orderedKeys: Keys<Key, Value> { return self.lazy.map { $0.key } }
    fileprivate var orderedValues: Values<Key, Value> { return self.lazy.map { $0.value } }
    fileprivate var unorderedDictionary: [Key: Value] { return _keysToValues }
    
    fileprivate var _orderedKeys = [Key]()
    fileprivate var _keysToValues = [Key: Value]()
    
    // MARK: - Init
    
    init() {
        
    }
    
    init(unsorted: [Key: Value], areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        let keysAndValues = try Array(unsorted).sorted(by: areInIncreasingOrder)
       
        self.init(uniqueKeysWithValues: keysAndValues)
    }
    
    init<S: Sequence>(values: S, uniquelyKeyedBy extractKey: (Value) throws -> Key) rethrows where S.Element == Value {
        self.init(uniqueKeysWithValues: try values.map { value in
            return (try extractKey(value), value)
        })
    }

    init<S: Sequence>(uniqueKeysWithValues keysAndValues: S) where S.Element == Element {
        for (key, value) in keysAndValues {
            if containsKey(key) {
                Logger.error(.internalError, "Sequence of key-value pairs contains duplicate keys")
            }
            
            self[key] = value
        }
    }
     
    // MARK: - Indices
    
    var indices: Indices { return _orderedKeys.indices }
    var startIndex: Index { return _orderedKeys.startIndex }
    var endIndex: Index { return _orderedKeys.endIndex }
    
    func index(after i: Index) -> Index {
        return _orderedKeys.index(after: i)
    }
    
    func index(before i: Index) -> Index {
        return _orderedKeys.index(before: i)
    }
    
    // MARK: - Slices
  
    subscript(bounds: Range<Index>) -> SubSequence {
        return Slice(base: self, bounds: bounds)
    }
    
    // MARK: - Key Access
    
    subscript(key: Key) -> Value? {
        get {
            return value(forKey: key)
        }
        set {
            if let newValue = newValue {
                updateValue(newValue, forKey: key)
            } else {
                removeValue(forKey: key)
            }
        }
    }
    
    func containsKey(_ key: Key) -> Bool {
        return _keysToValues[key] != nil
    }

    func value(forKey key: Key) -> Value? {
        return _keysToValues[key]
    }

    @discardableResult
    mutating func updateValue(_ value: Value, forKey key: Key) -> Value? {
        if containsKey(key) {
            let currentValue = _unsafeValue(forKey: key)
            
            _keysToValues[key] = value
            
            return currentValue
        } else {
            _orderedKeys.append(key)
            _keysToValues[key] = value
            
            return nil
        }
    }
    
    @discardableResult
    mutating func removeValue(forKey key: Key) -> Value? {
        guard let index = index(forKey: key) else { return nil }
        
        let currentValue = self[index].value
        
        _orderedKeys.remove(at: index)
        _keysToValues[key] = nil
        
        return currentValue
    }
    
    mutating func removeAll(keepingCapacity keepCapacity: Bool = false) {
        _orderedKeys.removeAll(keepingCapacity: keepCapacity)
        _keysToValues.removeAll(keepingCapacity: keepCapacity)
    }
    
    private func _unsafeValue(forKey key: Key) -> Value {
        guard let value = _keysToValues[key] else {
            let message = "Value not found"
            
            Logger.error(.crash, message)
            fatalError(message)
        }
    
        return value
    }
    
    // MARK: - Index
    
    subscript(position: Index) -> Element {
        let key = _orderedKeys[position]
        let value = _unsafeValue(forKey: key)
        
        return (key, value)
    }
    
    func index(forKey key: Key) -> Index? {
        return _orderedKeys.firstIndex(of: key)
    }
    
    func elementAt(_ index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }

    func canInsert(key: Key) -> Bool {
        return !containsKey(key)
    }

    func canInsert(at index: Index) -> Bool {
        return index >= startIndex && index <= endIndex
    }
    
    mutating func insert(_ newElement: Element, at index: Index) {
        if !canInsert(key: newElement.key) {
            Logger.error(.internalError, "Cannot insert duplicate key")
        }
        
        if !canInsert(at: index) {
            Logger.error(.internalError, "Cannot insert at invalid index")
        }
        
        let (key, value) = newElement
        
        _orderedKeys.insert(key, at: index)
        _keysToValues[key] = value
    }
    
    mutating func merge(_ elements: OrderedDictionary<Key, Value>) {
        elements.forEach {
            let (key, value) = $0

            if !containsKey(key) {
                _orderedKeys.insert(key, at: _orderedKeys.count)
                _keysToValues[key] = value
            }
        }
    }

    @discardableResult
    mutating func remove(at index: Index) -> Element? {
        guard let element = elementAt(index) else { return nil }
        
        _orderedKeys.remove(at: index)
        _keysToValues.removeValue(forKey: element.key)
        
        return element
    }
    
    private func _canUpdate(_ newElement: Element, at index: Index, keyPresentAtIndex: inout Bool) -> Bool {
        let currentIndexOfKey = self.index(forKey: newElement.key)
        let keyNotPresent = currentIndexOfKey == nil
        
        keyPresentAtIndex = currentIndexOfKey == index
        
        return keyNotPresent || keyPresentAtIndex
    }
    
    // MARK: - Remove Elements
    
    mutating func removeFirst() -> Element {
        guard let element = remove(at: startIndex) else {
            let message = "Value not found"
            
            Logger.error(.crash, message)
            fatalError(message)
        }
        
        return element
    }
    
    mutating func removeLast() -> Element {
        guard let element = remove(at: index(before: endIndex)) else {
            let message = "Value not found"
            
            Logger.error(.crash, message)
            fatalError(message)
        }
        
        return element
    }
    
    private func _sortedElements(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> [Element] {
        return try sorted(by: areInIncreasingOrder)
    }
    
    // MARK: - Map
    
    func compactMapValues<T>(_ transform: (Value) throws -> T?) rethrows -> OrderedDictionary<Key, T> {
        var result = OrderedDictionary<Key, T>()
        
        for (key, value) in self {
            if let transformedValue = try transform(value) {
                result[key] = transformedValue
            }
        }
        
        return result
    }
}

extension OrderedDictionary: ExpressibleByArrayLiteral, ExpressibleByDictionaryLiteral {
    
    // MARK: - ArrayLiteral
    
    init(arrayLiteral elements: Element...) {
        self.init(uniqueKeysWithValues: elements)
    }

    // MARK: - DictionaryLiteral
    
    init(dictionaryLiteral elements: (Key, Value)...) {
        self.init(uniqueKeysWithValues: elements.map {
            return (key: $0.0, value: $0.1)
        })
    }
}

extension OrderedDictionary: Equatable where Value: Equatable { }

extension OrderedDictionary: CustomStringConvertible {
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        if isEmpty { return "[:]" }
        
        let printFunction: (Any, inout String) -> Void = {
            return { print($0, separator: "", terminator: "", to: &$1) }
        }()
        
        let descriptionForItem: (Any) -> String = { item in
            var description = ""
            printFunction(item, &description)
            
            return description
        }
        
        let bodyComponents = map { element in
            return descriptionForItem(element.key) + ": " + descriptionForItem(element.value)
        }
        
        let body = bodyComponents.joined(separator: ", ")
        
        return "[\(body)]"
    }
}

extension OrderedDictionary: Codable where Key: Codable, Value: Codable {
    
    // MARK: - Init
    
    init(from decoder: Decoder) throws {
        self.init()
    
        var container = try decoder.unkeyedContainer()
        
        while !container.isAtEnd {
            let key = try container.decode(Key.self)
            
            guard !container.isAtEnd else {
                throw DecodingError.dataCorrupted(.init(
                    codingPath: decoder.codingPath,
                    debugDescription: "")
                )
            }
            
            let value = try container.decode(Value.self)
            
            self[key] = value
        }
    }
    
    // MARK: - Encode
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        
        for (key, value) in self {
            try container.encode(key)
            try container.encode(value)
        }
    }
}
