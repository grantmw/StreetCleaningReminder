app.controller('SigninController', ['$scope', '$http', '$cookies', function($scope, $http, $cookies){

	$scope.phone_number = ""
	$scope.password = ""



	$scope.signin = function(){
		var user = {
			"phone_number": $scope.phone_number,
			"password": $scope.password 
		}

		$http.post('/sessions', user).success(function(response){
			console.log(response)
			console.log('hello')
			console.log(response['reminders'])
			$cookies.put('loggedin', 'true')
			// shareVariables.setProperty(response[user])
			$cookies.put('reminders', JSON.stringify(response['reminders']))

			$cookies.put('user', JSON.stringify(response['user']))
			// $cookies.putObject('results', response['results']);
			window.location = '/#/reminders'

		})
		.error(function(response){
			console.log("Failed")
		})
	}
}])
