var settings = {
  "async": true,
  "crossDomain": true,
  "url": "https://corporate.pixfizz.com/v1/admin/users/",
  "method": "GET",
  "headers": {
    "authorization": "Basic c2FudGlhZ29Abm93aGVyZXByb2QuY29tOkhhYml0YXQyOA==",
    "content-type": "application/json",
    "cache-control": "no-cache",
    
  },
  "data": {
    "from": "18349347"
  }
}

$.ajax(settings).done(function (response) {
  console.log(response);
});
