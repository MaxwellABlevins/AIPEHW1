import heapq
from romania_map import map
import heapq 
from romania_map import straight_to_bucharest

def greedy_best_first_search(start, goal, heuristic):
    # storing the heuristic value, current city, and the path taken
    fringe = [(heuristic[start], start, [start])]
    visited = set()
    nodes_expanded = 0

    while fringe:
        # popping the node for with lowest heuristic value for each
        h_val, current_node, path = heapq.heappop(fringe)
        
        if current_node == goal:
            return path, nodes_expanded

        if current_node not in visited:
            visited.add(current_node)
            nodes_expanded += 1
            
            # seeing what neighbor is best
            for neighbor, distance in map.get(current_node, []):
                if neighbor not in visited:
                    h_neighbor = heuristic[neighbor]
                    heapq.heappush(fringe, (h_neighbor, neighbor, path + [neighbor]))

    return None, nodes_expanded

path, efficiency = greedy_best_first_search('Arad', 'Bucharest', straight_to_bucharest)
print(f"Path: {path}")
print(f"Nodes visited: {efficiency}")