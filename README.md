<p align="center">
  <img src="https://repository-images.githubusercontent.com/669297706/38e5a0ec-8178-4f72-8f71-60a4a0cebe5e" width="300px" height="300px"/>
</p>
<h1 align="center">Automated Setup and Debloat Script</h1>

A personal automated group of powershell scripts to download and install packages, disable services and debloat a new Windows 11 installation.
<br></br>
<h2 align="left">Description</h2>

I wanted a small, minimal set of scripts to setup a new Windows 11 installation that is 'hands free'. The purpose is to enable a few features and tweaks, download and install the latest software using Chocolatey as well the capability to update them in as quickly as possible with little to no input from the user. I listed a few authors' work below that I viewed to learn so all rights goes to them. Please note if you are going to use this script, I don't take any responsibility if something breaks and you are prepared to use this at your own risk! It is always good practice to view the source, to better understand what the script does. More notes and descriptions will be added in due time. More details about AutoWinScript can be viewed <a href="https://www.michaelkeates.co.uk/posts/winautoscripts">here</a>.

<h3 align="left">Features</h3>
<ul>
<li>Enable Remote Desktop automatically.</li>
<li>Download, install and update Chocolatey along with packages defined from a config file.</li>
<li>Disable or changes the start type for services defined from a config file.</li>
<li>Enable options such as 'Show File Extensions' among others automatically as well as disabling telemetry from a config file.</li>
<li>Set the Windows Update feature to download updates after a year and security updates after 4 days from release.</li>
<li>Remove bloatware apps</li>
</ul>
<h2 align="left">Getting Started</h2>
<h3 align="left">Installation</h3>
<ul>
<li>Simply open PowerShell as Administrator and run the following commands. Run the commands again to simply update packages if available</li>
<pre class="gitcode">Set-ExecutionPolicy RemoteSigned</pre>
<pre class="gitcode">$ScriptFromGitHub = Invoke-WebRequest https://raw.githubusercontent.com/michaelkeates/AutoWinScripts/main/run.ps1</pre>
<pre class="gitcode">Invoke-Expression $($ScriptFromGitHub.Content)</pre>
</ul>

<h3 align="left">Mentions</h3>
<ul>
Raphire <a href="https://github.com/Raphire/Win10Debloat/tree/master">Win10Debloat</a>
</ul>
<ul>
Chris Titus Tech <a href="https://github.com/ChrisTitusTech/winutil">Windows Utility</a>
</ul>
<ul>
Alekhoff <a href="https://github.com/Alekhoff/chocolatey-fresh-install">Chocolatey-fresh-install</a>
</ul>
<ul>
AveYo <a href="https://gist.github.com/ishad0w/3b79bf829e9725aa102b2e8446bb5ef8">Edge Removal</a>
</ul>

<h3 align="left">Author</h3>
<ul>
Michael Keates <a href="https://www.michaelkeates.co.uk">Website</a>
</ul>
