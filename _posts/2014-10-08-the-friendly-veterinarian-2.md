---
layout: post
title: "Sending our Friendly Veterinarian back to school"
date: 2014-10-08 10:33
categories: emacs elisp
---
Yesterday we walked through how to write an extremely simple emacs plugin, [Friendly Veterinarian]({% post_url 2014-10-07-the-friendly-veterinarian %}). Today I want to see if we can expand the knowledge base of our friendly veterinarian a bit by having the plugin read the autocompletion options from a text file of animals rather than having to manually list them in elisp.

I found [this animal list](https://raw.githubusercontent.com/hzlzh/Domain-Name-List/master/Animal-words.txt) on github which looks like a good list to use as an autocompletion source. We can download this file to our plugin directory with a `curl` one-liner:

{% highlight bash %}
curl -0 https://raw.githubusercontent.com/hzlzh/Domain-Name-List/master/Animal-words.txt \
  > ~/.emacs.d/playground/animals.txt
{% endhighlight %}

Perfect! Now we just have to parse the file when we call our autocomplete function. Googling for `elisp read from file` gives us an answer on how to do that.

{% highlight elisp %}
;; ~/.emacs.d/playground/friendly-veterinarian.el
;; (defun query-favorite-animal...
;; (defun query-favorite-animal-autocomplete...

(defun get-lines-from-file (file-path)
  "Returns the lines of the file at file-path."
  ;; Insert the contents of the file into a temporary buffer
  (with-temp-buffer
    (insert-file-contents file-path)
    ;; Split the contents of the current buffer on the new line
    (split-string (buffer-string) "\n" t)))
    
(provide 'friendly-veterinarian)
{% endhighlight %}

It'd be nice to have an easy way of making sure this code works without having to use the rest of the plugin. Enter iELM (inferior Emacs Lisp Mode). iELM is what's known in the lisp world as a REPL, which stands for Read Evaluate Print Loop. It's essentially a program that reads a line of code that you write, evaluates it, and gives you back the result. This is exactly what we need - some way to test that `get-lines-from-file` works.

To do this, load up iELM with `M-x ielm` and evaluate the code in `friendly-veterinarian.el` using `M-x eval-buffer`. Evaluating the code makes that code available to be executed in the REPL. Once you've done this, execute this line in the iELM REPL:

{% highlight elisp %}
ELISP > (get-lines-from-file "~/.emacs.d/playground/animals.txt")
("Aardvark" "Albatross" "Alligator" ... "Zebra")
{% endhighlight %}

Wunderbar! We can now swap out our puny autocomplete list that we were using in `query-favorite-animal-autocomplete` with the much more complete list from our text file.

{% highlight elisp %}

;; ~/.emacs.d/playground/friendly-veterinarian.el
;; (defun query-favorite-animal...

(defun query-favorite-animal-autocomplete (name)
  "Queries the user for their favorite animal with autocomplete."
  (interactive
   (list
    (completing-read "sEnter the name of your favorite animals: "
                     (get-lines-from-file "~/.emacs.d/playground/animals.txt"))))
  (message "Your favorite animal is: %s. I guess those are alright." name))

;; (defun get-lines-from-file...
(provide 'friendly-veterinarian)
{% endhighlight %}

After reevaluating our buffer and calling our function with `M-x query-favorite-animal-autocomplete`, we're greeted with something like this:

![query-favorite-animal-autocomplete-file]({{ site.baseurl }}/assets/query-favorite-animal-autocomplete-file.gif)

Now we have a friendly *and smart* veterinarian.
