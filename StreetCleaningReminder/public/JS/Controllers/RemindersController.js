app.controller('RemindersController', ['$scope', '$http', '$cookies', function($scope, $http, $cookies){

	console.log("in the reminders controller")
	$scope.reminders = JSON.parse($cookies.get('reminders'))
	

	$scope.hourAndDuration = ''
	$scope.day = ''
	$scope.frequency = ''

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
}])
