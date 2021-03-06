/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>. 
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
*	*	Redistributions of source code must retain the above copyright notice, this
*		list of conditions and the following disclaimer.
*
*	*	Redistributions in binary form must reproduce the above copyright notice,
*		this list of conditions and the following disclaimer in the documentation
*		and/or other materials provided with the distribution.
*
*	*	Neither the name of Algorithm nor the names of its
*		contributors may be used to endorse or promote products derived from
*		this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

public class SortedDictionary<Key : Comparable, Value where Key : Hashable> : ProbableType, CollectionType, Equatable, CustomStringConvertible {
	public typealias Generator = AnyGenerator<(key: Key, value: Value?)>
	
	/**
	Total number of elements within the RedBlackTree
	*/
	public internal(set) var count: Int = 0
	
	/**
		:name:	tree
		:description:	Internal storage of (key, value) pairs.
		- returns:	RedBlackTree<Key, Value>
	*/
	internal var tree: RedBlackTree<Key, Value>
	
	/**
		:name:	asDictionary
	*/
	public var asDictionary: Dictionary<Key, Value?> {
		var d: Dictionary<Key, Value?> = Dictionary<Key, Value?>()
		for (k, v) in self {
			d[k] = v
		}
		return d
	}
	
	/**
		:name:	description
		:description:	Conforms to the Printable Protocol. Outputs the
		data in the SortedDictionary in a readable format.
		- returns:	String
	*/
	public var description: String {
		return tree.internalDescription
	}
	
	/**
		:name:	first
		:description:	Get the first (key, value) pair.
		k1 <= k2 <= K3 ... <= Kn
		- returns:	(key: Key, value: Value?)?
	*/
	public var first: (key: Key, value: Value?)? {
		return tree.first
	}
	
	/**
		:name:	last
		:description:	Get the last (key, value) pair.
		k1 <= k2 <= K3 ... <= Kn
		- returns:	(key: Key, value: Value?)?
	*/
	public var last: (key: Key, value: Value?)? {
		return tree.last
	}
	
	/**
		:name:	isEmpty
		:description:	A boolean of whether the SortedDictionary is empty.
		- returns:	Bool
	*/
	public var isEmpty: Bool {
		return 0 == count
	}
	
	/**
		:name:	startIndex
		:description:	Conforms to the CollectionType Protocol.
		- returns:	Int
	*/
	public var startIndex: Int {
		return 0
	}
	
	/**
		:name:	endIndex
		:description:	Conforms to the CollectionType Protocol.
		- returns:	Int
	*/
	public var endIndex: Int {
		return count
	}
	
	/**
		:name:	keys
		:description:	Returns an array of the key values in order.
		- returns:	SortedDictionary.SortedKey
	*/
	public var keys: SortedSet<Key> {
		let s: SortedSet<Key> = SortedSet<Key>()
		for x in self {
			s.insert(x.key)
		}
		return s
	}
	
	/**
		:name:	values
		:description:	Returns an array of the values that are sorted based
		on the key ordering.
		- returns:	SortedDictionary.SortedValue
	*/
	public var values: Array<Value> {
		var s: Array<Value> = Array<Value>()
		for x in self {
			s.append(x.value!)
		}
		return s
	}
	
	/**
		:name:	init
		:description:	Constructor.
	*/
	public init() {
		tree = RedBlackTree<Key, Value>(uniqueKeys: true)
	}
	
	/**
		:name:	init
		:description:	Constructor.
		- parameter	elements:	(Key, Value?)...	Initiates with a given list of elements.
	*/
	public convenience init(elements: (Key, Value?)...) {
		self.init(elements: elements)
	}
	
	/**
		:name:	init
		:description:	Constructor.
		- parameter	elements:	Array<(Key, Value?)>	Initiates with a given array of elements.
	*/
	public convenience init(elements: Array<(Key, Value?)>) {
		self.init()
		insert(elements)
	}
	
	//
	//	:name:	generate
	//	:description:	Conforms to the SequenceType Protocol. Returns
	//	the next value in the sequence of nodes using
	//	index values [0...n-1].
	//	:returns:	SortedDictionary.Generator
	//
	public func generate() -> SortedDictionary.Generator {
		var index = startIndex
		return anyGenerator {
			if index < self.endIndex {
				return self[index++]
			}
			return nil
		}
	}
	
	/**
	Conforms to ProbableType protocol.
	*/
	public func countOf<T: Equatable>(keys: T...) -> Int {
		return countOf(keys)
	}
	
	/**
	Conforms to ProbableType protocol.
	*/
	public func countOf<T: Equatable>(keys: Array<T>) -> Int {
		return tree.countOf(keys)
	}
	
	/**
	The probability of elements.
	*/
	public func probabilityOf<T: Equatable>(elements: T...) -> Double {
		return probabilityOf(elements)
	}
	
	/**
	The probability of elements.
	*/
	public func probabilityOf<T: Equatable>(elements: Array<T>) -> Double {
		return tree.probabilityOf(elements)
	}
	
	/**
	The probability of elements.
	*/
	public func probabilityOf(block: (key: Key, value: Value?) -> Bool) -> Double {
		return tree.probabilityOf(block)
	}
	
	/**
	The expected value of elements.
	*/
	public func expectedValueOf<T: Equatable>(trials: Int, elements: T...) -> Double {
		return expectedValueOf(trials, elements: elements)
	}
	
	/**
	The expected value of elements.
	*/
	public func expectedValueOf<T: Equatable>(trials: Int, elements: Array<T>) -> Double {
		return tree.expectedValueOf(trials, elements: elements)
	}
	
