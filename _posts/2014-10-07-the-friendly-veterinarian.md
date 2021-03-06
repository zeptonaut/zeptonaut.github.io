---
layout: post
title: "Friendly Veterinarian: a simple emacs package"
date: 2014-10-07 10:19
categories: emacs elisp
---
Emacs is a fantastic editor. The flexibility offered by the plugin architecture makes its potential almost limitless.

Or... so I've been told. I say all this never having actually *developed* an emacs package. I'm changing that today. And I've limited the scope of my first plugin to reflect the fact that my attention span is limited to about 30 seconds.

I think this plugin we're making has real potential to take off: I call it the friendly veterinarian. It asks you the name of your favorite animal and prints a message based on your response.

I started off by using the command line to create a directory where I could store these types of projects:

{% highlight bash %}
mkdir ~/.emacs.d/playground
{% endhighlight %}

Now we can go ahead and create the actual package.
 
{% highlight elisp %}
;; ~/.emacs.d/playground/friendly-veterinarian.el

;; Found by googling for "ask for user input emacs"
(defun query-favorite-animal (name)
  "Queries the user for their favorite animal."
  (interactive "sEnter the name of your favorite animal: ")
  (message "Your favorite animal is: %s. I guess those are alright." name))

;; This allows people to use (require 'friendly-veterinarian) in their .emacs
(provide 'friendly-veterinarian)
{% endhighlight %}

After evaluating the buffer (another way of saying loading the code) with `M-x eval-buffer`, we can now  call our function with `M-x query-favorite-animal` and get asked what our favorite animal is.

![query-favorite-animal]({{ site.baseurl }}/assets/query-favorite-animal.gif)

Alright - I think I can do a *little* better than that today. What about if we gave ourselves some neat options for autcomplete?

The first result of googling for "interactive function autocomplete emacs" lets us know that we can pass a different parameter to `interactive` to give ourselves some autocomplete options. Great!

Using our new-found knowledge, we can add a bit to the file:

{% highlight elisp %}
;; ~/.emacs.d/playground/friendly-veterinarian.el
;; (defun query-favorite-animal...

(defun query-favorite-animal-autocomplete (name)
  "Queries the user for their favorite animal with autocomplete."
  (interactive
   (list
    (completing-read "sEnter the name of your favorite animals: "
                     '("cat" "dog" "giraffe"))))
  (message "Your favorite animal is: %s. I guess those are alright." name))

(provide 'friendly-veterinarian)
{% endhighlight %}

Now we can reload our package by revaluating the buffer (remember `M-x eval-buffer`?) and call our function with `M-x query-favorite-animal-autocomplete`. Looks good!

![query-favorite-animal]({{ site.baseurl }}/assets/query-favorite-animal-autocomplete.gif)

Very humble goal: accomplished.
