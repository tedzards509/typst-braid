// Helper to read the input product of sigmas
#let _parse_input(body) = {
  body
    .body
    .children
    .filter(el => (
      repr(el.func()) == "attach" and el.base.text == str(sym.sigma)
    ))
    .fold(
      (),
      (acc, sigma_attach) => { // Basically for each
        if not sigma_attach.has("b") {
          panic("A crossing is missing an index.")
        }
        let index = int(sigma_attach.b.text) - 1
        let left_on_top = true
        let power = if not sigma_attach.has("t") { 1 } else {
          if sigma_attach.t.func() == text {
            int(sigma_attach.t.text)
          } else if sigma_attach.t.children.at(0).text == "−" {
            left_on_top = false
            int(sigma_attach.t.children.at(1).text)
          } else {
            panic("Couldn't parse an exponent")
          }
        }

        for i in range(calc.abs(power)) {
          acc.push((index, left_on_top))
        }
        acc
      },
    )
}

#let braid(
  body,
  strands: 0,
  unit_width: 18pt,
  unit_height: 40pt,
  strand_stroke: stroke(2pt),
  top_strand_padding: 4pt,
  curvature: 0.6,
) = {
  // Helper to draw a single line segment
  let segment(
    height,
    start_index,
    end_index,
    segment_stroke: strand_stroke,
  ) = if ( // If it's a line, only draw a line...
    start_index == end_index
  ) {
    place(
      top + left,
      line(
        stroke: segment_stroke,
        start: (unit_width * start_index, unit_height * height),
        end: (unit_width * start_index, unit_height * (height + 1)),
      ),
    )
  } else { // ... otherwise cubic bezier curve
    place(
      top + left,
      curve(
        stroke: segment_stroke,
        curve.move((unit_width * start_index, unit_height * height)), // start point
        curve.cubic(
          (unit_width * start_index, unit_height * (height + curvature)), // start point handle -- curvature * unit_height below start point
          (unit_width * end_index, unit_height * (height + 1 - curvature)), // end point handle -- curvature * unit_height above end point
          (unit_width * end_index, unit_height * (height + 1)), // end point
        ),
      ),
    )
  }

  // Parse input to list of tuples: (index: int, right_on_top: bool)
  let crossings = _parse_input(body)


  // Actually drawing the braid
  box(
    width: (strands + 2) * unit_width,
    height: crossings.len() * unit_height,

    for (idx, (index, left_on_top)) in crossings.enumerate() {
      // Draw irrelevant lines
      for i in range(strands) {
        if i != index and i != index + 1 {
          segment(idx, i, i)
        }
      }

      // draw crossing (First bottom one, then wide white stroke top, then black stroke top)
      if left_on_top {
        segment(idx, index + 1, index)
        segment(
          idx,
          index,
          index + 1,
          segment_stroke: strand_stroke.thickness + top_strand_padding + white,
        )
        segment(idx, index, index + 1)
      } else {
        segment(idx, index, index + 1)
        segment(
          idx,
          index + 1,
          index,
          segment_stroke: strand_stroke.thickness + top_strand_padding + white,
        )
        segment(idx, index + 1, index)
      }
    },
  )
}
