///|
/// Sorts `array` in place like `java.util.Collections.sort` does once ELK is
/// compiled to JavaScript (elkjs): GWT's `Arrays.mergeSort`, a top-down merge
/// sort that falls back to insertion sort for fewer than seven elements.
///
/// The model order comparators are not transitive, so the result depends on
/// which elements get compared and in which order; any other stable sort would
/// order some lists differently than elkjs does.
fn[T] preserveorder_gwt_merge_sort(
  array : Array[T],
  compare : (T, T) -> Int32 raise,
) -> Unit raise {
  let temp = array.copy()
  preserveorder_gwt_merge_sort_range(temp, array, 0, array.length(), 0, compare)
}

///|
fn[T] preserveorder_gwt_merge_sort_range(
  temp : Array[T],
  array : Array[T],
  low : Int32,
  high : Int32,
  offset : Int32,
  compare : (T, T) -> Int32 raise,
) -> Unit raise {
  if high - low < 7 {
    for i = low + 1; i < high; i = i + 1 {
      for j = i; j > low && compare(array[j - 1], array[j]) > 0; j = j - 1 {
        let element = array[j]
        array[j] = array[j - 1]
        array[j - 1] = element
      }
    }
    return
  }

  // Sort both halves recursively, using the array as temporary space.
  let temp_low = low + offset
  let temp_high = high + offset
  let temp_mid = temp_low + ((temp_high - temp_low) >> 1)
  preserveorder_gwt_merge_sort_range(
    array,
    temp,
    temp_low,
    temp_mid,
    -offset,
    compare,
  )
  preserveorder_gwt_merge_sort_range(
    array,
    temp,
    temp_mid,
    temp_high,
    -offset,
    compare,
  )

  // Skip the merge if the halves are already in order.
  if compare(temp[temp_mid - 1], temp[temp_mid]) <= 0 {
    for i = low, k = temp_low; i < high; i = i + 1, k = k + 1 {
      array[i] = temp[k]
    }
    return
  }

  let mut left = temp_low
  let mut right = temp_mid
  for i = low; i < high; i = i + 1 {
    if right >= temp_high ||
      (left < temp_mid && compare(temp[left], temp[right]) <= 0) {
      array[i] = temp[left]
      left = left + 1
    } else {
      array[i] = temp[right]
      right = right + 1
    }
  }
}
