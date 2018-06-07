"""
Simulation of a toy robot moving on a square tabletop,
of dimensions 5 units x 5 units.
If you need visualize desc and robot
.....
... ^.
.....
.....
.....
print(robot)
< - WEST
> - EAST
^ - NORTH
\u2304 - SOUTH
"""

import sys
from itertools import cycle

# Table size
# There are no other obstructions on the table surface.

MAX_X = 5
MAX_Y = 5
INPUT_FILE = sys.stdin

# If you need console debugger like me to not conflict with sys.stdin
# INPUT_FILE = open('sample.in')

VALID_DIRECTIONS = ['NORTH', 'EAST', 'SOUTH', 'WEST']


class Robot:
    """
    Robot class to have more readable data structure when working with Robot
    and directions
    """
    def __init__(self, x, y, direction):
        self.x = x
        self.y = (MAX_Y - 1) - y
        self.direction = direction

    def move(self):
        """
        A robot that is not on the table can choose to ignore the
        MOVE, LEFT, RIGHT and REPORT commands.
        Any move that would cause the robot to fall must be ignored.
        If I understand correctly what do you mean :)
        """
        if self.direction == 'NORTH':
            self.y = max(self.y - 1, 0)
        elif self.direction == 'SOUTH':
            self.y = min(self.y + 1, MAX_Y - 1)
        elif self.direction == 'WEST':
            self.x = max(self.x - 1, 0)
        elif self.direction == 'EAST':
            self.x = min(self.x + 1, MAX_X - 1)

    def change_direction(self, new_direction):
        """
        Change direction during robot's movement
        """
        if new_direction == 'RIGHT':
            found = 0
            for item in cycle(VALID_DIRECTIONS):
                if item == self.direction:
                    found = 1
                    continue
                if found:
                    self.direction = item
                    break
        # new_direction == 'RIGHT'
        else:
            found = 0
            for item in cycle(reversed(VALID_DIRECTIONS)):
                if item == self.direction:
                    found = 1
                    continue
                if found:
                    self.direction = item
                    break

    def output(self):
        """
        Specific format of output due to task specification
        """
        # (MAX_Y - 1) - self.y we need rotate matrix back
        return 'Output: {},{},{}'.format(self.x, (MAX_Y - 1) - self.y,
                                         self.direction)

    def __str__(self):
        result = ''
        for y in range(MAX_Y):
            for x in range(MAX_X):
                if x == self.x and y == self.y:
                    if self.direction == 'NORTH':
                        result += '^'
                    elif self.direction == 'EAST':
                        result += '>'
                    elif self.direction == 'WEST':
                        result += '<'
                    elif self.direction == 'SOUTH':
                        result += '\u2304'
                else:
                    result += '.'
            result += '\n'
        return result


def main():
    """
    Just placeholder to run everything
    """
    for line in INPUT_FILE:
        try:
            place, xy_direction, *movements, report = line.strip().split()
            if place != 'PLACE':
                print('Output: we should put Robot to table first')
                continue
            x0, y0, init_direction = xy_direction.split(',')
            x0, y0 = int(x0), int(y0)
        except ValueError:
            print('Output: we support only format PLACE 0,0,NORTH OUTPUT')
            continue

        if x0 > (MAX_X - 1) or y0 > (MAX_Y - 1):
            print('Output: x0 or y0 must be less than MAX_X - 1 or MAX_Y - 1')
            continue
        robot = Robot(x0, y0, init_direction)
        # If you need visualize desc and robot
        # .....
        # ...^.
        # .....
        # .....
        # .....
        # print(robot)
        for movement in movements:
            if movement == 'MOVE':
                robot.move()
                # print(robot.output())
            elif movement in ('LEFT', 'RIGHT'):
                robot.change_direction(movement)
        if report == 'REPORT':
            # print(robot)
            print(robot.output())


if __name__ == '__main__':
    main()
