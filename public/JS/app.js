var app = angular.module('app', ['ngRoute', 'ngCookies']);

app.config(function ($routeProvider, $locationProvider){ $routeProvider
	// .when('/',{
	// 	controller: 'SigninController',
	// 	templateUrl: '../components/reminders.html'
	// })
	.when('/',{
		controller: 'RemindersController',
		templateUrl: '../components/reminders.html'
	})



})

// app.service('shareVariables', function () {
//         var property = {
//         	data: 'test object value'
//         };

//         return {
//             getProperty: function () {
//                 return property;
//             },
//             setProperty: function(value) {
//                 property = value;
//         }
//     };
// });