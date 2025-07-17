# logger

This simple app is the boilerplate code for when I need:
* a sandbox for testing
* I need a lot of logging information

The one requirement it has:
* in Config() class you need to provide a server url:
    + static const String server_log_url = '{YOUR LOGGING URL HERE}';
    + whatever backend is used must return a simple JSON with:
    + "status" : "good" //  if it worked
    + "status" : "bad"  //  if no worky

