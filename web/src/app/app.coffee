### jshint -W093 ###

'use strict'




appModule = angular.module 'TheNewHgnessApp', [
   'ngRoute'
   'appViews'
   'ui.bootstrap'
   'angular-chartjs-directive'
   'angular-hg'
   # 'angular-hg-views'
]




appModule.config ($routeProvider) ->
  $routeProvider.when('/repos',
    templateUrl: 'app/app_repos_view.html'
  ).when('/repo/:repoId',
    templateUrl: 'app/app_repo_view.html'
  ).when('/diff/change/:repoId/:changeId',
    templateUrl: 'app/app_diff_view.html'
  ).otherwise redirectTo: '/repos'




appModule.factory 'Requesting', () ->
  object:
    value: null




appModule.factory 'Repos', () ->
  object:
    value: null




appModule.factory 'Repo', () ->
  object:
    value: null




appModule.factory 'Diff', () ->
  object:
    value: null




appModule.factory 'Manifest', () ->
  object:
    value: null




appModule.service 'ReposService', ($http, Repos, Requesting) ->

  @url = 'api/0/repos'

  @get = (onSuccess, onError) ->

    Requesting.object.value = true

    $http.get(@url)
    .success (data, status, headers, config) ->
      Repos.object.value = data

      Requesting.object.value = false

      if onSuccess
        onSuccess()

      return

    .error (data, status, headers, config) ->
      Repos.object.value = null

      Requesting.object.value = false

      if onError
        onError()

      return

  return




appModule.service 'RepoService', ($http, Repo, Requesting) ->

  @url = 'api/0/repo/'

  @get = (repoId, onSuccess, onError) ->

    Requesting.object.value = true

    $http.get(@url + repoId)
    .success (data, status, headers, config) ->
      Repo.object.value = data

      Requesting.object.value = false

      if onSuccess
        onSuccess()

      return

    .error (data, status, headers, config) ->
      Repo.object.value = null

      Requesting.object.value = false

      if onError
        onError()

      return

  return




appModule.service 'DiffService', ($http, Diff, Requesting) ->

  @url = 'api/0/diff/'

  @getChange = (repoId, changeId, onSuccess, onError) ->

    Requesting.object.value = true

    $http.get(@url + 'change/' + repoId + '/' + changeId)
    .success (data, status, headers, config) ->
      Diff.object.value = data

      Requesting.object.value = false

      if onSuccess
        onSuccess()

      return

    .error (data, status, headers, config) ->
      Diff.object.value = null

      Requesting.object.value = false

      if onError
        onError()

      return

  return




appModule.service 'ManifestService', ($http, Manifest, Requesting) ->

  @url = 'api/0/manifest/'

  @get = (repoId, revId, onSuccess, onError) ->

    Requesting.object.value = true

    $http.get(@url + repoId + '/' + revId)
    .success (data, status, headers, config) ->
      Manifest.object.value = data

      Requesting.object.value = false

      if onSuccess
        onSuccess()

      return

    .error (data, status, headers, config) ->
      Manifest.object.value = null

      Requesting.object.value = false

      if onError
        onError()

      return

  return




appModule.controller 'RequestingCtrl', ($scope, Requesting) ->
  $scope.requesting = Requesting.object

  return




appModule.controller 'ReposCtrl', ($scope, $timeout, Repos, ReposService) ->
  $scope.repos = Repos.object
  $scope.timeoutMilliseconds = (1) * (60) * (1000)


  $scope.get = () ->
    ReposService.get( ()->
      $timeout( () ->
        $scope.get()
      , $scope.timeoutMilliseconds)
    )


  $scope.prettyDate = (datestr) ->
    moment(datestr).fromNow()


  $scope.prettyName = (namestr) ->
    match = namestr.match /(.+) <(\w+@\w+\.\w+)>/

    if match
      # "<a ng-href='mailto:#{match[2]}'>#{match[1]}</a>"
      match[1]
    else
      namestr


  $scope.get()
  return




appModule.controller 'RepoCtrl', ($scope, $routeParams, $timeout, Repo, RepoService) ->
  $scope.repoId = $routeParams.repoId
  $scope.repo = Repo.object

  $scope.get = (repoId) ->
    RepoService.get(repoId)

  if $scope.repoId
    $scope.get($scope.repoId)

  return



appModule.controller 'DiffCtrl', ($scope, $routeParams, $timeout, Diff, DiffService) ->
  $scope.repoId = $routeParams.repoId
  $scope.changeId = $routeParams.changeId
  $scope.diff = Diff.object
  $scope.timeoutMilliseconds = 1000000

  $scope.get = (repoId, changeId) ->
    DiffService.getChange(repoId, changeId, ()->
      $timeout( () ->
        $scope.get(repoId, changeId)
      , $scope.timeoutMilliseconds)
    )

  if $scope.repoId and $scope.changeId
    $scope.get($scope.repoId, $scope.changeId)

  return




appModule.controller 'ManifestCtrl', ($scope, $routeParams, $timeout, Manifest, ManifestService) ->
  $scope.repoId = $routeParams.repoId
  $scope.changeId = $routeParams.changeId
  $scope.manifest = Manifest.object
  $scope.timeoutMilliseconds = 1000000

  $scope.get = (repoId, changeId) ->
    ManifestService.get(repoId, changeId, ()->
      $timeout( () ->
        $scope.get(repoId, changeId)
      , $scope.timeoutMilliseconds)
    )

  if $scope.repoId and $scope.changeId
    $scope.get($scope.repoId, $scope.changeId)

  return


