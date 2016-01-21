---
layout: post
title: "Chrome Tracing Episode 1: Starting anywhere"
date: 2016-01-21 14:54
categories: chrome
---
I've been working on trace viewer for a good while now, and most of the time I've been enduring a deep sense of guilt that I don't actually *use* the thing more.

So here it goes: I'm going to try my best to spend an hour every day or two using trace viewer to dig into how Chrome works, and write up the results here.

Given that I have no real idea where to start, I just picked a random site: [my Github profile](https://github.com/zeptonaut).

I'll be doing all of the tracing in Chrome Canary, just to make sure I have the freshest features available.

Also, just because I know that plugins can have a performance impact that I don't care to learn more about at the current moment, I'm going to make sure that I do all of my tracing from incognito mode, and with only a single browsing tab open for now (with a second tab open for tracing purposes).

So here it goes.

I started out by navigating to chrome://tracing and clicked the "Record" button. I then selected the "Rendering" settings (I didn't think I could manually pick any better ones), and clicked "Record". I opened a new tab and went to the page (https://github.com/zeptonaut), went back to my tracing tab, and clicked "Stop". Now comes time for investigation.

This is what I'm greeted with:

![Initial page load]({{ site.baseurl }}/assets/2016-1-21/initial_page_load.png)

In the trace, it looks like a flurry of activity happens right after 6 seconds: I'm going to guess that's when I actually started loading the Github page.

Zooming in on the "NetLog" track (option+cmd+scroll), it looks like this suspicion is confirmed. Right around 6.3s, you can see:

![Netlog]({{ site.baseurl }}/assets/2016-1-21/netlog.png)

(P.S. Wow! You need good eyesight to see that little Netlog bar. We should fix that.)

Scrolling down a bunch of tracks to the Github page renderer, it looks like the real work starts about 20-30ms earlier:

![Real work]({{ site.baseurl }}/assets/2016-1-21/real_work.png)

That first blue little slice is titled `ChannelReader::DispatchInputData`. I'm guessing that's important, because it looks like that's the first thing that happens. Well, what the heck is a `ChannelReader`, and what does it mean to `DispatchInputData`?

[Looking up ChannelReader on code search](https://code.google.com/p/chromium/codesearch#chromium/src/ipc/ipc_channel_reader.h&l=35&ct=xref_jump_to_def&cl=GROK&gsn=ChannelReader) seems to show that `ChannelReader` is just a way to read pipes between processes. It looks like it has something to do with IPCs (inter-process calls). Maybe that's not what we were after.

After that is `MessageLoop::RunTask`. I know that the `MessageLoop` is just the main loop that runs on each thread that constantly checks for and executes new tasks. That's not what I want, either: I really want the first *interesting* piece of work that has to do with me navigating.

Well... I give up for today. Maybe I'll have better luck tomorrow finding something.
