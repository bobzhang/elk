///|
fn graphviz_input_stream_range_start(offset : Int32) -> Int32 {
  if offset < 0 {
    0
  } else {
    offset
  }
}

///|
fn graphviz_input_stream_range_end(
  bytes : Array[Int32],
  offset : Int32,
  length : Int32,
) -> Int32 {
  let start = graphviz_input_stream_range_start(offset)
  let requested_end = start + (if length < 0 { 0 } else { length })
  if requested_end > bytes.length() {
    bytes.length()
  } else {
    requested_end
  }
}

///|
pub struct GraphvizInputStream {
  read_fn : () -> Int32
  read_bytes_fn : (Array[Int32]) -> Int32
  read_bytes_with_offset_fn : (Array[Int32], Int32, Int32) -> Int32
  skip_fn : (Int32) -> Int32
  available_fn : () -> Int32
  close_fn : () -> Unit
  mark_fn : (Int32) -> Unit
  reset_fn : () -> Unit
  mark_supported_fn : () -> Bool
}

///|
pub fn new_graphviz_input_stream(
  read_fn : () -> Int32,
  read_bytes_fn : (Array[Int32]) -> Int32,
  read_bytes_with_offset_fn : (Array[Int32], Int32, Int32) -> Int32,
  skip_fn : (Int32) -> Int32,
  available_fn : () -> Int32,
  close_fn : () -> Unit,
  mark_fn : (Int32) -> Unit,
  reset_fn : () -> Unit,
  mark_supported_fn : () -> Bool,
) -> GraphvizInputStream {
  {
    read_fn,
    read_bytes_fn,
    read_bytes_with_offset_fn,
    skip_fn,
    available_fn,
    close_fn,
    mark_fn,
    reset_fn,
    mark_supported_fn,
  }
}

///|
pub fn GraphvizInputStream::read(self : GraphvizInputStream) -> Int32 {
  (self.read_fn)()
}

///|
pub fn GraphvizInputStream::read_bytes(
  self : GraphvizInputStream,
  bytes : Array[Int32],
) -> Int32 {
  (self.read_bytes_fn)(bytes)
}

///|
pub fn GraphvizInputStream::read_bytes_with_offset(
  self : GraphvizInputStream,
  bytes : Array[Int32],
  off : Int32,
  len : Int32,
) -> Int32 {
  (self.read_bytes_with_offset_fn)(bytes, off, len)
}

///|
pub fn GraphvizInputStream::skip(
  self : GraphvizInputStream,
  n : Int32,
) -> Int32 {
  (self.skip_fn)(n)
}

///|
pub fn GraphvizInputStream::available(self : GraphvizInputStream) -> Int32 {
  (self.available_fn)()
}

///|
pub fn GraphvizInputStream::close(self : GraphvizInputStream) -> Unit {
  (self.close_fn)()
}

///|
pub fn GraphvizInputStream::mark(
  self : GraphvizInputStream,
  readlimit : Int32,
) -> Unit {
  (self.mark_fn)(readlimit)
}

///|
pub fn GraphvizInputStream::reset(self : GraphvizInputStream) -> Unit {
  (self.reset_fn)()
}

///|
pub fn GraphvizInputStream::mark_supported(self : GraphvizInputStream) -> Bool {
  (self.mark_supported_fn)()
}

///|
pub struct GraphvizByteArrayInputStream {
  data : Array[Int32]
  index_ref : Ref[Int32]
  mark_ref : Ref[Int32]
  closed_ref : Ref[Bool]
}

///|
pub fn new_graphviz_byte_array_input_stream(
  data : Array[Int32],
) -> GraphvizByteArrayInputStream {
  { data, index_ref: Ref(0), mark_ref: Ref(0), closed_ref: Ref(false), }
}

