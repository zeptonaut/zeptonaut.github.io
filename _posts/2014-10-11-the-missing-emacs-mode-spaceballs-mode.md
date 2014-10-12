---
layout: post
title: "The missing Emacs mode: spaceballs-mode"
date: 2014-10-11 18:08
categories: emacs elisp
---
For *years* I've been urging the Emacs community to create a major mode dedicated to the movie *Spaceballs* but, alas, I must be communicating my vision poorly.

Eager to bring this idea to fruition, I've decided to teach myself the basics of writing a major mode. Specifically, I'll be creating a mode that inserts a random *Spaceballs* quote every time the user hits `ENTER`.

I wrote the skeleton for this new mode based on [this Sample Mode tutorial](http://www.emacswiki.org/emacs/SampleMode). It looks something like this:

{% highlight elisp %}
;; ~/.emacs.d/playground/spaceballs-mode.el

(defvar spaceballs-mode-hook nil
  "Hooks to be run when entering spaceballs-mode.")
(defvar spaceballs-mode-map
  (let ((map (make-keymap))) map)
  "Keymap for spaceballs-mode")

(define-derived-mode
  ;; Name of the mode
  spaceballs-mode
  ;; Name of the mode that we're derived from
  fundamental-mode
  ;; How we appear in the mode line
  "spaceballs"
  "Major mode for generating random Spaceballs quotes.")

(provide 'spaceballs-mode)
{% endhighlight %}

The only part that's not self-explanatory is `spaceballs-mode-hook`. This variable gives users a place to add their own hooks. These hooks allow a user to tell Emacs to perform certain actions (e.g. enable `flycheck-mode`) when `spaceballs-mode` is loaded.

Check that you're able to load up our mode by going to a new buffer (`C-x b *spaceballs*`) and loading up our mode with `M-x load-library spaceballs-mode`. Emacs should allow you to enter this mode, although it's not too exciting at the moment.

So now we've done the easy stuff: let's move on to the more interesting parts. Adding the keybinding to insert the quote seems like a good next step. We can do this by using `define-key` in conjunction with our existing `map` variable which stores our mode's keymap. That looks like this:

{% highlight elisp %}
(defvar spaceballs-mode-map
  (let ((map (make-keymap)))
    (define-key map (kbd "RET") '(lambda ()
                                   (interactive)
                                   (insert "Spaceballs quote goes here.\n")))
    map)
  "Keymap for spaceballs-mode")
{% endhighlight %}

There are two parts that might be confusing here:

* `insert` just inserts whatever argument you pass it into the active buffer.
* More interestingly, `interactive` tells Emacs to make the function available to the user. You can't map things to keys unless they're marked as `interactive`.

Reload the mode with `M-x unload-feature spaceballs-mode` followed by `M-x load-library spaceballs-mode`. You'll have to reenable the mode within `*spaceballs*` as well. Once you do this, though, you should find that mashing `ENTER` results in something like this:

![spaceballs-quote-goes-here]({{ site.baseurl }}/assets/spaceballs-quote-goes-here.gif)

Great! We're getting closer. Now we just have to work on the actual random quote part. We can start by creating a text file containing the quote list at `~/.emacs.d/playground/spaceballs-quotes.txt`:

{% highlight text %}
That's all we needed, a Drewish princess.
What? You went over my helmet?
They've gone to plaid.
We ain't found shit.
That's amazing. I've got the same combination on my luggage.
You have the ring, and I see your Schwartz is as big as mine.
That's what I ordered. Change my order to the soup.
{% endhighlight %}

We can load that text file as a list of lines using the same technique that we used to read the list of animals in [Friendly Veterinarian]({% post_url 2014-10-08-the-friendly-veterinarian-2 %}). To do so, add this at the top of `spaceballs-mode.el`:

{% highlight elisp %}
(defun get-lines-from-file (file-path)
  "Returns the lines of the file at file-path as a list."
  (with-temp-buffer
    (insert-file-contents file-path)
    (split-string (buffer-string) "\n" t)))

(defvar spaceballs-lines
  (get-lines-from-file "~/.emacs.d/playground/spaceballs-quotes.txt"))
{% endhighlight %}

After reevaluating our mode with `M-x eval-buffer`, test that `spaceball-lines` was populated correctly by inspecting its value (`M-: spaceballs-lines`).

Now that we have this list, we can create a new function that gets a random element from it:

{% highlight elisp %}
(defun get-random-element (lst)
  "Returns a random element of a list."
  (elt lst (random (length lst))))
{% endhighlight %}

This function:

* Generates a random number between 0 and the length of `lst`
* Accesses the element of `lst` at the index of that random number

Not bad at all. With our newly-minted `get-random-element` function, we can now create a function that inserts a random *Spaceballs* quote.

{% highlight elisp %}
(defun insert-random-spaceballs-quote ()
  (interactive)
  (insert (get-random-element spaceballs-lines) "\n"))
{% endhighlight %}

As a review, here's what our whole file looks like:

{% highlight elisp %}
;; ~/.emacs.d/playground/spaceballs-mode.el

(defun get-lines-from-file (file-path)
  "Returns the lines of the file at file-path as a list."
  (with-temp-buffer
    (insert-file-contents file-path)
    (split-string (buffer-string) "\n" t)))

(defun get-random-element (lst)
  "Returns a random element of a list."
  (elt lst (random (length lst))))

(defvar spaceballs-mode-hook nil
  "Hooks to be run when entering spaceballs-mode.")
(defvar spaceballs-mode-map
  (let ((map (make-keymap)))
    (define-key map (kbd "RET") 'insert-random-spaceballs-quote)
    map)
  "Keymap for spaceballs-mode")
(defvar spaceballs-lines
  (get-lines-from-file "~/.emacs.d/playground/spaceballs-quotes.txt"))

(defun insert-random-spaceballs-quote ()
  (interactive)
  (insert (get-random-element spaceballs-lines) "\n"))

(define-derived-mode spaceballs-mode fundamental-mode "spaceballs"
  "Major mode for generating random Spaceballs quotes.")

(provide 'spaceballs-mode)
{% endhighlight %}

That should be it! Reload the mode and your `*spaceballs*` buffer and make sure that everything's working alright. You should be seeing something like this when you hit `ENTER`:

![spaceballs-random-quotes]({{ site.baseurl }}/assets/spaceballs-random-quotes.gif)

Congratulations! Together, we've made the greatest contribution to the Emacs community since `M-x butterfly`. We can each now say, ["Look upon my works, ye Mighty, and despair!"](http://www.poets.org/poetsorg/poem/ozymandias). Or... something.

