extends Node

const GRID_SIZE: Vector2i = Vector2i(20, 20)

const TILE_SIZE = 16

const MIN_X = -(Constants.TILE_SIZE * Constants.GRID_SIZE.x / 2.0 - Constants.TILE_SIZE / 2.0)
const MAX_X = Constants.TILE_SIZE * Constants.GRID_SIZE.x / 2.0 - Constants.TILE_SIZE / 2.0
const MIN_Y = -(Constants.TILE_SIZE * Constants.GRID_SIZE.y / 2.0 - Constants.TILE_SIZE / 2.0)
const MAX_Y = Constants.TILE_SIZE * Constants.GRID_SIZE.y / 2.0 - Constants.TILE_SIZE / 2.0
