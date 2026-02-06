import heapq
from romania_map import map
import heapq 
from romania_map import straight_to_bucharest

def greedy_search_for_bucharest(start, goal):
    # storing the heuristic value, current city, and the path taken
    fringe = [(straight_to_bucharest[start], start, [start])]
    visited = set()
    places_visited = 0

    while fringe:
        # popping the node for with lowest heuristic value for each
        h_val, current_node, path = heapq.heappop(fringe)
        
        if current_node == goal:
            return path, places_visited

        if current_node not in visited:
            visited.add(current_node)
            places_visited += 1
            
            # seeing what neighbor is best
            for neighbor, distance in map.get(current_node, []):
                if neighbor not in visited:
                    h_neighbor = straight_to_bucharest[neighbor]
                    heapq.heappush(fringe, (h_neighbor, neighbor, path + [neighbor]))

    return None, places_visited

path, efficiency = greedy_search_for_bucharest('Arad', 'Bucharest')
print(f"Path: {path}")
print(f"Places visited: {efficiency}")