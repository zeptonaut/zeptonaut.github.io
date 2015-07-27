---
layout: post
title: "Sharing work between computers with Git"
date: 2015-07-27 15:18
categories: git
---
Since I've started working more on [Trace Viewer](https://github.com/google/trace-viewer/), there have been plenty of times when I've wanted to share work on a feature branch between my desktop and laptop before sending that work out to the world for code review. 

I originally did this by pushing my feature branch to the project's public Git repo from one computer and fetching that branch from the other computer.

{% highlight bash %}
# On my desktop, after making commits...
git push origin my_feature_branch

# Later, on my laptop...
git fetch origin
git checkout my_feature_branch
{% endhighlight %}

This is problematic, though, if the project you're working on doesn't like your ugly work-in-progress branches polluting its public repo.

The solution is to do this same push-fetch dance with a fork of the main repo instead of the main repo itself.

At a high level, here are the steps:

  1. Create the fork. In Github, you go to the project's page and click the "fork" button.
  2. Add the fork as a remote repo on your desktop's repo.
  3. Add the fork as a remote repo on your laptop's repo.

In practice, it looks like this:

{% highlight bash %}
# 1) Create the fork.

# 2) Add the fork as a remote repo on your desktop's repo.
#    Inside the my-repo project on your desktop...
git remote add fork <your_fork_url>

# 3) Add the fork as a remote repo on your laptop's repo.
#    Inside the my-repo project on your laptop...
git remote add fork <your_fork_url>
{% endhighlight %}

Replace `<your_fork_url>` with the SSH clone URL found on your fork's Github project page.

Now you can do things like:

{% highlight bash %}
# In my-repo on your desktop...
git checkout -b add_readme
echo "This project loves Git!" >> README.md
git commit -am "Adds to the README."

git push fork add_readme

# In my-repo on your laptop...
git fetch fork
git checkout add_readme
cat README.md
# ...
# This project loves Git!
{% endhighlight %}

You can do the same thing in the opposite direction, too.

Pretty nifty!
