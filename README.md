# Collections

![Swift](https://img.shields.io/badge/%20in-swift%203.0-orange.svg) [![Build Status](https://travis-ci.org/dn-m/Collections.svg?branch=master)](https://travis-ci.org/dn-m/Collections) [![codecov](https://codecov.io/gh/dn-m/Collections/branch/master/graph/badge.svg)](https://codecov.io/gh/dn-m/Collections/) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![GitHub version](https://badge.fury.io/gh/dn-m%2FCollections.svg)](https://badge.fury.io/gh/dn-m%2FCollections)

## Contents

### Structures
- `SortedArray`
- `OrderdDictionary`
- `SortedDictionary`
- `Stack`
- `Matrix`
- `Tree`
- `LinkedList`

---

### Protocols
- `AnySequenceWrapping`

---

### `Array` extensions

#### List processing
- `head: Element?`
- `tail: Array<Element>`
- `destructured: (Element, Array<Element>)`

#### Elements at indices
- `subscript (safe: Int) -> Element?`
- `second: Element?`
- `penultimate: Element?`
- `last(amount: Int) -> [Element]`

#### Removing elements
- `removeFirst() throws`
- `removeFirst(amount: Int) throws`
- `removeLast(amount: Int) throws`

#### Replacing elements
- `replaceElement(at index: Int, withElement newElement: Element) throws`
- `replaceLast(with element: Element) throws`
- `replaceFirst(with element: Element) throws`

---

### `Collection` extensions
- `subsets(cardinality: Int) -> [[Iterator.Element]]`
- `adjacentPairs: [(Element,Element)]`

---

### `RangeReplaceableCollection` extensions
- `stableSort()`

---

### `enum` extensions
- `cases: [Self]`

---

<a name="integration"></a>
## Integration

### Carthage
Integrate **Collections** into your OSX or iOS project with [Carthage](https://github.com/Carthage/Carthage).

1. Follow [these instructions](https://github.com/Carthage/Carthage#installing-carthage) to install Carthage, if necessary.
2. Add `github "dn-m/Collections"` to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile).
3. Follow [these instructions](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application) to integrate **Collections** into your OSX or iOS project.

***

### Documentation

See the [documentation](http://dn-m.github.io/Collections/).
