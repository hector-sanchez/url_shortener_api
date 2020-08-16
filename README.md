# README

This is a simple REST service to shorten URLs. It receives the url you'd like shortened and returns a shortened url that can then be used instead of the one passed it. 

Besides the url to shorten, the service accepts three additional and optional arguments that provide for some flexibility.

**slug** - a slug can be passed to serve as identification for the new and shortened url that will be generated. If the slug given is not available (because a url with that slug already exists) the creation of the shortened url will failed and an error will be returned. If a slug is not given, one is generated.

**expire_at** - this is a date in the future when the new url is not longer reachable (is not active). If no expire_at is given, the shortened url...does not expire.

**user_id** - the user id is passed in as part of an authentication token that is available to logged-in users. The token is passed in the request header. If a user id is given as part of a shortened url creation, that basically means the user owns that shortened url and can expire the url (which is basically destroy).

### Endpoints

1. api/v1/short_urls/
2. api/v1/users/
3. api/v1/tokens/

### How to run

I used Postman to test. 

**Short Urls**

***GET list of active (unexpired) short urls*** - /api/v1/short_urls

***GET short url*** - /api/v1/short_urls/:id

***POST create new short url*** - /api/v1/short_urls

  * { "short_url": { "slug":"", "original_url":"http://www.longesturlintheworld.com", "expire_at":"2020-08-20T06:05:42.888Z" } }
  * (if token available) headers: Authorization -> "encoded token"

***DELETE expire short url*** - /api/v1/short_url/:id
  * (valid authorization token must be in the request otherwise it will fail) headers: Authorization -> "encoded token"
