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

app.directive('filesModel', function (){
  return {
    controller: function($parse, $element, $attrs, $scope){
      var exp = $parse($attrs.filesModel);

      $element.on('change', function(){
        exp.assign($scope, this.files);
        $scope.$apply();
      });
    }
  };
});

app.controller('AddPlantController', ['$scope', '$location', 'PlantService', 
	function($scope, $location, PlantService) {
	
	$scope.plant = {
		name: "",
		description: "",
		image: null
	};

	$scope.save = function() {
		PlantService.save($scope.plant, function() {
			$location.path("/");
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
}]).config(function ($httpProvider) {
  $httpProvider.defaults.transformRequest = function(data) {
    if (data === undefined)
      return data;

    var fd = new FormData();
    angular.forEach(data, function(value, key) {
      if (value instanceof FileList) {
        if (value.length == 1) {
          fd.append(key, value[0]);
        } else {
          angular.forEach(value, function(file, index) {
            fd.append(key + '_' + index, file);
          });
        }
      } else {
        fd.append(key, value);
      }
    });

    return fd;
  }

  $httpProvider.defaults.headers.post['Content-Type'] = undefined;
});;