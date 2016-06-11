app.controller('RemindersController', ['$scope', '$http', '$cookies', function($scope, $http, $cookies){

	console.log("in the reminders controller")
	$scope.reminders = JSON.parse($cookies.get('reminders'))
	
	$scope.hour_start = ''
	$scope.hour_end = ''
	$scope.day = ''
	$scope.frequency = ''

	// console.log(shareVariables.getProperty())



	$scope.update_reminder = function(){
		var reminder_attr = {
			"hour_start": $scope.hour_start,
			"hour_end": $scope.hour_end, 
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
