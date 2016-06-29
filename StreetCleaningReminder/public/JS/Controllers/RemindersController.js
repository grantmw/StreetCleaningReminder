app.controller('RemindersController', ['$scope', '$http', '$cookies', function($scope, $http, $cookies){
	// take out all cookies?
	console.log("in the reminders controller")
	// $scope.reminders = JSON.parse($cookies.get('reminders'))
	$scope.reminders = []


	var check_login = function(){	
		if ($cookies.get('loggedin') == 'false' || typeof $cookies.get('loggedin') == 'undefined'){
			$("#myModal").modal("toggle")
		}
		console.log($cookies.get('loggedin'))
		console.log("is the person logged in? --> True")
	}
	check_login()

	var get_reminders = function(){
		console.log('ran get_reminders function')
		$http({
			url: '/reminders',
			method: 'GET',
			params: {user_phone_number: $cookies.get('user_phone_number')}
		}).success(function(response){
			console.log('get_reminders ran successfully')
			$scope.reminders = response['reminders']
			if($scope.reminders.length == 0){
				$(".show_reminders").hide()
				$(".no_reminders").show()	
				console.log("should have hid show reminders div")		
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


	// $scope.getFontSize = function(){
	// 	$http({
	// 		url: '/levels',
	// 		method: 'GET',
	// 		params: {"screen_width": screen.width}
	// 	})
	// 	.success(function(response){
	// 		$scope.fontSizes = response; //returning array of objects containing vision level and correspondings font-sizes
	// 		console.log(response)
	// 		renderLetters()
	//      	$('#vision-text').css("font-size", $scope.fontSizes[0]["font_size"]+"px"); //Jquery code to update font sizes
	// 	})

	// }


	$scope.hourAndDuration = ''
	$scope.day = ''
	$scope.frequency = ''
	$scope.phone_number = ""
	$scope.password = ""
	// console.log(shareVariables.getProperty())



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
			console.log('this is the response of create_reminders function:')
			console.log(response)
			console.log("Failed")
		})
	}


	$scope.signin = function(){
		var user = {
			"phone_number": $scope.phone_number,
			"password": $scope.password 
		}


		$http.post('/sessions', user).success(function(response){
			// console.log(response['reminders'])
			console.log(String(response['user_phone_number']))
			$cookies.put('loggedin', 'true')

			// shareVariables.setProperty(response[user])
			$scope.reminders = response['reminders']
			$scope.phone_number = String(response['user_phone_number'])
			// $cookies.put('reminders', JSON.stringify(response['reminders']))
			$cookies.put('user_phone_number', String(response['user_phone_number']))
			// $cookies.putObject('results', response['results']);
			window.location = '/#/'

		})
		.error(function(response){
			console.log("Failed")
			$cookies.put('loggedin', 'false')
			$cookies.put('user_phone_number', 'not logged in')
			$("#myModal").modal("toggle")
		})
	}
}])
