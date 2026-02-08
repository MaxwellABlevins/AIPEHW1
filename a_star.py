from romania_map import map, straight_to_bucharest
from typing import Dict
import heapq
import io


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


def a_star(start_city: str, end_city: str = "Bucharest") -> tuple[str, int]:
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
    collapsed_nodes: list[node] = [start]

    while True:

        collapsed_nodes[0].expand()

        for child in heapq.heappop(collapsed_nodes).children:
            heapq.heappush(collapsed_nodes, child)

        if collapsed_nodes[0].name == end_city:
            return collapsed_nodes[0].path(), collapsed_nodes[0].distance_from_start

# Example usage:
# print(a_star("Arad"))

def generate_distances_to_bucharest():
    goal = "Bucharest"
    distances_to_bucharest: Dict[str, int] = dict()
    for city in map.keys():
        distances_to_bucharest[city] = a_star(city, goal)[1]
        
    with io.open("distances_to_bucharest.py", 'w') as f:
        f.write(f"distances_to_bucharest = {str(distances_to_bucharest)}")