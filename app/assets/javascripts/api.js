function submitForm(){
  alert("we are inside button function");

     $.ajax({
         url: 'https://santiago.pixfizz.com/v1/admin/users/2760630',
         method: 'GET',
         dataType: 'jsonp',
         username: 'santiago@nowhereprod.com',
         password: 'Detech28!!',
         success: function(data){
           console.log('succes: '+data);
         }
       });
}
