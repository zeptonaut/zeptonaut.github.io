---
layout: post
title: "Org everywhere"
date: 2015-03-27 17:15
categories: emacs
---
In the world of *Getting Things Done*, I've found that Emacs's org mode is second-to-none in terms of low-friction task managers. One thing that David Allen stresses in the book is that even a tiny amount of friction in the tasks that you have to do frequently when staying organized is enough to prevent you from staying organized. At least for me, this is very, very true because I am incredibly, incredibly lazy.

What makes org mode great is that whenever you find yourself issuing a command reguarly that takes a few too many keystrokes, you can write a tiny bit of Elisp to turn that command into a single shortcut. This luxury doesn't exist with non-digital implementations of GTD (it's tough to write Elisp to open a file drawer, put something into the waiting category, and close the file drawer, although Perl may get the job done).

The somewhat nasty thing about org mode, though, is that it's a little tough to get set up on your phone. There are a couple ways to do so, but I've found the easiest to be through [MobileOrg](http://mobileorg.ncogni.to/) and [Dropbox](https://www.dropbox.com/).

MobileOrg is a fairly simple editor for org files on your phone. It has a drop-in connection for Dropbox, so if you store your org files there, you can access them from multiple computers and your phone.

Here are the basic steps in getting this combination set up, assuming that you already have org-mode set up on your computer:

- [Sign up for a Dropbox account.](https://www.dropbox.com/login)
- [Download the Dropbox app for your computer.](https://www.dropbox.com/install) This app makes your Dropbox file system accessible as a normal folder on your computer. You'll want to do this on each computer that you'll be editing org mode files on.
- Create a folder in your Dropbox folder that will store your org files. I use `$HOME/Dropbox/org`.
- Create a folder in your Dropbox folder that will store your org files that have been exported for the mobile app. I use `$HOME/Dropbox/mobileorg`.
- In your `.emacs` file, add the following line to let Emacs know where you want to export your mobile org files to:
  {% highlight elisp %}
  (setq org-mobile-directory "~/Dropbox/mobileorg")
  {% endhighlight %}
- Set your `org-agenda-files` variable to the folder where you're storing your org files. You'll know it's set correctly when you can run `org-iswitchb` to switch between your different org mode files. You can set it by adding the following line to your `.emacs` file:

  {% highlight elisp %}
  (setq org-agenda-files (list "~/Dropbox/org/projects"))
  {% endhighlight %}
- Create a sample org mode file to test that everything's hooked up correctly at `~/Dropbox/org/projects/test.org`. It should read something like:

  {% highlight text %}
  * TODO This task should show up. 
  {% endhighlight %}

- After you've done this, export your new file by running `org-mobile-push`. This basically wraps up all of your changes to org files and packages them to be sent to your mobile device.
- Download the mobile org app on your device. When it asks where to look for your og mode files, choose Dropbox and authenticate with your Dropbox account. When asked what folder to use in your Dropbox file system, choose `mobileorg`.
- You should see your sample task on your phone!

One somewhat nasty thing about this system is that you have to run `org-mobile-push` every time that you want to export your computer's changes to your mobile device, and `org-mobile-pull` every time that you want to import changes made on your mobile device to your computer. I'm still looking for a better system than manually doing this, but for now, I still prefer this to using a less flexible task manager.

Now pardon me - I have to get some things done.
