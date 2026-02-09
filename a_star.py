from romania_map import map, straight_to_bucharest
from typing import Dict
import heapq


class node:
    def __init__(self, name, parent, distance_from_start):
        """
        Initialize node from name, parent, and distance
        """
        self.name: str = name
        self.parent: node = parent
        self.distance_from_start: int = distance_from_start

        # Initialize empty children list
        self.children: list[node] = []

    def expand(self):
        """
        Add geographic neighbors to children list
        """
        neighbors: Dict[str, int] = map[self.name]

        # Return if already expanded
        if len(self.children):
            return

        for name, distance in neighbors.items():
            self.children.append(
                node(
                    name=name,
                    parent=self,
                    distance_from_start=self.distance_from_start + distance,
                )
            )

    def path(self) -> list[str]:
        """
        Return path from start to this node
        """
        if self.parent == None:
            return [self.name]
        else:
            return self.parent.path() + [self.name]

    def estimate(self) -> int:
        """
        Return estimated cost from start to goal through this node
        """
        return self.distance_from_start + straight_to_bucharest[self.name]

    def __lt__(self, other):
        """
        Less than operator for comparing nodes from estimate
        """
        return self.estimate() < other.estimate()


def a_star(start_city: str, end_city: str = "Bucharest") -> tuple[str, int, int, int]:
    """
    Perform A* search from start_city to end_city
    """
    if start_city not in map.keys():
        print(f"Start city '{start_city}' not in map.")
        return None

    if end_city not in map.keys():
        print(f"End city '{end_city}' not in map.")
        return None

    start = node(start_city, None, 0)
    fringe: list[node] = [start]
    visited = set()
    nodes_expanded = 0
    max_fringe_size = 1

    while fringe:
        current = heapq.heappop(fringe)
        
        if current.name in visited:
            continue
        
        visited.add(current.name)
        nodes_expanded += 1
        
        if current.name == end_city:
            return current.path(), current.distance_from_start, nodes_expanded, max_fringe_size
        
        current.expand()
        
        for child in current.children:
            if child.name not in visited:
                heapq.heappush(fringe, child)
        
        if len(fringe) > max_fringe_size:
            max_fringe_size = len(fringe)
    
    return None