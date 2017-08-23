// var settings = {
//   "async": true,
//   "crossDomain": true,
//   "url": "https://corporate.pixfizz.com/v1/admin/users/",
//   "method": "GET",
//   "crossDomain": true,
//   "headers": {
//
//     "authorization": "Basic c2FudGlhZ29Abm93aGVyZXByb2QuY29tOkhhYml0YXQyOA==",
//     "content-type": "application/json",
//     "cache-control": "no-cache",
//
//   },
//   "data": {
//     "from": "18349347"
//   }
// }
//
// $.ajax(settings).done(function (response) {
//   console.log(response);
// });


var settings = {
  "async": true,
  "crossDomain": true,
  "url": "https://login.salesforce.com/services/oauth2/token?grant_type=password&client_id=3MVG9WtWSKUDG.x4G.GRPQb1Yzl8EUkBFVCy5xEnh9dmrv96y8MsYxl6Cz0ZHtJvD9hUBCLTUcPM57_GUfGj.&client_secret=4087144410510429660&username=stephen_thorpe%40sjtsystems.com&password=M3l1ss%4008znx54cGVrKrzkVnyyhkLlGlz",
  "method": "POST",
  "headers": {
    "content-type": "application/x-www-form-urlencoded",
    "cache-control": "no-cache",
    "postman-token": "e55fa98d-d75d-d0fb-05d7-125cf28ba3ed"
  }
}

$.ajax(settings).done(function (response) {
  console.log(response);
});
