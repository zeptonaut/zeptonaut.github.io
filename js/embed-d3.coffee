window.onload = ->
        dataset = [5, 10, 15, 20, 25]
        d3.select("#example").selectAll("p")
                .data(dataset)
                .enter()
                .append("p")
                .text((d) -> d)

