app.controller('RemindersController', ['$scope', '$http', '$cookies', function($scope, $http, $cookies){

	console.log("in the reminders controller")
	$scope.reminders = JSON.parse($cookies.get('reminders'))
	console.log($cookies.get('poop'))

	
	
	if ($cookies.get('loggedin') == 'false' || typeof $cookies.get('loggedin') == 'undefined'){
		$("#myModal").modal("toggle")
	}


	$scope.hourAndDuration = ''
	$scope.day = ''
	$scope.frequency = ''
	$scope.phone_number = ""
	$scope.password = ""
	// console.log(shareVariables.getProperty())



	$scope.update_reminder = function(){
		var reminder_attr = {
			"hourAndDuration": $scope.hourAndDuration,
			"day": $scope.day,
			"frequency": $scope.frequency 
		}

		$http.post('/reminders', reminder_attr).success(function(response){

			
			// $cookies.put('email', response['user']['email'])
			// $cookies.putObject('results', response['results']);

		})
		.error(function(response){
			console.log("Failed")
		})
	}


	$scope.signin = function(){
		var user = {
			"phone_number": $scope.phone_number,
			"password": $scope.password 
		}


		$http.post('/sessions', user).success(function(response){
			console.log(response)
			console.log(response['reminders'])
			console.log(response['user'])
			$cookies.put('loggedin', 'true')
			// shareVariables.setProperty(response[user])
			$cookies.put('reminders', JSON.stringify(response['reminders']))
			$cookies.put('user', JSON.stringify(response['user']))
			// $cookies.putObject('results', response['results']);
			window.location = '/#/'

		})
		.error(function(response){
			console.log("Failed")
			$cookies.put('loggedin', 'false')
			$("#myModal").modal("toggle")
		})
	}
}])
