###pomodoro.sh


This script will notify the user when to work and when to rest in intervals as specified at http://en.wikipedia.org/wiki/Pomodoro_Technique.

notifications are sent out via terminal-notifier http://rubygems.org/gems/terminal-notifier on OS X or echo "$1" | wall on Linux (Graphical notifications will be supported in the near future via pynotify2). 


####  Install & Run
<code>
./install
</code>

Start it up in the background....
<code>
sudo pomodoro start &
</code>

Stop it gracefully....
<code>
sudo pomodoro stop
</code>

Or, just run ./pomodoro.sh (stop|start)

#### Block Domains While Working
Create/edit a file called .pomodoro.urls.blacklist in your home folder.  Each of the domains in the file will be blacklisted during each work session.


&gt; cat ~/.pomodoro.urls.blacklist

facebook.com<br/>
news.ycombinator.com<br/>
reddit.com<br/>


