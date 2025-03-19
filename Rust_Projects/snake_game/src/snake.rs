use std::collections::LinkedList;
use piston_window::{Context, G2d};
use piston_window::types::Color;
use crate::draw::{draw_block};

const SNAKE_COLOR: Color = [0.00, 0.80, 0.00, 1.0];
const SNAKE_HEAD_COLOR: Color = [0.00, 0.00, 0.00, 1.0]; // Black color for the head
const BLOCK_SIZE: f64 = 5.0; // Thinner snake

#[derive(Copy, Clone, PartialEq)]
pub enum Direction {
    Up,
    Down,
    Right,
    Left,
}

impl Direction {
    pub fn opposite(&self) -> Direction {
        match *self {
            Direction::Up => Direction::Down,
            Direction::Down => Direction::Up,
            Direction::Left => Direction::Right,
            Direction::Right => Direction::Left,
        }
    }
}

#[derive(Debug, Clone)]
struct Block {
    x: i32,
    y: i32,
}

pub struct Snake {
    direction: Direction,
    body: LinkedList<Block>,
    tail: Option<Block>,
}

impl Snake {
    pub fn new(x: i32, y: i32) -> Snake {
        let mut body: LinkedList<Block> = LinkedList::new();
        body.push_back(Block { x: x + 2, y });
        body.push_back(Block { x: x + 1, y });
        body.push_back(Block { x, y });
        Snake { direction: Direction::Right, body, tail: None }
    }

    pub fn draw(&self, con: &Context, g: &mut G2d) {
        let mut blocks_iter = self.body.iter();
        if let Some(head) = blocks_iter.next() {
            draw_block(SNAKE_HEAD_COLOR, head.x, head.y, con, g); // Draw head with black color
        }
        for block in blocks_iter {
            draw_block(SNAKE_COLOR, block.x, block.y, con, g);
        }
    }

    pub fn head_position(&self) -> (i32, i32) {
        let head_block = self.body.front().unwrap();
        (head_block.x, head_block.y)
    }

    pub fn move_forward(&mut self, dir: Option<Direction>) {
        if let Some(d) = dir {
            self.direction = d;
        }
        let (last_x, last_y) = self.head_position();
        let new_block = match self.direction {
            Direction::Up => Block { x: last_x, y: last_y - 1 },
            Direction::Down => Block { x: last_x, y: last_y + 1 },
            Direction::Left => Block { x: last_x - 1, y: last_y },
            Direction::Right => Block { x: last_x + 1, y: last_y },
        };
        self.body.push_front(new_block);
        let remove_block = self.body.pop_back().unwrap();
        self.tail = Some(remove_block);
    }

    pub fn head_direction(&self) -> Direction {
        self.direction
    }

    pub fn next_head_position(&self, dir: Option<Direction>) -> (i32, i32) {
        let (head_x, head_y) = self.head_position();
        let moving_dir = dir.unwrap_or(self.direction);
        match moving_dir {
            Direction::Up => (head_x, head_y - 1),
            Direction::Down => (head_x, head_y + 1),
            Direction::Left => (head_x - 1, head_y),
            Direction::Right => (head_x + 1, head_y),
        }
    }

    pub fn restore_tail(&mut self) {
        if let Some(blk) = self.tail.clone() {
            self.body.push_back(blk);
        }
    }

    pub fn overlap_tail(&self, x: i32, y: i32) -> bool {
        let mut count = 0;
        for block in self.body.iter() {
            if x == block.x && y == block.y {
                return true;
            }
            count += 1;
            if count == self.body.len() - 1 {
                break;
            }
        }
        false
    }
}
