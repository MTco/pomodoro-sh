###pomodoro.sh


This script will notify the user when to work and when to rest in intervals as specified at http://en.wikipedia.org/wiki/Pomodoro_Technique.

notifications are sent out via terminal-notifier http://rubygems.org/gems/terminal-notifier on OS X or the pynotify library on Linux (after support is implemented).

If the user creates a file named .pomodoro.urls.blacklist in their home directory all of the domains in the file will be blacklisted during each work session.

Install it....
<code>
./install
</code>


Start it up....
<code>
sudo pomodoro -start &
</code>

Stop it gracefully....
<code>
sudo pomodoro -stop
</code>
