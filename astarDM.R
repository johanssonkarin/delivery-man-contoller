library(DeliveryMan)

#function computing manhattan distance between node and car
manhattanDistance = function(node1x, node1y, node2x, node2y){ 
  return( abs(node1x - node2x) + abs(node1y - node2y))
}

findMatchingNodeIndex = function(theList, neighbor){
  if(length(theList)==0){return(0)}
  index = which(sapply(theList,function(node)(node$x==neighbor$x && node$y==neighbor$y)))
  ifelse(length(index)==0, return(0), return(index))
}

#function returning the surrounding neighbor-nodes as a list
calculateNeighbors = function(parent, goal, roads, frontier){
  if(parent$x > 1){ #expand left
    x = parent$x -1
    y = parent$y
    g = roads$hroads[x,y]
    h = manhattanDistance(x,y,goal$x,goal$y)
    f = parent$f + g + h
    fm <- ifelse(parent$first_move==5, 4, parent$first_move)
    node = list(x,y,g,h,f,fm)
    names(node) = c("x","y","g","h","f","first_move")
    index = findMatchingNodeIndex(frontier,node)
    if(index == 0){
      frontier <- append(list(node),frontier)}
    else{ if(frontier[[index]]$f > node$f) {
        frontier[[index]] <- node}
      }
  }
  if(parent$x<10){ #expand right
    x = parent$x +1
    y = parent$y
    g = roads$hroads[x-1,y]
    h = manhattanDistance(x,y,goal$x,goal$y)
    f = parent$f + g + h
    fm <- ifelse(parent$first_move==5, 6, parent$first_move)
    node = list(x,y,g,h,f,fm)
    names(node) = c("x","y","g","h","f","first_move")
    index = findMatchingNodeIndex(frontier,node)
    if(index == 0){
      frontier <- append(list(node),frontier)}
    else{ if(frontier[[index]]$f > node$f) {
      frontier[[index]] <- node}
    }
  }
  if(parent$y>1){ #expand down
    x = parent$x
    y = parent$y-1
    g = roads$vroads[x,y]
    h = manhattanDistance(x,y,goal$x,goal$y)
    f = parent$f + g + h
    fm <- ifelse(parent$first_move==5, 2, parent$first_move)
    node = list(x,y,g,h,f,fm)
    names(node) = c("x","y","g","h","f","first_move")
    index = findMatchingNodeIndex(frontier,node)
    if(index == 0){
      frontier <- append(list(node),frontier)}
    else{ if(frontier[[index]]$f > node$f) {
      frontier[[index]] <- node}
    }
  }
  if(parent$y<10){ #expand up
    x = parent$x
    y = parent$y+1
    g = roads$vroads[x,y-1]
    h = manhattanDistance(x,y,goal$x,goal$y)
    f = parent$f + g + h
    fm <- ifelse(parent$first_move==5, 8, parent$first_move)
    node = list(x,y,g,h,f,fm)
    names(node) = c("x","y","g","h","f","first_move")
    index = findMatchingNodeIndex(frontier,node)
    if(index == 0){
      frontier <- append(list(node),frontier)
    } else{ if(frontier[[index]]$f > node$f) {
      frontier[[index]] <- node}
    }
  }
  return(frontier)
}

#function which takes car, start[x,y] and goal[x,y] and returns nextMove i.e {4,8,2,6}
aStar = function(car, roads, start, goal){
  if(start$x == goal$x && start$y == goal$y){return(5)}
  node = list( x = start$x,
               y = start$y,
               g = 0,
               h = manhattanDistance(start$x,start$y,goal$x,goal$y),
               f= 0,
               first_move = 5) 
  frontier = list(node)
  repeat{
    node_costs = sapply(frontier,function(node)(node$f))
    best_index = which.min(node_costs)
    node_to_expand = frontier[[best_index]]
    if(node_to_expand$x == goal$x && node_to_expand$y == goal$y){break} #Stop if the goal node is about to be expanded
    frontier <- calculateNeighbors(node_to_expand, goal, roads, frontier[-best_index])
    } 
  scores=sapply(frontier,function(node)node$f)
  best_index=which.min(scores)
  return(frontier[[best_index]]$first_move)
  }


myFunction = function(roads,car,packages) {
  nextMove=5
  toGo=1
  if (car$load==0) { #checks is there is already a package in the car
    packagesLeft=which(packages[,5]==0)
    distList = c()
    for(i in 1:length(packagesLeft)) #manhattan distance for all packages
    {distList <- c(distList,manhattanDistance(packages[packagesLeft[i],][1],packages[packagesLeft[i],][2] ,car$x,car$y))}
    toGo = packagesLeft[which.min(distList)] #choose closest package
    nextMove = aStar(car,roads,list(x=car$x,y=car$y),list(x = packages[toGo,][1], y=packages[toGo,][2]))
  }
  else {
    toGo=car$load
    nextMove = aStar(car,roads,list(x=car$x,y=car$y),list(x = packages[toGo,][3], y=packages[toGo,][4]))
  }
  car$nextMove=nextMove
  car$mem=list()
  return (car)
}

#example useage  
#testDM(myFunction, verbose = 0, returnVec = FALSE, n = 500, seed = 21,timeLimit = 250)
#runDeliveryMan(carReady = myFunction, dim = 10, turns = 2000, doPlot = T, pause = 0.1, del = 5, verbose = T)
