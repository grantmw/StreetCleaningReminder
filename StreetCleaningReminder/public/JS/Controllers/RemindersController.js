app.controller('RemindersController', ['$scope', '$http', '$cookies', function($scope, $http, $cookies){

	$scope.reminders = []
	$scope.hourAndDuration = ''
	$scope.day = ''
	$scope.frequency = ''
	$scope.phone_number = ""
	$scope.password = ""
	$scope.user_name = ""




	var check_login = function(){	
		if ($cookies.get('loggedin') == 'false' || typeof $cookies.get('loggedin') == 'undefined'){
			$(".not_logged_in").show()
			$('.show_reminders').hide()
		}
		else {
			$(".not_logged_in").hide()
			$('.welcome_message').html('Logged in as: ' + $cookies.get('user_name'))
		}
	}
	check_login()

	var get_reminders = function(){
		$http({
			url: '/reminders',
			method: 'GET',
			params: {user_phone_number: $cookies.get('user_phone_number')}
		}).success(function(response){
			$scope.reminders = response['reminders']
			if($scope.reminders.length == 0){
				$(".show_reminders").hide()
				if ($cookies.get('loggedin') == 'true'){
					$(".no_reminders").show()	
				}
			} else {
				$(".show_reminders").show()
				$(".no_reminders").hide()
			}
			$scope.phone_number = $cookies.get('user_phone_number')
		})
		.error(function(response){
			console.log("Failed to get reminders")
		})


	}
	get_reminders()

	$scope.delete_reminder = function(id){
		console.log("this is the id: " + String(id))

		$http({
			url: "/reminders/" + id,
			method: 'DELETE',
		}).success(function(response){
			console.log("reminder successfully deleted")
			get_reminders()
		})
		.error(function(response){
			console.log("Failed to delete reminder")
		})

	}

	$scope.create_reminder = function(){
		console.log("this is the create reminder function: this is scope phone_number")
		console.log($scope.phone_number)
		var reminder_attr = {
			"hourAndDuration": $scope.hourAndDuration,
			"day": $scope.day,
			"frequency": $scope.frequency,
			"phone_number": $cookies.get('user_phone_number')
		}

		$http.post('/reminders', reminder_attr).success(function(response){
			get_reminders()
			// $cookies.put('email', response['user']['email'])
			// $cookies.putObject('results', response['results']);

		})
		.error(function(response){
			console.log('this is the error response of create_reminders function:')
			console.log(response)
			if(response[0] == "over limit"){
				alert("Sorry, you cannot make more than six reminders.")
			}
			console.log("Failed")
		})
	}


	$scope.signin = function(){
		var user = {
			"phone_number": $scope.phone_number,
			"password": $scope.password 

		}


		$http.post('/sessions', user).success(function(response){
			$cookies.put('loggedin', 'true')
			$cookies.put('user_name', response['user_name'])
			$scope.reminders = response['reminders']
			$scope.user_name = response['user_name']
			$scope.phone_number = String(response['user_phone_number'])
			$cookies.put('user_phone_number', String(response['user_phone_number']))
			$('.welcome_message').html('Logged in as: ' + $scope.user_name)
			get_reminders()
			check_login()
		})
		.error(function(response){
			console.log("Failed")
			$cookies.put('loggedin', 'false')
			$cookies.put('user_phone_number', 'not logged in')
			$("#myModal").modal("toggle")
		})
	}	

	$scope.register = function(){
		var user = {
			"phone_number": $scope.phone_number,
			"password": $scope.password,
			"user_name": $scope.user_name
		}


		$http.post('/users', user).success(function(response){
			console.log("Successfully Registered")
		})
		.error(function(response){
			console.log("Failed to Register")
			$("#myRegisterModal").modal("toggle")
		})
	}

	$scope.log_out = function(){
		$cookies.remove('loggedin')
		$cookies.remove('user_phone_number')
		$cookies.remove('user_name')
		$('.welcome_message').css("display", "none")
		check_login()
	}
}])
