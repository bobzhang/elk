///|
pub struct BinaryIndexedTree {
  mut binary_sums : Array[Int32]
  mut nums_per_index : Array[Int32]
  mut current_size : Int32
  max_num : Int32
}

///|
pub fn new_binary_indexed_tree(max_num : Int32) -> BinaryIndexedTree {
  {
    binary_sums: Array::make(max_num + 1, 0),
    nums_per_index: Array::make(max_num, 0),
    current_size: 0,
    max_num,
  }
}

///|
pub fn BinaryIndexedTree::add(self : BinaryIndexedTree, index : Int32) -> Unit {
  self.current_size = self.current_size + 1
  self.nums_per_index[index] = self.nums_per_index[index] + 1
  let mut i = index + 1
  while i < self.binary_sums.length() {
    self.binary_sums[i] = self.binary_sums[i] + 1
    i = i + (i & -i)
  }
}

///|
pub fn BinaryIndexedTree::rank(
  self : BinaryIndexedTree,
  index : Int32,
) -> Int32 {
  let mut i = index
  let mut sum = 0
  while i > 0 {
    sum = sum + self.binary_sums[i]
    i = i - (i & -i)
  }
  sum
}

///|
pub fn BinaryIndexedTree::size(self : BinaryIndexedTree) -> Int32 {
  self.current_size
}

///|
pub fn BinaryIndexedTree::remove_all(
  self : BinaryIndexedTree,
  index : Int32,
) -> Unit {
  let num_entries = self.nums_per_index[index]
  if num_entries == 0 {
    return
  }
  self.nums_per_index[index] = 0
  self.current_size = self.current_size - num_entries
  let mut i = index + 1
  while i < self.binary_sums.length() {
    self.binary_sums[i] = self.binary_sums[i] - num_entries
    i = i + (i & -i)
  }
}

///|
pub fn BinaryIndexedTree::clear(self : BinaryIndexedTree) -> Unit {
  self.binary_sums = Array::make(self.max_num + 1, 0)
  self.nums_per_index = Array::make(self.max_num, 0)
  self.current_size = 0
}

///|
pub fn BinaryIndexedTree::is_empty(self : BinaryIndexedTree) -> Bool {
  self.current_size == 0
}
