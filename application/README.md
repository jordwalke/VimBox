Support for using VimBox as a separate app.
The ./LaunchVendoredMacVim.sh is the only script that needs to be bundled into
a tiny .app. It will vendor the system MacVim.app, rebrand it and apply the new
icon/shortcuts.
Use a tool like Platypus to wrap up that script into a bundle called
VimBox.app.
That script will then be at the top of that application bundle along with
nothing else. Then that script will clone this very repo, and copy MacVim.app
into VimBox.app inside of that outer VimBox.app.
