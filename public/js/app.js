var app = angular.module("app", ["ngRoute", "ngCookies"]);
app.config(["$routeProvider", "$locationProvider", 
	function ($routeProvider, $locationProvider){ 
		$routeProvider
		.when("/",{
			controller: "RemindersController",
			templateUrl: "../components/reminders.html"
		});
	}
]);

app.controller("RemindersController", ["$scope", "$http", "$cookies", function($scope, $http, $cookies){

	$scope.reminders = [];
	$scope.hourAndDuration = "";
	$scope.day = "";
	$scope.frequency = "";
	$scope.phoneNumber = "";
	$scope.password = "";
	$scope.userName = "";
	$scope.reminderName = "";

	var check_login = function(){	
		if ($cookies.get("loggedin") == "false" || typeof $cookies.get("loggedin") == "undefined"){
			$(".not-logged-in").show();
			$(".show_reminders").hide();
			$(".logged-in").hide();
		}
		else {
			$(".logged-in").show();
			$(".not-logged-in").hide();
			$(".welcome-message").html("Logged in as: " + $cookies.get("user_name"));
		}
	};
	check_login();

	var get_reminders = function(){
		$http({
			url: "/reminders",
			method: "GET",
			params: {user_phone_number: $cookies.get("userPhoneNumber")}
		}).success(function(response){
			$scope.reminders = response["reminders"];
			if($scope.reminders.length == 0){
				$(".show_reminders").hide();
				if ($cookies.get("loggedin") == "true"){
					$(".no_reminders").show();
				}
			} else {
				$(".show_reminders").show();
				$(".no_reminders").hide();
			}
			$scope.phoneNumber = $cookies.get("userPhoneNumber");
		})
		.error(function(response){
		});
	};

	if ($cookies.get("loggedin") == "true"){
		get_reminders();
	}

	$scope.delete_reminder = function(id){
		$http({
			url: "/reminders/" + id,
			method: "DELETE",
		}).success(function(response){
			get_reminders()
		})
		.error(function(response){
		});
	}

	$scope.create_reminder = function(){
		var reminder_attr = {
			"hourAndDuration": $scope.hourAndDuration,
			"day": $scope.day,
			"frequency": $scope.frequency,
			"phone_number": $cookies.get("userPhoneNumber"),
			"reminder_name": $scope.reminderName
		};

		$http.post("/reminders", reminder_attr).success(function(response){
			get_reminders();
			$("form").each(function() { this.reset() });
			$("select").each(function() { this.selectedIndex = -1 });
		})
		.error(function(response){
			if ($cookies.get("userPhoneNumber") == "not logged in"){
				alert("Login to create a reminder");
			} else{
				alert(response[0]);	
			}
		});
	}

	$scope.signin = function(){
		var user = {
			"phone_number": $scope.phoneNumber,
			"password": $scope.password 
		};

		$http.post("/sessions", user).success(function(response){
			$cookies.put("loggedin", "true");
			$cookies.put("user_name", response["user_name"]);
			$scope.reminders = response["reminders"];
			$scope.userName = response["user_name"];
			$scope.phoneNumber = String(response["user_phone_number"]);
			$cookies.put("userPhoneNumber", String(response["user_phone_number"]));
			$(".welcome_message").html("Logged in as: " + $scope.userName);
			check_login();
			get_reminders();
			window.location.reload();
		})
		.error(function(response){
			$cookies.put("loggedin", "false");
			$cookies.put("userPhoneNumber", "not logged in");
			$(".signin-error h5").html("Incorrect phone number or password");
			$(".signin-error").show();
			$("#myModal").modal("toggle");
		})
	}	

	$scope.register = function(){
		var user = {
			"phone_number": $scope.phoneNumber,
			"password": $scope.password,
			"user_name": $scope.userName
		};

		$http.post("/users", user).success(function(response){
			window.location.reload();
		})
		.error(function(response){
			$(".register-error h5").html(response[0]);
			$(".register-error").show();
			$("#myRegisterModal").modal("toggle");
		});
	}

	$scope.closeModal = function(){
		$(".modal").hide();
		window.location.reload();
	}

	$scope.log_out = function(){
		$cookies.remove("loggedin");
		$cookies.remove("userPhoneNumber");
		$cookies.remove("user_name");
		$scope.userName = "";
		$(".welcome_message").css("display", "none");
		check_login();
	}
}])