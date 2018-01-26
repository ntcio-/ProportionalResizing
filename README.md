# Proportional Resizing using Auto Layout

This project is an illustration of a method to resize the content of your app
proportionately to each screen size it runs on. It is provided as a collection of functions packaged
under a UIView category.

The main steps of the algorithm proposed are:

Start with a single design on a specific device referred to as the prototype, and for every screen:

- Calculate at runtime, the horizontal and vertical size ratio of the prototype to the current device
- Collect all views recursively
- Leave out any types of views you wish to exclude from the general adaptation algorithm
- Collect all constraints of each view
- Multiply horizontal and vertical constraint values with the respective ratio
- Deal with special cases of views (e.g. UIImageView, UITableView) separately
- Multiply the size of fonts with a factor derived from either the horizontal or vertical ratio 

The code can be used as is, but most probably you would have to modified it to suit your specific needs.
Suggestions and enhancements are welcome and encouraged.
