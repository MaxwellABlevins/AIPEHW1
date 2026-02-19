import time
import matplotlib.pyplot as plt
from romania_map import map

# graph search to close out nodes visited
def graph_search(start, end, strategy):

    closed = set()
    fringe = [(start, [start])]
    nodes_expanded = 0
    max_fringe_size = 0 
    
    while fringe:
        # track max memory usage
        if len(fringe) > max_fringe_size:
            max_fringe_size = len(fringe)
            
        # determine strategy
        if strategy == 'BFS':
            current_city, path = fringe.pop(0) #fifo
        elif strategy == 'DFS':
            current_city, path = fringe.pop() #lifo
        
        # check if at goal city
        if current_city == end:
            return path, nodes_expanded, max_fringe_size
        
        # skip to next iteration if visited already
        if current_city in closed:
            continue

        closed.add(current_city)
        nodes_expanded += 1
        
        if current_city in map:
            neighbors = map[current_city]
            
            # go over neighors (distance not needed)
            for neighbor_city in neighbors:
                if neighbor_city not in closed:
                    new_path = path + [neighbor_city]
                    fringe.append((neighbor_city, new_path))
                    
    # if goal isn't found return None            
    return None, nodes_expanded, max_fringe_size