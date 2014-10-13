---
layout: post
title: "Remedying a defect in spaceballs-mode"
date: 2014-10-12 23:11
categories: emacs elisp
---
I think that we can all agree that [spaceballs-mode]({% post_url 2014-10-11-the-missing-emacs-mode-spaceballs-mode %}) turned out *pretty* damn well. There's at least one glaring flaw in it, though.

Remember when we made `insert-random-spaceballs-quote` an interactive function so that we could bind it to a key? Declaring that a function is `interactive` is a little bit like signing a contract - you're expected to play nice with certain features of Emacs if it makes sense for your function to do so. Specifically in our case, it makes perfect sense for our function to accept what's known as a *prefix argument*.

A prefix argument can be passed to a function by pressing `C-u`, entering a number, and then calling the function. Functions that accept prefixes promise to do something sensible with the number that's passed to them.

As an easy example, let's take a look at the function `previous-line`, usually bound to `C-p`. Calling it once with `C-p` moves back to the previous line. Using `C-u 10 C-p` to pass it a prefix argument of 10 moves back 10 lines instead.

Following this logic, it makes sense for `insert-random-spaceballs-quote` to insert *ten* random spaceballs quotes when called with a prefix argument of 10.

How do we do get our function to accept a prefix, you ask? It's pretty darn easy. Rather than calling `(interactive)` in that function, we just call `(interactive "p")`. Then we mark our function as accepting that argument.

Like this:

{% highlight elisp %}
(defun insert-random-spaceballs-quote (arg)
  (interactive "p")
  ...
{% endhighlight %}

That argument is set to `nil` when no prefix argument is passed to the function; otherwise, it's set to the prefix argument. This means that we want to execute `insert-random-spaceballs-quote` `arg` times if `arg` is set; otherwise we execute it once. Something like this:

{% highlight elisp %}
(defun insert-random-spaceballs-quote (arg)
  (interactive "p")
  (dotimes (num (or arg 1))
    (insert (get-random-element spaceballs-lines) "\n")))
{% endhighlight %}

Now we can rest peacefully knowing that the `interactive` contract was fulfilled.
