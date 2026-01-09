# typst-braid
Braid Group Visualization in Typst.

There are a number of configuration parameters available, their default values and concise explanations are given below.

```
strands: 0                  // number of strands in the group
unit_width: 18pt            // width separating each strand
unit_height: 40pt           // height of an individual crossing
strand_stroke: stroke(2pt), // stroke of the strands (can be colorized through for ex. 2pt + blue)
top_strand_padding: 4pt,    // thickness of white padding to add around the strand crossing over
curvature: 0.6,             // allowed values between 0 and 1, higher values are more curvy
```

Examples:
```typ
#braid(strands: 3)[$sigma_1 sigma_2^(-1) sigma_1 sigma_2^(-1)$]
#braid(strands: 2)[$sigma_1 sigma_1^(-1)$]
```
