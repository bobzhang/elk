///|
pub struct IThreeValueGrid {
  get_width_fn : () -> Int32
  get_height_fn : () -> Int32
  is_empty_fn : (Int32, Int32) -> Bool raise
  is_blocked_fn : (Int32, Int32) -> Bool raise
  is_weakly_blocked_fn : (Int32, Int32) -> Bool raise
  in_bounds_fn : (Int32, Int32) -> Bool
  reinitialize_fn : (Int32, Int32) -> Unit raise
  set_empty_fn : (Int32, Int32) -> Unit raise
  set_blocked_fn : (Int32, Int32) -> Unit raise
  set_weakly_blocked_fn : (Int32, Int32) -> Unit raise
}

///|
pub fn new_three_value_grid(
  get_width_fn : () -> Int32,
  get_height_fn : () -> Int32,
  is_empty_fn : (Int32, Int32) -> Bool raise,
  is_blocked_fn : (Int32, Int32) -> Bool raise,
  is_weakly_blocked_fn : (Int32, Int32) -> Bool raise,
  in_bounds_fn : (Int32, Int32) -> Bool,
  reinitialize_fn : (Int32, Int32) -> Unit raise,
  set_empty_fn : (Int32, Int32) -> Unit raise,
  set_blocked_fn : (Int32, Int32) -> Unit raise,
  set_weakly_blocked_fn : (Int32, Int32) -> Unit raise,
) -> IThreeValueGrid {
  {
    get_width_fn,
    get_height_fn,
    is_empty_fn,
    is_blocked_fn,
    is_weakly_blocked_fn,
    in_bounds_fn,
    reinitialize_fn,
    set_empty_fn,
    set_blocked_fn,
    set_weakly_blocked_fn,
  }
}

///|
pub fn new_three_value_grid_from_two_bit_grid(
  grid : TwoBitGrid,
) -> IThreeValueGrid {
  new_three_value_grid(
    () => grid.width(),
    () => grid.height(),
    fn(x, y) raise { grid.is_empty(x, y) },
    fn(x, y) raise { grid.is_blocked(x, y) },
    fn(x, y) raise { grid.is_weakly_blocked(x, y) },
    (x, y) => grid.in_bounds(x, y),
    fn(width, height) raise { grid.reinitialize(width, height) },
    fn(x, y) raise { grid.set_empty(x, y) },
    fn(x, y) raise { grid.set_blocked(x, y) },
    fn(x, y) raise { grid.set_weakly_blocked(x, y) },
  )
}

///|
pub fn IThreeValueGrid::get_width(self : IThreeValueGrid) -> Int32 {
  (self.get_width_fn)()
}

///|
pub fn IThreeValueGrid::get_height(self : IThreeValueGrid) -> Int32 {
  (self.get_height_fn)()
}

///|
pub fn IThreeValueGrid::is_empty(
  self : IThreeValueGrid,
  x : Int32,
  y : Int32,
) -> Bool raise {
  (self.is_empty_fn)(x, y)
}

///|
pub fn IThreeValueGrid::is_blocked(
  self : IThreeValueGrid,
  x : Int32,
  y : Int32,
) -> Bool raise {
  (self.is_blocked_fn)(x, y)
}

///|
pub fn IThreeValueGrid::is_weakly_blocked(
  self : IThreeValueGrid,
  x : Int32,
  y : Int32,
) -> Bool raise {
  (self.is_weakly_blocked_fn)(x, y)
}

///|
pub fn IThreeValueGrid::in_bounds(
  self : IThreeValueGrid,
  x : Int32,
  y : Int32,
) -> Bool {
  (self.in_bounds_fn)(x, y)
}

///|
pub fn IThreeValueGrid::reinitialize(
  self : IThreeValueGrid,
  width : Int32,
  height : Int32,
) -> Unit raise {
  (self.reinitialize_fn)(width, height)
}

///|
pub fn IThreeValueGrid::set_empty(
  self : IThreeValueGrid,
  x : Int32,
  y : Int32,
) -> Unit raise {
  (self.set_empty_fn)(x, y)
}

///|
pub fn IThreeValueGrid::set_blocked(
  self : IThreeValueGrid,
  x : Int32,
  y : Int32,
) -> Unit raise {
  (self.set_blocked_fn)(x, y)
}

///|
pub fn IThreeValueGrid::set_weakly_blocked(
  self : IThreeValueGrid,
  x : Int32,
  y : Int32,
) -> Unit raise {
  (self.set_weakly_blocked_fn)(x, y)
}
