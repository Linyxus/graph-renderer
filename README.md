# graph-renderer
A graph renderer by QtQuick.
## Compilation
The project compilation is passed on the platform of `Qt 5.7.1`
## Instructions
![f_4953.png](http://linfile.xyz/data/vip_data/f_4953.png)

You can use some simple commands to draw your graph.

### Grid
```
grid row column
```
or replace `grid` with `g`.

This command will generate a grid*(row, column)* to do the following rendering.**It is necessary**.If your commands do not include `grid`, renderer will throw an error.

Like this:

![f_5187.png](http://linfile.xyz/data/vip_data/f_5187.png)

**So `grid` is recommended to be your first command anyway.**

### Vertax
```
vertax row column index
```
or replace `vertax` with `v`.

This command will add a vertax whose position is given in the command.

![f_8593.png](http://linfile.xyz/data/vip_data/f_8593.png)

### Edge
```
edge u v w
```
or replace `edge` with `e`.

This command create an edge *(u --w--> v)*

### SetDirected
```
setdirected {true|false}
```
or replace `setdirected` with `sd`

This command tell the renderer whether the graph is directed.

**If no `setdirected` is given, the default value is false**

![f_2526.png](http://linfile.xyz/data/vip_data/f_2526.png)

### ShowGrid
```
showgrid {true|false}
```
or replace `showgrid` with `sg`

This command tell the renderer whether to draw the blocks.
**And the default value is true.**

*Set the value false for depolyment.*

### Example
```
g 3 3
v 0 1 1
v 2 2 2
v 0 2 3
v 1 0 4
e 1 4 1
e 1 3 7
e 1 2 2
e 4 3 5
sd true
sg false
```

![f_7731.png](http://linfile.xyz/data/vip_data/f_7731.png)

Then you can have a snapshot and publish it in your article:)

*The feature of exporting the image will soon be finished.*
