---
layout: post
title: "The beauty of numpy"
date: 2015-02-04 10:56
categories: python
---
I've been beefing up on my algorithms lately by trying to finish a programming competition problem a day. And, just for kicks and practice, I've been doing these problems in python.

I *really* like python so far. It's quick and dirty and great. The problem though, is that some of the expressiveness that makes it great costs speed. Loads of it. The problem I was working on necessitated working with fairly large data sets, and my program that needed to run in less than two seconds was instead taking 15-20s.

I tried profiling my program with cProfile, and it told me that *everything* was slow.

So I did what any programmer worth squat does: I looked online for an answer. The interwebs seemed to suggest that writing efficient python requires learning *[numpy](www.numpy.org)*, a python library that provides efficient ways to work with numbers and matrices. Despite my resistance to learning a new library, I decided that it was worth a try.

In an effort to do as little work as possible, I decided to start by converting only a small portion of my program to use numpy. Here's the portion of my program that reads the input, sans numpy:

{% highlight python %}
def main():
    while True:
        m, n = map(int, raw_input().split())

        if m == n == 0:
            break

        live_cells_count = int(raw_input())

        live_cells_unpaired = []
        while len(live_cells_unpaired) < (live_cells_count * 2):
            live_cells_unpaired.extend(map(int, raw_input().split()))

        live_cells = [live_cells_unpaired[i:i+2] for i in range(0, len(live_cells_unpaired), 2)]
        generations = int(raw_input())

        # In form grid[ring][cell]
        grid = [[([i, j] in live_cells) for j in range(n)] for i in range(m)]
{% endhighlight %}

And here's the same portion with numpy:

{% highlight python %}
def main():
    while True:
        m, n = map(int, raw_input().split())

        if m == n == 0:
            break

        live_cells_count = int(raw_input())
        live_cells_unpaired = []
        while len(live_cells_unpaired) < (live_cells_count * 2):
            live_cells_unpaired.extend(map(int, raw_input().split()))

        live_cells = [live_cells_unpaired[i:i+2] for i in range(0, len(live_cells_unpaired), 2)]
        grid = np.zeros((m, n), bool)

        for live_cell in live_cells:
            grid[live_cell[0], live_cell[1]] = True

        generations = int(raw_input())
{% endhighlight %}

They look almost identical. The difference? Without numpy, the input takes some 8 seconds to read in. With numpy, it takes .2s.

Sold.
