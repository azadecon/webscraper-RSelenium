# webscraper-RSelenium
Web-scraper built using RSelenium


# Known issues.
This webscraper is good for relatively light jobs. So far I have observed following issues with it.
# 1. Error 403
After on an average each 25-30 requests, **error 403** appears. It simply means that the resource(here the website) simply denied our request for the access. One way to solve it could be to add a longer pause after 25-30 requests. The script already takes a pause of 1-10 seconds after each request.

# 2. Port already in use
It is a known issue. [https://stackoverflow.com/questions/43991498/rselenium-server-signals-port-is-already-in-use](ss)
