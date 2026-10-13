///|
pub struct Grid[T] {
  put_fn : (Int32, Int32, T) -> Unit
  get_fn : (Int32, Int32) -> T
  get_row_fn : (Int32) -> Array[T]
  get_column_fn : (Int32) -> Array[T]
  get_columns_fn : () -> Int32
  get_rows_fn : () -> Int32
  set_grid_size_fn : (Int32, Int32) -> Unit
}

///|
pub fn[T] new_grid(
  put : (Int32, Int32, T) -> Unit,
  get : (Int32, Int32) -> T,
  get_row : (Int32) -> Array[T],
  get_column : (Int32) -> Array[T],
  get_columns : () -> Int32,
  get_rows : () -> Int32,
  set_grid_size : (Int32, Int32) -> Unit,
) -> Grid[T] {
  {
    put_fn: put,
    get_fn: get,
    get_row_fn: get_row,
    get_column_fn: get_column,
    get_columns_fn: get_columns,
    get_rows_fn: get_rows,
    set_grid_size_fn: set_grid_size,
  }
}

///|
pub fn[T] Grid::put(self : Grid[T], col : Int32, row : Int32, item : T) -> Unit {
  (self.put_fn)(col, row, item)
}

///|
pub fn[T] Grid::get(self : Grid[T], col : Int32, row : Int32) -> T {
  (self.get_fn)(col, row)
}

///|
pub fn[T] Grid::get_row(self : Grid[T], row : Int32) -> Array[T] {
  (self.get_row_fn)(row)
}

///|
pub fn[T] Grid::get_column(self : Grid[T], col : Int32) -> Array[T] {
  (self.get_column_fn)(col)
}

///|
pub fn[T] Grid::get_columns(self : Grid[T]) -> Int32 {
  (self.get_columns_fn)()
}

///|
pub fn[T] Grid::get_rows(self : Grid[T]) -> Int32 {
  (self.get_rows_fn)()
}

///|
pub fn[T] Grid::set_grid_size(
  self : Grid[T],
  cols : Int32,
  rows : Int32,
) -> Unit {
  (self.set_grid_size_fn)(cols, rows)
}