///|
pub fn GraphvizByteArrayInputStream::as_input_stream(
  self : GraphvizByteArrayInputStream,
) -> GraphvizInputStream {
  let read_fn = () => {
    if self.closed_ref.val || self.index_ref.val >= self.data.length() {
      -1
    } else {
      let value = self.data[self.index_ref.val]
      self.index_ref.val = self.index_ref.val + 1
      value
    }
  }
  let read_bytes_with_offset_fn = (
    bytes : Array[Int32],
    off : Int32,
    len : Int32,
  ) => {
    if self.closed_ref.val {
      return -1
    }
    if self.index_ref.val >= self.data.length() {
      return -1
    }
    let start = graphviz_input_stream_range_start(off)
    let end_ = graphviz_input_stream_range_end(bytes, off, len)
    let requested = end_ - start
    if requested <= 0 {
      return 0
    }
    let remaining = self.data.length() - self.index_ref.val
    let count = if requested < remaining { requested } else { remaining }
    let mut index = 0
    while index < count {
      bytes[start + index] = self.data[self.index_ref.val + index]
      index += 1
    }
    self.index_ref.val = self.index_ref.val + count
    count
  }
  let read_bytes_fn = (bytes : Array[Int32]) => {
    read_bytes_with_offset_fn(bytes, 0, bytes.length())
  }
  let skip_fn = (n : Int32) => {
    if self.closed_ref.val || n <= 0 {
      return 0
    }
    let remaining = self.data.length() - self.index_ref.val
    let count = if n < remaining { n } else { remaining }
    self.index_ref.val = self.index_ref.val + count
    count
  }
  let available_fn = () => {
    if self.closed_ref.val {
      0
    } else {
      self.data.length() - self.index_ref.val
    }
  }
  let close_fn = () => self.closed_ref.val = true
  let mark_fn = (_readlimit : Int32) => {
    if !self.closed_ref.val {
      self.mark_ref.val = self.index_ref.val
    }
  }
  let reset_fn = () => {
    if !self.closed_ref.val {
      self.index_ref.val = self.mark_ref.val
    }
  }
  let mark_supported_fn = () => true

  new_graphviz_input_stream(
    read_fn, read_bytes_fn, read_bytes_with_offset_fn, skip_fn, available_fn, close_fn,
    mark_fn, reset_fn, mark_supported_fn,
  )
}

///|
pub fn GraphvizByteArrayInputStream::is_closed(
  self : GraphvizByteArrayInputStream,
) -> Bool {
  self.closed_ref.val
}

///|
pub struct ForwardingInputStream {
  input_stream : GraphvizInputStream
  output_stream : GraphvizOutputStream
}

///|
pub fn new_forwarding_input_stream(
  input_stream : GraphvizInputStream,
  output_stream : GraphvizOutputStream,
) -> ForwardingInputStream {
  { input_stream, output_stream, }
}

///|
pub fn ForwardingInputStream::read(self : ForwardingInputStream) -> Int32 {
  let data = self.input_stream.read()
  if data >= 0 {
    self.output_stream.write(data)
  }
  data
}

///|
pub fn ForwardingInputStream::read_bytes(
  self : ForwardingInputStream,
  bytes : Array[Int32],
) -> Int32 {
  let count = self.input_stream.read_bytes(bytes)
  if count > 0 {
    self.output_stream.write_bytes(bytes, 0, count)
  }
  count
}

///|
pub fn ForwardingInputStream::read_bytes_with_offset(
  self : ForwardingInputStream,
  bytes : Array[Int32],
  off : Int32,
  len : Int32,
) -> Int32 {
  let count = self.input_stream.read_bytes_with_offset(bytes, off, len)
  if count > 0 {
    self.output_stream.write_bytes(bytes, off, count)
  }
  count
}

///|
pub fn ForwardingInputStream::skip(
  self : ForwardingInputStream,
  n : Int32,
) -> Int32 {
  self.input_stream.skip(n)
}

///|
pub fn ForwardingInputStream::available(self : ForwardingInputStream) -> Int32 {
  self.input_stream.available()
}

///|
pub fn ForwardingInputStream::close(self : ForwardingInputStream) -> Unit {
  self.input_stream.close()
}

///|
pub fn ForwardingInputStream::mark(
  self : ForwardingInputStream,
  readlimit : Int32,
) -> Unit {
  self.input_stream.mark(readlimit)
}

///|
pub fn ForwardingInputStream::reset(self : ForwardingInputStream) -> Unit {
  self.input_stream.reset()
}

///|
pub fn ForwardingInputStream::mark_supported(
  self : ForwardingInputStream,
) -> Bool {
  self.input_stream.mark_supported()
}
