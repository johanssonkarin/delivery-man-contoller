# Delivery Man

In this game, multiple deliveries are randomly placed on a city grid. The scope is to pick up and deliver all the deliveries as fast as possible under changing traffic conditions. Your score is the time it takes for your delivery man to complete this task.

## The script
The script utilizes the [A* algorithm](https://en.wikipedia.org/wiki/A*_search_algorithm) to find the best path for the delivery man dynamically. Since the script is rerun after each move, I did my best trying to keep down the time complexity of the functions. 

The main function takes three arguments:
1. A list of two matrices giving the traffice conditions. The first matrix is named 'hroads' and gives a matrix of traffice conditions on the horizontal roads. The second matrix is named 'vroads' and gives a matrix of traffic conditional on the vertical roads. <1,1> is the bottom left, and <dim,dim> is the top right.
2. A list providing information about your car. This list includes the x and y coordinates of the car with names 'x' and 'y', the package the car is carrying, with name 'load' (this is 0 if no package is being carried), a list called 'mem' that you can use to store information you want to remember from turn to turn, and a field called nextMove where you will write what you want the car to do. Moves are specified as on the number-pad (2 down, 4 left, 6 right, 8 up, 5 stay still).
3. A matrix containing information about the delivery packages. This contains five columns and a row for each package. The first two columns give x and y coordinates about where the package should be picked up from. The next two columns give x and y coordinates about where the package should be delivered to. The final column specifies the package status (0 is not picked up, 1 is picked up but not delivered, 2 is delivered). Your function should return the car object with the nextMove specified.

## Usage
This script needs to be run together with the DeliveryMan package, which is not written by me. However, the tar file is included in the repository.

``` R
runDeliveryMan(carReady = myFunction, dim = 10, turns = 2000, doPlot = T, 
               pause = 0.1, del = 5, verbose = T)
```
