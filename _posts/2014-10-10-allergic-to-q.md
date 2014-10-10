---
layout: post
title: "Allergic to Q"
date: 2014-10-10 12:14
categories: emacs elisp flycheck
---
[Flycheck](https://github.com/flycheck/flycheck) is a fantastic little emacs plugin that aims to help you find basic errors that can be found through static analysis. On its surface - yes, *I know* -this sounds incredibly boring. In practice, though, it's often the most boring jobs that I *want* a computer to help with, in order to help conserve my precious little sanity.

You're probably already familiar with what this looks like in practice. You know how in Microsoft Word and Google Docs, when you spell a word wrong, there's a little red squiggly underneath the word? Think of flycheck as a customizable way to make those squigglies.

Today, I wanted to learn how to make an incredibly simple syntax checker. Well, really I started yesterday, but this "incredibly simple" checker actually took me two days to build because I'm an idiot. Typical.

This syntax checker will... (prepare yourself)... mark an error on any line with the letter 'q'. Let's get started.

First, get a copy of flycheck. You can do this using `package.el`, which is included in Emacs 24. `M-x package-install <ENTER> flycheck` should do the trick. If flycheck isn't an available package, [make sure that you have the correct repositories set up](http://www.emacswiki.org/emacs/ELPA). Once you've done that, make sure that you require flycheck in your .emacs file by adding the following:

{% highlight elisp %}
(require 'flycheck)
{% endhighlight %}

Now that that's taken care of, let's figure out how a checker works in flycheck. Whenever I don't have any clue what I'm doing (usually), I look for the simplest example that I can find. Luckily, flycheck is open source and has lots of checkers already defined, so we can just take a look at the [main flycheck file in the github respository](https://github.com/flycheck/flycheck/blob/master/flycheck.el#L6327). `yaml-jsyaml` looks like a simple enough checker:

{% highlight elisp %}
(flycheck-define-checker yaml-jsyaml
  "A YAML syntax checker using JS-YAML.

See URL `https://github.com/nodeca/js-yaml'."
  :command ("js-yaml" source)
  :error-patterns
  ((error line-start
          "JS-YAML: " (message) " at line " line ", column " column ":"
          line-end))
  :modes yaml-mode)
{% endhighlight %}

Let's take this line by line:

{% highlight elisp %}
(flycheck-define-checker yaml-jsyaml
{% endhighlight %}

This looks like it's just a macro that creates the checker.

{% highlight elisp %}
  :command ("js-yaml" source)
{% endhighlight %}

This looks like it's telling flycheck the command to run to generate the list of errors. I'm assuming that js-yaml accepts a filename as its input, so `source` is probably just the name of the file being checked.

{% highlight elisp %}
:error-patterns
  ((error line-start
          "JS-YAML: " (message) " at line " line ", column " column ":"
          line-end))
{% endhighlight %}

This looks like it's telling flycheck what a line of output text looks like. It looks like the error text is in the form:

    JS-YAML: This is an error message at line 43, column 2:

And lastly:

{% highlight elisp %}
:modes yaml-mode)
{% endhighlight %}

Looks like it's just telling flycheck what modes this checker is available in.

Great! Equipped with our new-found inkling of what to do, let's try and write our own checker. This looks like a good framework:

{% highlight elisp %}
;; ~/.emacs.d/playground/flycheck-error-on-q.el

(flycheck-define-checker error-on-q
  "A syntax checker that errors on any line with a q."

  :command ("TODO: Write the command")
  :error-patterns
  ;; Example error: 43:This line is bad
  ((error line-start line ":" (message) line-end))
  :modes text-mode)

(provide 'flycheck-error-on-q)
{% endhighlight %}

So now we just need to use our command-line-fu to write a one-liner that finds instances of the letter Q. To the terminal!

First, it's probably a decent idea to think of a file that has some Q's in it. In my case, I know that my Emacs initialization file has lots of them - it uses `package.el`'s `require` function a lot.

`grep` is good at finding things and, with a bit of fooling around, I found that:

{% highlight bash %}
grep --color=never -n -i "q" $FILENAME
{% endhighlight %}

finds the line with Q's in them. This command makes sure:

* `--color=never`: We don't colorize the output of `grep`. This ensures that we don't insert any control characters into our output that might mess up the error parsing in our checker.
* `-n`: We print the line number so that our checker knows which line to mark as erroneous.
* `-i`: We accept both upper and lower case q's

Running this on my .emacs file with `grep --color=never -n -i "q" ~/.emacs`, I get

    2:;; Required here because this is what allows requiring of other packages.
    3:(require 'package)
    4:(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
    ...
    292:(require 'flycheck-error-on-q)
    293:(add-to-list 'flycheck-checkers 'error-on-q)

Looks like a good start. Notice, though, that our checker expects a message after the colon, while `grep` just prints the matching string. We can fix this with a bit of `awk`:

{% highlight bash %}
grep --color=never -n -i "q" $FILENAME | awk -F ":" '{print $1":Ick! Q! I hate that letter!"}'
{% endhighlight %}

Now, instead of `2:;; Required here because this is what allows requiring of other packages.`, we get `2:Ick! Q! I hate that letter!`.

Unfortunately, after trying, I realized that we can't just put this incantation as our flycheck `:command` for two reasons:

* Flycheck expects the return value of the command that's run to be 1 if an error exists and 0 if it does not. For our command, it'll always return 0 because awk is always successful.
* Flycheck automatically quotes all parameters after the first one, so it'd automatically quote `awk` as well as the pipe that follows it. We don't want these evaluated as strings - we want them evaluated as regular old operations.

Fortunately, all of these problems can be avoided by writing a thin wrapper of a bash script around our existing command. This bash script looks something like:

{% highlight bash %}
#!/bin/bash
# ~/.emacs.d/playground/error-on-q

# Capture the first argument and put it into $FILE
FILE=$1

# Capture the output of grep and put it into $MATCHES
# Parameters:
# --color=never  Don't colorize the output - we want plain text
# -n             Print the line number of the match
# -i             We don't care about the case of the letter
# "q"            Our search string - the letter 'q'
# $FILE          The file to search
MATCHES=$(grep --color=never -i -n "q" $FILE)

# Capture the output status of grep so we know if we found any q's
GREP_EXIT_STATUS=$?

if [ $GREP_EXIT_STATUS -eq 0 ]; then
  # Print output in the form file:line_no:Ick! Q! I hate that letter!
  echo "$MATCHES" | awk -F ":" '{print $1":Ick! Q! I hate that letter!"}'

  # If we found a 'q', return 1 to indicate there was a problem
  # with the file
  exit 1;
else
  # Otherwise, return 0
  exit 0;
fi
{% endhighlight %}

It's long, but if you look at what it's actually doing, it's pretty simple. It's running the commands that we already talked about with one modification: it's capturing the exit value of `grep` and inverting it. That is, if `grep` returns 0, it returns 1, and vice versa. This is because we have an error when we find a Q, whereas grep returns 1 unless a match is found. `grep`'s error is our success.

I put this file at `~/.emacs.d/playground/error-on-q` and made sure it was executable with `chmod 755 ~/.emacs.d/playground/error-on-q`.

Now, we can use this script in our `:command` in our checker:

{% highlight elisp %}
;; ~/.emacs.d/playground/flycheck-error-on-q.el

(flycheck-define-checker error-on-q
  "A syntax checker that always says that line 1 has an error."

  :command ("~/.emacs.d/playground/error-on-q" source)
  :error-patterns
  ((error line-start line ":" (message) line-end))
  :modes text-mode)

(provide 'flycheck-error-on-q)
{% endhighlight %}

If we reevaluate the buffer and go back to our text buffer, we should see something like:

![error-on-q]({{ site.baseurl }}/assets/error-on-q.gif)

Success!
