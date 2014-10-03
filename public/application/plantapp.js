var app = angular.module('PlantApplication', ['ngRoute', 'ngResource']);

app.factory('PlantService', ['$resource', function($resource) {
	return $resource('/plants/:id', {id: '@id'}, {
		get: {method: 'GET'},
		query: { method: 'GET', isArray: true }
	});
}]);

app.factory('RecommendationService', ['$resource', function($resource) {
	return $resource('/recommendations/:id', {id: '@id'}, {
		query: { method: 'GET', isArray: true }
	});
}]);

app.controller('PlantController', 
	['$scope', '$location', 'PlantService', function($scope, $location, PlantService) {
	$scope.plants = PlantService.query();

	$scope.collect = function(index) {
		$location.path("/details/"+index);
	}
}]);

app.controller('DetailController', 
	['$scope', '$routeParams', 'PlantService', 'RecommendationService', function($scope, $routeParams, PlantService, RecommendationService) {
	$scope.plant = PlantService.get({id: $routeParams.id});
	$scope.recommendations = RecommendationService.query({id: $routeParams.id});
}]);

app.controller('AddPlantController', ['$scope', '$location', 'PlantService', function($scope, $location, PlantService) {
	$scope.plant = {
		name: "",
		description: ""
	};

	$scope.save = function() {
		PlantService.save($scope.plant, function() {
			console.log($scope.plant);
			//$location.path("/");
		});
	}
}]);

app.config(['$routeProvider', function($routeProvider) {
	$routeProvider
	.when('/', {
		templateUrl: 'templates/main-content.html',
        controller: 'PlantController'
	})
	.when('/add', {
		templateUrl: 'templates/add-plant.html',
		controller: 'AddPlantController'
	})
	.when('/details/:id', {
		templateUrl: 'templates/detail-page.html',
		controller: 'DetailController'
	});
}]);