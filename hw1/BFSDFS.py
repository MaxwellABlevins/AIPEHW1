import time

# map of each city and its neigbors
map = {
    'Arad': [('Zerind', 75), ('Sibiu', 140), ('Timisoara', 118)],
    'Zerind': [('Arad', 75), ('Oradea', 71)],
    'Oradea': [('Zerind', 71), ('Sibiu', 151)],
    'Sibiu': [('Arad', 140), ('Oradea', 151), ('Fagaras', 99), ('Rimnicu Vilcea', 80)],
    'Timisoara': [('Arad', 118), ('Lugoj', 111)],
    'Lugoj': [('Timisoara', 111), ('Mehadia', 70)],
    'Mehadia': [('Lugoj', 70), ('Drobeta', 75)],
    'Drobeta': [('Mehadia', 75), ('Craiova', 120)],
    'Craiova': [('Drobeta', 120), ('Rimnicu Vilcea', 146), ('Pitesti', 138)],
    'Rimnicu Vilcea': [('Sibiu', 80), ('Craiova', 146), ('Pitesti', 97)],
    'Fagaras': [('Sibiu', 99), ('Bucharest', 211)],
    'Pitesti': [('Rimnicu Vilcea', 97), ('Craiova', 138), ('Bucharest', 101)],
    'Bucharest': [('Fagaras', 211), ('Pitesti', 101), ('Giurgiu', 90), ('Urziceni', 85)],
    'Giurgiu': [('Bucharest', 90)],
    'Urziceni': [('Bucharest', 85), ('Vaslui', 142), ('Hirsova', 98)],
    'Hirsova': [('Urziceni', 98), ('Eforie', 86)],
    'Eforie': [('Hirsova', 86)],
    'Vaslui': [('Urziceni', 142), ('Iasi', 92)],
    'Iasi': [('Vaslui', 92), ('Neamt', 87)],
    'Neamt': [('Iasi', 87)]
}

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
            
            # unpack tuple to ignore distance
            for neighbor_city, _ in neighbors:
                if neighbor_city not in closed:
                    new_path = path + [neighbor_city]
                    fringe.append((neighbor_city, new_path))
                    
    # if goal isn't found return None               
    return None, nodes_expanded, max_fringe_size

if __name__ == "__main__":
    start_city = 'Arad'
    end_city = 'Bucharest'
    
    # test bfs
    start_time = time.time()
    for _ in range(100):
        path, nodes, space = graph_search(start_city, end_city, 'BFS')
    end_time = time.time()
    
    print(f"BFS Result:")
    print(f"  Path: {path}")
    print(f"  Nodes Expanded: {nodes}")
    print(f"  Max Fringe Size: {space}")
    print(f"  Time: {(end_time - start_time)*1000:.4f} ms")

    # test dfs
    start_time = time.time()
    for _ in range(100):
        path, nodes, space = graph_search(start_city, end_city, 'DFS')
    end_time = time.time()
    
    print(f"\nDFS Result:")
    print(f"  Path: {path}")
    print(f"  Nodes Expanded: {nodes}")
    print(f"  Max Fringe Size: {space}")
    print(f"  Time: {(end_time - start_time)*1000:.4f} ms")