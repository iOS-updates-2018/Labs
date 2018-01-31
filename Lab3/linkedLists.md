Let's start with a quick review of linked lists as a data structure.  A linked list is a sequence of data items, just like an array. But where an array allocates a big block of memory to store the objects, the elements in a linked list are totally separate objects in memory and are connected through links:

	+--------+    +--------+    +--------+    +--------+
	|        |    |        |    |        |    |        |
	| node 0 |--->| node 1 |--->| node 2 |--->| node 3 |
	|        |    |        |    |        |    |        |
	+--------+    +--------+    +--------+    +--------+

The elements of a linked list are referred to as *nodes*. The above picture shows a *singly linked list*, where each node only has a reference -- or a "pointer" -- to the next node. In a *doubly linked list*, shown below, nodes also have pointers to the previous node:

	+--------+    +--------+    +--------+    +--------+
	|        |--->|        |--->|        |--->|        |
	| node 0 |    | node 1 |    | node 2 |    | node 3 |
	|        |<---|        |<---|        |<---|        |
	+--------+    +--------+    +--------+    +--------+

You need to keep track of where the list begins. That's usually done with a pointer called the *head*:

	         +--------+    +--------+    +--------+    +--------+
	head --->|        |--->|        |--->|        |--->|        |---> nil
	         | node 0 |    | node 1 |    | node 2 |    | node 3 |
	 nil <---|        |<---|        |<---|        |<---|        |<--- tail
	         +--------+    +--------+    +--------+    +--------+

It's also useful to have a reference to the end of the list, known as the *tail*. Note that the "next" pointer of the last node is `nil`, just like the "previous" pointer of the very first node.

#### Performance of linked lists

Most operations on a linked list have **O(n)** time, so linked lists are generally slower than arrays. However, they are also much more flexible -- rather than having to copy large chunks of memory around as with an array, many operations on a linked list just require you to change a few pointers.

The reason for the **O(n)** time is that you can't simply write `list[2]` to access node 2 from the list. If you don't have a reference to that node already, you have to start at the `head` and work your way down to that node by following the `next` pointers (or start at the `tail` and work your way back using the `previous` pointers).

But once you have a reference to a node, operations like insertion and deletion are really quick. It's just that finding the node is slow.

This means that when you're dealing with a linked list, you should insert new items at the front whenever possible. That is an **O(1)** operation. Likewise for inserting at the back if you're keeping track of the `tail` pointer.

#### Singly vs doubly linked lists

A singly linked list uses a little less memory than a doubly linked list because it doesn't need to store all those `previous` pointers.

But if you have a node and you need to find its previous node, you're screwed. You have to start at the head of the list and iterate through the entire list until you get to the right node.

For many tasks, a doubly linked list makes things easier.

#### Why use a linked list?

A typical example of where to use a linked list is when you need a [queue](http://67442.cmuis.net/labs/2). With an array, removing elements from the front of the queue is slow because it needs to shift down all the other elements in memory. But with a linked list it's just a matter of changing `head` to point to the second element. Much faster.

But to be honest, you hardly ever need to write your own linked list these days. Still, it's useful to understand how they work; the principle of linking objects together is also used with trees and graphs so by understanding linked lists, you will have an easier time understanding other data structures.