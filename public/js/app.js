var app = angular.module('app');
app.config(['$routeProvider', '$locationProvider', 
	function ($routeProvider, $locationProvider){ 
		$routeProvider
		.when('/',{
			controller: 'RemindersController',
			templateUrl: '../components/reminders.html'
		})
	}
]);

//, ['ngRoute', 'ngCookies'] - put right after 'app'