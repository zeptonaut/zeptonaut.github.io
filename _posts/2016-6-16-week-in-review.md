---
layout: post
title: "June 6, 2016: Last week in review"
date: 2016-06-06 10:37
categories: work journal
---
Last week was a mixed bag in terms of productivity.

It was a four day week, so one work day was nixed from the start. Tuesday through Thursday, I tried to spend a big chunk of my time working on [the migration of trace viewer to Polymer 1.0](https://github.com/catapult-project/catapult/issues/2285). I did this with the idea that, with so many high-priority tasks on my plate, it would be great to get a time-sensitive one knocked out so that I could focus on the others.

The highlight of this effort was the submission of [my patch refactoring the ugly analysis tab view](https://codereview.chromium.org/2023283002/) in trace viewer. The end result confirmed my suspicion that there was a much more succinct way to write such a tabbed view using Polymer correctly. The end result: a working analysis tab view in 549 fewer lines of code.

Overall though, this push to quickly finish the Polymer migration didn’t pay off. The other tasks turned out to be more time-sensitive than I expected, which meant that people were constantly interrupting my work on the Polymer migration to remind me about other tasks. The migration also took more time than I expected, which led to me having the same number of tasks by Friday but with slightly more irritated coworkers because I seemed to be ignoring the task that *they* cared about.

I think that there are a few things that I could have done to better mitigate the effects of having too much on my plate:


- When there are high-priority tasks pending, I should be better about communicating *what* I’m working on along with *why* I’m working on that particular task. If I can’t provide rationale, then maybe I shouldn’t be working on it.
- I should have been more rigorous with applying my 50m work / 10m break modified Pomodoro schedule to my work. Instead, there were was a lot of time when I was sorta working on one thing, sorta working on another, which resulted in two tasks with slow progress instead of one with lots of progress.
- I just need to spend more time working. Earlier in the year, I reduced my working time to 25 work chunks per week and gradually increased it to 30 so that I could ensure that my brain was adequately trained to work for 30 chunks in a 40 hour work week. This worked well for a few weeks but fell by the wayside afterwards. The weeks when I was using this strategy were some of my happiest and most productive weeks of the year: I need to get back in this rhythm.

Thankfully, by Friday, I gave up my hope of getting the Polymer migration finished this week and refocused my attention on fixing [`catapult#2341`](https://github.com/catapult-project/catapult/issues/2341), which was preventing us from writing meaningful Telemetry power tests using the BattOr.  After lots of digging and some help from Oystein, I was able to figure out what needed to be fixed and Oystein has a [patch out for review now](https://codereview.chromium.org/2040663002/) that fixes the issue.

Overall, it was a strong finish to a mediocre week, but I’m optimistic that I can apply the lessons from this week to ensure that I’m effective next week.
