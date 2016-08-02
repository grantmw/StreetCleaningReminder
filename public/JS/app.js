

var app = angular.module('myapp', ['ngRoute', 'ngCookies']);

app.config(['$routeProvider', '$locationProvider', 
	function ($routeProvider, $locationProvider){ 

		$routeProvider
		.when('/',{
			controller: 'RemindersController',
			templateUrl: '../components/reminders.html'
		})

	}
]);

