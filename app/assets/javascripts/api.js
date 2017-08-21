function submitForm(){
  alert("we are inside button function");
  var myData;
     $.ajax({
         url: 'https://corporate.pixfizz.com/v1/admin/users.json',
         method: 'GET',
         dataType: 'jsonp',
         username: 'santiago@nowhereprod.com',
         password: 'Detech28',
         success: function(data){
          console.log('success')
           myData = data
            console.log(myData);
         }
       });
}



var auth = btoa('santiago@nowhereprod.com:Detech28');
$.ajax({
    type: 'GET',
    url: 'https://corporate.pixfizz.com/v1/admin/users.json',
    headers: {
        "Authorization": "Basic " + auth
    },
    success : function(data) {
    },

});