	/**
		:name:	operator [key 1...key n]
		:description:	Property key mapping. If the key type is a
		String, this feature allows access like a
		Dictionary.
		- returns:	Value?
	*/
	public subscript(key: Key) -> Value? {
		get {
			return tree[key]
		}
		set(value) {
			tree[key] = value
			count = tree.count
		}
	}
	
	/**
		:name:	operator [0...count - 1]
		:description:	Allows array like access of the index.
		Items are kept in order, so when iterating
		through the items, they are returned in their
		ordered form.
		- returns:	(key: Key, value: Value?)
	*/
	public subscript(index: Int) -> (key: Key, value: Value?) {
		get {
			return tree[index]
		}
		set(value) {
			tree[index] = value
			count = tree.count
		}
	}
	
	/**
		:name:	indexOf
		:description:	Returns the Index of a given member, or -1 if the member is not present in the set.
		- returns:	Int
	*/
	public func indexOf(key: Key) -> Int {
		return tree.indexOf(key)
	}
	
	/**
		:name:	insert
		:description:	Insert a key / value pair.
		- returns:	Bool
	*/
	public func insert(key: Key, value: Value?) -> Bool {
		let result: Bool = tree.insert(key, value: value)
		count = tree.count
		return result
	}
	
	/**
		:name:	insert
		:description:	Inserts a list of (Key, Value?) pairs.
		- parameter	elements:	(Key, Value?)...	Elements to insert.
	*/
	public func insert(elements: (Key, Value?)...) {
		insert(elements)
	}
	
	/**
		:name:	insert
		:description:	Inserts an array of (Key, Value?) pairs.
		- parameter	elements:	Array<(Key, Value?)>	Elements to insert.
	*/
	public func insert(elements: Array<(Key, Value?)>) {
		tree.insert(elements)
		count = tree.count
	}
	
	/**
		:name:	removeValueForKeys
		:description:	Removes key / value pairs based on the key value given.
	*/
	public func removeValueForKeys(keys: Key...) {
		removeValueForKeys(keys)
	}
	
	/**
		:name:	removeValueForKeys
		:description:	Removes key / value pairs based on the key value given.
	*/
	public func removeValueForKeys(keys: Array<Key>) {
		tree.removeValueForKeys(keys)
		count = tree.count
	}
	
	/**
		:name:	removeAll
		:description:	Remove all nodes from the tree.
	*/
	public func removeAll() {
		tree.removeAll()
		count = tree.count
	}
	
	/**
		:name:	updateValue
		:description:	Updates a node for the given key value.
	*/
	public func updateValue(value: Value?, forKey: Key) {
		tree.updateValue(value, forKey: forKey)
	}
	
	/**
		:name:	findValueForKey
		:description:	Finds the value for key passed.
		- parameter	key:	Key	The key to find.
		- returns:	Value?
	*/
	public func findValueForKey(key: Key) -> Value? {
		return tree.findValueForKey(key)
	}
	
	/**
		:name:	search
		:description:	Accepts a list of keys and returns a subset
		SortedDictionary with the given values if they exist.
	*/
	public func search(keys: Key...) -> SortedDictionary<Key, Value> {
		return search(keys)
	}
	
	/**
		:name:	search
		:description:	Accepts an array of keys and returns a subset
		SortedDictionary with the given values if they exist.
	*/
	public func search(keys: Array<Key>) -> SortedDictionary<Key, Value> {
		var dict: SortedDictionary<Key, Value> = SortedDictionary<Key, Value>()
		for key: Key in keys {
			traverse(key, node: tree.root, dict: &dict)
		}
		return dict
	}
	
	/**
		:name:	traverse
		:description:	Traverses the SortedDictionary, looking for a key match.
	*/
	internal func traverse(key: Key, node: RedBlackNode<Key, Value>, inout dict: SortedDictionary<Key, Value>) {
		if tree.sentinel !== node {
			if key == node.key {
				dict.insert((key, node.value))
			}
			traverse(key, node: node.left, dict: &dict)
			traverse(key, node: node.right, dict: &dict)
		}
	}
}

public func ==<Key : Comparable, Value>(lhs: SortedDictionary<Key, Value>, rhs: SortedDictionary<Key, Value>) -> Bool {
	if lhs.count != rhs.count {
		return false
	}
	for var i: Int = lhs.count - 1; 0 <= i; --i {
		if lhs[i].key != rhs[i].key {
			return false
		}
	}
	return true
}

public func !=<Key : Comparable, Value>(lhs: SortedDictionary<Key, Value>, rhs: SortedDictionary<Key, Value>) -> Bool {
	return !(lhs == rhs)
}

public func +<Key : Comparable, Value>(lhs: SortedDictionary<Key, Value>, rhs: SortedDictionary<Key, Value>) -> SortedDictionary<Key, Value> {
	let t: SortedDictionary<Key, Value> = lhs
	for (k, v) in rhs {
		t.insert(k, value: v)
	}
	return t
}

public func +=<Key : Comparable, Value>(lhs: SortedDictionary<Key, Value>, rhs: SortedDictionary<Key, Value>) {
	for (k, v) in rhs {
		lhs.insert(k, value: v)
	}
}

public func -<Key : Comparable, Value>(lhs: SortedDictionary<Key, Value>, rhs: SortedDictionary<Key, Value>) -> SortedDictionary<Key, Value> {
	let t: SortedDictionary<Key, Value> = lhs
	for (k, _) in rhs {
		t.removeValueForKeys(k)
	}
	return t
}

public func -=<Key : Comparable, Value>(lhs: SortedDictionary<Key, Value>, rhs: SortedDictionary<Key, Value>) {
	for (k, _) in rhs {
		lhs.removeValueForKeys(k)
	}
}
