import time
import matplotlib.pyplot as plt
from BFSDFS import graph_search
from a_star import a_star
from greedy import greedy_search_for_bucharest
from romania_map import map

def run_comparison(start_city='Arad', end_city='Bucharest', iterations=100):
    results = {}
    
    # Test BFS
    start_time = time.time()
    for _ in range(iterations):
        path, nodes, space = graph_search(start_city, end_city, 'BFS')
    end_time = time.time()
    bfs_time = (end_time - start_time) / iterations * 1000
    results['BFS'] = {
        'nodes_visited': nodes,
        'time_ms': bfs_time,
        'path_length': len(path) if path else 0,
        'max_fringe_size': space,
        'path': path
    }
    
    # Test DFS
    start_time = time.time()
    for _ in range(iterations):
        path, nodes, space = graph_search(start_city, end_city, 'DFS')
    end_time = time.time()
    dfs_time = (end_time - start_time) / iterations * 1000
    results['DFS'] = {
        'nodes_visited': nodes,
        'time_ms': dfs_time,
        'path_length': len(path) if path else 0,
        'max_fringe_size': space,
        'path': path
    }
    
    # Test A*
    start_time = time.time()
    for _ in range(iterations):
        path, distance, nodes, space = a_star(start_city, end_city)
    end_time = time.time()
    astar_time = (end_time - start_time) / iterations * 1000
    results['A*'] = {
        'nodes_visited': nodes,
        'time_ms': astar_time,
        'path_length': len(path) if path else 0,
        'max_fringe_size': space,
        'distance': distance,
        'path': path
    }
    
    # Test Greedy/Best First
    start_time = time.time()
    for _ in range(iterations):
        path, nodes, space = greedy_search_for_bucharest(start_city, end_city)
    end_time = time.time()
    greedy_time = (end_time - start_time) / iterations * 1000
    results['Greedy'] = {
        'nodes_visited': nodes,
        'time_ms': greedy_time,
        'path_length': len(path) if path else 0,
        'max_fringe_size': space,
        'path': path
    }
    
    return results

def create_scatterplot(results):
    plt.style.use('default')
    
    fig, ax = plt.subplots(figsize=(10, 6))
    
    colors = {'BFS': 'blue', 'DFS': 'red', 'A*': 'green', 'Greedy': 'orange'}
    
    for algo in results.keys():
        nodes = results[algo]['nodes_visited']
        time_ms = results[algo]['time_ms']
        fringe_size = results[algo]['max_fringe_size']
        
        size = fringe_size * 20
        
        ax.scatter(nodes, time_ms, c=colors[algo], label=f"{algo} (fringe: {fringe_size})", 
                  s=size, alpha=0.7)
    
    ax.set_xlabel('Nodes Visited')
    ax.set_ylabel('Execution Time (ms)')
    ax.set_title('Search Algorithm Comparison: Arad to Bucharest')
    ax.legend()
    ax.grid(True, alpha=0.3)
    
    plt.tight_layout()
    plt.savefig('algorithm_comparison.png', dpi=150)
    print("\n'algorithm_comparison.png' saved to pc.")
    plt.show()
    
def collect_astar_distances():
    """
    beginning work for the part 2 of the assignment (a* for all cities to bucharest)
    printing them for now
    """ 
    all_cities = sorted(map.keys())
    
    for city in all_cities:
        if city == 'Bucharest':
            print(f"{city:<20} {0:<20}")
        else:
            result = a_star(city, 'Bucharest')
            if result:
                path, distance, nodes, fringe = result
                print(f"{city:<20} {distance:<20}")
            else:
                print(f"{city:<20} {'No path found':<20}")

if __name__ == "__main__":

    results = run_comparison(start_city='Arad', end_city='Bucharest', iterations=100)
    create_scatterplot(results)
    
    # for part 2 were printing the distances for now
    collect_astar_distances()
