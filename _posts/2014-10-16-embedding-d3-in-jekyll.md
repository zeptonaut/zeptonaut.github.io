---
layout: post
title: "Embedding D3.js in a Jekyll blog post"
date: 2014-10-16 10:59
categories: coffeescript d3 jekyll
---
If you haven't heard of it, there's a neat little data binding library that the Javascript world is pretty taken with called D3.js. In short, D3.js allows you to cleanly and easily write Javascript that takes actions based on a dataset. You could imagine something like this might be useful when creating a bar graph in Javascript, changing the height of rectangles on the page depending on the datum.

While reading about D3.js, I began wondering how hard it would be to embed it in a Jekyll blog post. Thankfully, it's not very difficult.

The key is that D3.js requires some anchor on the page to target. Jekyll posts are written in Markdown, and Markdown documents allow you to embed raw HTML simply by putting that HTML into its own paragraph.

This means that we can insert the following HTML at the bottom of our page:

{% highlight html %}
<div id="example"></div>
{% endhighlight %}

We can then put this Javascript that uses D3.js at `<jekyll_base_directory>/js/embed-d3.js`. 

{% highlight Javascript %}
(function() {
  window.onload = function() {
    var dataset;
    dataset = [5, 10, 15, 20, 25];
    return d3.select("#example").selectAll("p").data(dataset).enter().append("p").text(function(d) {
      return d;
    });
  };

}).call(this);
{% endhighlight %}

Without getting too much into the details, we're creating five paragraphs within the div with ID `example` and putting the numbers 5, 10, 15, 20, and 25 into those paragraphs.

We can pull in both D3.js and our script by putting this HTML right below the div:

{% highlight html %}
{% raw %}
<script src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.4.12/d3.js"></script>
<script src="{{site.basurl}}/js/embed-d3.js"></script>
{% endraw %}
{% endhighlight %}

This may not be the *optimal* place to place the Javascript includes but it works for now.

Here's the result:

<div id="example" style="background: #eef; font-family: monospace; padding: 10px; margin: 10px 0px;"></div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.4.12/d3.js"></script>
<script src="{{site.baseurl}}/js/embed-d3.js"></script>
