---
layout: post
title: "Testing R markdown in posts"
date: 2016-4-22 10:19
categories: r
output: html_document
---



I've recently spent some time on the [Kaggle Titanic machine learning problem](https://www.kaggle.com/c/titanic/) and thought it might be fun to write about different approaches I'm taking to the problem. For me. It'll be awful for you. But hey, you're reading this in the first place, so masochism's clearly your thing.

In order to make this easier, I wanted to figure out how to embed R markdown posts in a Jekyll blog. It turns out that R's `servr` and `knitr` packages make this *incredibly* easy to do.

Check out this fun example plot, generated with:


```r
plot(pressure)
```

![plot of chunk pressure](/figure/source/2016-4-22-testing-r-markdown/pressure-1.png)

Well, I'm tickled.
