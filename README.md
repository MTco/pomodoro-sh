###pomodoro.sh


This script will notify the user when to work and when to rest in intervals as specified at http://en.wikipedia.org/wiki/Pomodoro_Technique.

notifications are sent out via terminal-notifier http://rubygems.org/gems/terminal-notifier on OS X or the pynotify library on Linux (after support is implemented).


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

Or, just run ./pomodoro.sh stop|start

#### Block Domains While Working
Create/edit a file called .pomodoro.urls.blacklist in your home folder.  Each of the domains in the file will be blacklisted during each work session.

<code>
>> cat ~/.pomodoro.urls.blacklist
facebook.com
news.ycombinator.com
reddit.com
mail.google.com
voice.google.com
www.facebook.com
www.reddit.com
amazon.com
www.amazon.com
twitter.com
www.twitter.com
</code>
