# webscraper-RSelenium
Web-scraper built using RSelenium


# Known issues.
This webscraper is good for relatively light jobs. So far I have observed following issues with it.
# 1. Error 403
After each 25-30 requests on an average, **error 403** appears. It simply means that the resource(here the website) simply denied our request for the access. 
- One way to solve it could be to add a longer pause after 25-30 requests. The script already takes a pause of 1-10 seconds after each request.
- Yet another solution could be to use a proxy.

# 2. Port already in use
After on an average each 25-30 requests, **port already use** error appears. As per my understanding, each time a browser instance is opened, it opens on a a port. Unless one closes the port, a new instance of browser can not be opened on the same port. Since, I am already using ``free_port()`` function from ``netstat`` package, it opens the new instance on a new port. The fact that the script runs fine for 25-30 times means there are enough ports.  

Also, it is a [known issue](https://stackoverflow.com/questions/43991498/rselenium-server-signals-port-is-already-in-use).

# Updates to be included:

