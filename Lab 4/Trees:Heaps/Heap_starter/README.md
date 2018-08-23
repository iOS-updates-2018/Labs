## Heaps

A heap is a type of binary tree that lives inside an array, so it doesn't use parent/child pointers. The tree is partially sorted according to something called the "heap property" that determines the order of the nodes in the tree.

Common uses for heap:

- For building priority queues.
- The heap is the data structure supporting heap sort.
- Heaps are fast for when you often need to compute the minimum (or maximum) element of a collection.

There are two kinds of heaps: a *max-heap* and a *min-heap*. They are identical, except that the order in which they store the tree nodes is opposite.

In a max-heap, parent nodes must always have a greater value than each of their children. For a min-heap it's the other way around: every parent node has a smaller value than its child nodes. This is called the "heap property" and it is true for every single node in the tree.

An example:

![](http://67442.cmuis.net/screenshots/67442/lab4/Heap1.png)

This is a max-heap because every parent node is greater than its children. `(10)` is greater than `(7)` and `(2)`. `(7)` is greater than `(5)` and `(1)`.

As a result of this heap property, a max-heap always stores its largest item at the root of the tree. For a min-heap, the root is always the smallest item in the tree. That is very useful because heaps are often used as a priority queue where you want to quickly access the "most important" element.

> **Note:** You can't really say anything else about the sort order of the heap. For example, in a max-heap the maximum element is always at index 0 but the minimum element isn’t necessarily the last one -- the only guarantee you have is that it is one of the leaf nodes, but not which one.

#### The tree that lived in an array

An array may seem like an odd way to implement a tree-like structure but it is very efficient in both time and space.

This is how we're going to store the tree from the above example:

  [ 10, 7, 2, 5, 1 ]

That's all there is to it! We don't need any more storage than just this simple array.

So how do we know which nodes are the parents and which are the children if we're not allowed to use any pointers? Good question! There is a well-defined relationship between the array index of a tree node and the array indices of its parent and children.

If `i` is the index of a node, then the following formulas give the array indices of its parent and child nodes:

    parent(i) = floor((i - 1)/2)
    left(i)   = 2i + 1
    right(i)  = 2i + 2
    
Note that `right(i)` is simply `left(i) + 1`. The left and right nodes are always stored right next to each other.

Let's use these formulas on the example. Fill in the array index and we should get the positions of the parent and child nodes in the array:

| Node | Array index (`i`) | Parent index | Left child | Right child |
|------|-------------|--------------|------------|-------------|
| 10 | 0 | -1 | 1 | 2 |
| 7 | 1 | 0 | 3 | 4 |
| 2 | 2 | 0 | 5 | 6 | 
| 5 | 3 | 1 | 7 | 8 |
| 1 | 4 | 1 | 9 | 10 |

Verify for yourself that these array indices indeed correspond to the picture of the tree.

> **Note:** The root node `(10)` doesn't have a parent because `-1` is not a valid array index. Likewise, nodes `(2)`, `(5)`, and `(1)` don't have children because those indices are greater than the array size. So we always have to make sure the indices we calculate are actually valid before we use them.

Recall that in a max-heap, the parent's value is always greater than (or equal to) the values of its children. This means the following must be true for all array indices `i`:

```swift
array[parent(i)] >= array[i]
```
  
Verify that this heap property holds for the array from the example heap.

As you can see, these equations let us find the parent or child index for any node without the need for pointers. True, it's slightly more complicated than just dereferencing a pointer but that's the tradeoff: we save memory space but pay with extra computations. Fortunately, the computations are fast and only take **O(1)** time.

It's important to understand this relationship between array index and position in the tree. Here's a slightly larger heap, this tree has 15 nodes divided over four levels:

![](http://67442.cmuis.net/screenshots/67442/lab4/LargeHeap.png)

The numbers in this picture aren't the values of the nodes but the array indices that store the nodes! Those array indices correspond to the different levels of the tree like this:

![](http://67442.cmuis.net/screenshots/67442/lab4/Array.png)

For the formulas to work, parent nodes must always appear before child nodes in the array. You can see that in the above picture.

Note that this scheme has limitations. You can do the following with a regular binary tree but not with a heap:

![](http://67442.cmuis.net/screenshots/67442/lab4/RegularTree.png)

With a heap you can’t start a new level unless the current lowest level is completely full. 

#### What can you do with a heap?

There are two primitive operations necessary to make sure the heap is a valid max-heap or min-heap after you insert or remove an element:

- `shiftUp()`: If the element is greater (max-heap) or smaller (min-heap) than its parent, it needs to be swapped with the parent. This makes it move up the tree.

- `shiftDown()`. If the element is smaller (max-heap) or greater (min-heap) than its children, it needs to move down the tree. This operation is also called "heapify". 

Shifting up or down is a recursive procedure that takes **O(log n)** time.

The other operations are built on these primitives. They are:

- `insert(value)`: Adds the new element to the end of the heap and then uses `shiftUp()` to fix the heap.

- `remove()`: Removes and returns the maximum value (max-heap) or the minimum value (min-heap). To fill up the hole that's left by removing the element, the very last element is moved to the root position and then `shiftDown()` fixes up the heap. (This is sometimes called "extract min" or "extract max".)

- `removeAtIndex(index)`: Just like `remove()` except it lets you remove any item from the heap, not just the root. This calls both `shiftDown()`, in case the new element is out-of-order with its children, and `shiftUp()`, in case the element is out-of-order with its parents.

- `replace(index, value)`: Assigns a smaller (min-heap) or larger (max-heap)  value to a node. Because this invalidates the heap property, it uses `shiftUp()` to patch things up. (Also called "decrease key" and "increase key".)

All of the above take time **O(log n)** because shifting up or down is the most expensive thing they do. There are also a few operations that take more time:

- `search(value)`. Heaps aren't built for efficient searches but the `replace()` and `removeAtIndex()` operations require the array index of the node, so you need to find that index somehow. Time: **O(n)**.

- `buildHeap(array)`: Converts an (unsorted) array into a heap by repeatedly calling `shiftDown()`. If you’re smart about this, it can be done in **O(n)** time.

- Heap sort. Since the heap is really an array, we can use its unique properties to sort the array from low to high. Time: **O(n lg n).**

The heap also has a `peek()` function that returns the maximum (max-heap) or minimum (min-heap) element, without removing it from the heap. Time: **O(1)**.

**Note:** By far the most common things you'll do with a heap are inserting new values with `insert()` and removing the maximum or minimum value with `remove()`. Both take **O(log n)** time. The other operations exist to support more advanced usage, such as building a priority queue where the "importance" of items can change after they've been added to the queue.

#### Creating a heap from an array

It can be convenient to convert an array into a heap. This just shuffles the array elements around until the heap property is satisfied.

In code it would look like this:

```swift
  private mutating func buildHeap(array: [T]) {
    for value in array {
      insert(value)
    }
  }
```

We simply call `insert()` for each of the values in the array. Simple enough, but not very efficient. This takes **O(n log n)** time in total because there are **n** elements and each insertion takes **log n** time.

If you didn't gloss over the math section, you'd have seen that for any heap the elements at array indices *n/2* to *n-1* are the leaves of the tree. We can simply skip those leaves. We only have to process the other nodes, since they are parents with one or more children and therefore may be in the wrong order. 

In code:

```swift
  private mutating func buildHeap(array: [T]) {
    elements = array
    for i in (elements.count/2 - 1).stride(through: 0, by: -1) {
      shiftDown(index: i, heapSize: elements.count)
    }
  }
```

Here, `elements` is the heap's own array. We walk backwards through this array, starting at the first non-leaf node, and call `shiftDown()`. This simple loop puts these nodes, as well as the leaves that we skipped, in the correct order. This is known as Floyd's algorithm and only takes **O(n)** time. Win!

#### Searching the heap

Heaps aren't made for fast searches, but if you want to remove an arbitrary element using `removeAtIndex()` or change the value of an element with `replace()`, then you need to obtain the index of that element somehow. Searching is one way to do this but it's kind of slow.

In a binary search tree you can depend on the order of the nodes to guarantee a fast search. A heap orders its nodes differently and so a binary search won't work. You'll potentially have to look at every node in the tree.

Let's take our example heap again:

![](http://67442.cmuis.net/screenshots/67442/lab4/Heap1.png)

If we want to search for the index of node `(1)`, we could just step through the array `[ 10, 7, 2, 5, 1 ]` with a linear search.

But even though the heap property wasn't conceived with searching in mind, we can still take advantage of it. We know that in a max-heap a parent node is always larger than its children, so we can ignore those children (and their children, and so on...) if the parent is already smaller than the value we're looking for.

Let's say we want to see if the heap contains the value `8` (it doesn't). We start at the root `(10)`. This is obviously not what we're looking for, so we recursively look at its left and right child. The left child is `(7)`. That is also not what we want, but since this is a max-heap, we know there's no point in looking at the children of `(7)`. They will always be smaller than `7` and are therefore never equal to `8`. Likewise for the right child, `(2)`.

Despite this small optimization, searching is still an **O(n)** operation.

**Note:** There is away to turn lookups into a **O(1)** operation by keeping an additional dictionary that maps node values to indices. This may be worth doing if you often need to call `replace()` to change the "priority" of objects in a priority queue that's built on a heap.
