var app = angular.module('app', ['ngRoute', 'ngCookies']);
app.config(['$routeProvider', '$locationProvider', 
	function ($routeProvider, $locationProvider){ 
		$routeProvider
		.when('/',{
			controller: 'RemindersController',
			templateUrl: '../components/reminders.html'
		})
	}
]);
