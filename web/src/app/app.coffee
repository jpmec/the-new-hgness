### jshint -W093 ###

'use strict'




appModule = angular.module 'TheNewHgnessApp', [
   'ngRoute'
   'appViews'
   'ui.bootstrap'
   'angular-hg'
   # 'angular-hg-views'
]




appModule.config ($routeProvider) ->

  $routeProvider.when('/',
    templateUrl: 'app/app_index_view.html'
  ).when('/repos',
    templateUrl: 'app/app_repos_view.html'
  ).when('/repo/:repoId',
    templateUrl: 'app/app_repo_view.html'
  ).when('/repo/files/:repoId',
    templateUrl: 'app/app_repo_files_view.html'
  ).when('/repo/logs/:repoId',
    templateUrl: 'app/app_repo_logs_view.html'
  ).when('/diff/change/:repoId/:changeId',
    templateUrl: 'app/app_diff_view.html'
  ).when('/file/:repoId/:fileName',
    templateUrl: 'app/app_file_view.html'
  ).when('/help',
    templateUrl: 'app/app_help_view.html'
  ).when('/about',
    templateUrl: 'app/app_about_view.html'
  ).otherwise redirectTo: '/'




appModule.factory 'Requesting', () ->
  object:
    value: null


appModule.factory 'Error', () ->
  object:
    value: null


appModule.factory 'Repos', () ->
  object:
    value: null


appModule.factory 'Repo', () ->
  object:
    value: null


appModule.factory 'RepoFiles', () ->
  object:
    value: null


appModule.factory 'RepoLogs', () ->
  object:
    value: null


appModule.factory 'RepoTip', () ->
  object:
    value: null


appModule.factory 'HotRepo', () ->
  object:
    value: null


appModule.factory 'File', () ->
  object:
    value: null


appModule.factory 'Diff', () ->
  object:
    value: null


appModule.factory 'StatusFilter', () ->
  object:
    value: null


appModule.factory 'Manifest', () ->
  object:
    value: null


appModule.factory 'HgVersion', () ->
  object:
    value: null




appModule.service 'HttpRequestService', ($http, Requesting) ->

  @get = (url, response, onResponse, error, onError) ->

    Requesting.object.value = true

    $http.get(url)
    .success (data, status, headers, config) ->
      if error
        error.value = null

      response.value = data

      if onResponse
        onResponse()

      Requesting.object.value = false
      return

    .error (data, status, headers, config) ->
      response.value = null

      if error
        error.value = data

      if onError
        onError()

      Requesting.object.value = false
      return

  return




appModule.service 'ReposService', (HttpRequestService, Repos, Error) ->

  @url = 'api/0/repos'

  @get = (onSuccess, onError) ->
    url = @url + "?" + "count=3"
    HttpRequestService.get(url, Repos.object, onSuccess, Error.object, onError)

  return




appModule.service 'HotRepoService', (HttpRequestService, HotRepo, Error) ->

  @url = 'api/0/hot_repo'

  @get = (onSuccess, onError) ->
    HttpRequestService.get(@url, HotRepo.object, onSuccess, Error.object, onError)

  return




appModule.service 'RepoService', (HttpRequestService, Repo, Error) ->

  @url = 'api/0/repo/'

  @get = (repoId, onSuccess, onError) ->
    HttpRequestService.get(@url + repoId, Repo.object, onSuccess, Error.object, onError)

  return




appModule.service 'RepoFilesService', (HttpRequestService, RepoFiles, Error) ->

  @url = 'api/0/repo_files/'

  @get = (repoId, onSuccess, onError) ->
    HttpRequestService.get(@url + repoId, RepoFiles.object, onSuccess, Error.object, onError)

  return




appModule.service 'RepoLogsService', (HttpRequestService, RepoLogs, Error) ->

  @url = 'api/0/repo_logs/'

  @get = (repoId, offset, count, onSuccess, onError) ->

    rev = '-' + offset + ':' + '-' + (offset + count - 1)
    url = @url + repoId + '?' + 'rev=' + rev

    HttpRequestService.get(url, RepoLogs.object, onSuccess, Error.object, onError)


  @search = (repoId, keywords, onSuccess, onError) ->

    url = @url + repoId + '?' + 'keywords=' + keywords
    HttpRequestService.get(url, RepoLogs.object, onSuccess, Error.object, onError)

  return




appModule.service 'RepoTipService', (HttpRequestService, RepoTip, Error) ->

  @url = 'api/0/repo_tip/'

  @get = (repoId, onSuccess, onError) ->

    url = @url + repoId + '?' + 'rev=tip'

    HttpRequestService.get(url, RepoTip.object, onSuccess, Error.object, onError)

  return




appModule.service 'DiffService', (HttpRequestService, Diff, Error) ->

  @url = 'api/0/diff/'

  @getChange = (repoId, changeId, onSuccess, onError) ->

    url = @url + 'change/' + repoId + '/' + changeId
    HttpRequestService.get(url, Diff.object, onSuccess, Error.object, onError)

  return




appModule.service 'ManifestService', (HttpRequestService, Manifest, Error) ->

  @url = 'api/0/manifest/'

  @get = (repoId, revId, onSuccess, onError) ->

    url = @url + repoId + '/' + revId
    HttpRequestService.get(url, Manifest.object, onSuccess, Error.object, onError)

  return




appModule.service 'FileService', (HttpRequestService, File, Error) ->

  @url = 'api/0/file/'

  @get = (repoId, fileName, rev, onSuccess, onError) ->

    url = @url + repoId + '/' + fileName

    if rev
      url += '?rev=' + rev

    HttpRequestService.get(url, File.object, onSuccess, Error.object, onError)

  return





appModule.service 'HgVersionService', (HttpRequestService, HgVersion, Error) ->

  @url = 'api/0/hg_version'

  @get = (onSuccess, onError) ->
    HttpRequestService.get(url, HgVersion.object, onSuccess, Error.object, onError)

  return




appModule.controller 'DiffCtrl',
($scope, $routeParams, $timeout, Diff, DiffService) ->
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




appModule.controller 'FileCtrl',
($scope, $routeParams, $timeout, File, FileService) ->
  $scope.repoId = $routeParams.repoId
  $scope.fileName = $routeParams.fileName
  $scope.rev = $routeParams.rev
  $scope.file = File.object


  $scope.get = (repoId, fileName, rev) ->
    FileService.get(repoId, fileName, rev)

  $scope.get($scope.repoId, $scope.fileName, $scope.rev)

  return




appModule.controller 'ManifestCtrl',
($scope, $routeParams, $timeout, Manifest, ManifestService) ->
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




appModule.controller 'RequestingCtrl', ($scope, Requesting) ->
  $scope.requesting = Requesting.object

  return




appModule.controller 'ReposCtrl', ($scope, $timeout, Repos, ReposService) ->
  $scope.repos = Repos.object
  $scope.timeoutMilliseconds = (10) * (60) * (1000)


  $scope.get = () ->
    ReposService.get( ()->
      $timeout( () ->
        $scope.get()
      , $scope.timeoutMilliseconds)
    )


  $scope.prettyDate = (datestr) ->
    return '' if not datestr
    moment(datestr).fromNow()


  $scope.prettyName = (namestr) ->
    return '' if not namestr
    match = namestr.match /(.+) <(\w+@\w+\.\w+)>/

    if match
      # "<a ng-href='mailto:#{match[2]}'>#{match[1]}</a>"
      match[1]
    else
      namestr


  $scope.repoPanelStyle = (repo) ->
    if repo.log
      'panel-default'
    else
      'panel-danger'

  $scope.get()
  return




appModule.controller 'HotRepoCtrl',
($scope, HotRepo, HotRepoService) ->
  $scope.hotRepo = HotRepo.object


  $scope.prettyDate = (datestr) ->
    return '' if not datestr
    moment(datestr).fromNow()


  $scope.prettyName = (namestr) ->
    return '' if not namestr
    match = namestr.match /(.+) <(\w+@\w+\.\w+)>/

    if match
      # "<a ng-href='mailto:#{match[2]}'>#{match[1]}</a>"
      match[1]
    else
      namestr


  $scope.get = () ->
    HotRepoService.get()


  $scope.get()
  return




appModule.controller 'RepoCtrl',
($scope, $location, $routeParams, $timeout, Repo, RepoService) ->
  $scope.repoId = $routeParams.repoId
  $scope.repo = Repo.object

  $scope.statusFilter = 'clean'

  $scope.tabs = {
    'overview':
      'active': 'overview' == $routeParams.active
    'files':
      'active': 'files' == $routeParams.active
    'logs':
      'active': 'logs' == $routeParams.active
  }

  $scope.showFiles = {
    'clean': true
    'ignored': true
    'modified': true
    'added': true
    'removed': true
    'missing': true
    'untracked': true
  }

  $scope.fileFilterClass = {
    'clean':
      'icon': 'fa fa-fw fa-eye'
      'button': 'btn active'
    'ignored':
      'icon': 'fa fa-fw fa-eye'
      'button': 'btn btn-sm active'
    'modified':
      'icon': 'fa fa-fw fa-eye'
      'button': 'btn btn-sm active'
    'added':
      'icon': 'fa fa-fw fa-eye'
      'button': 'btn btn-sm active'
    'removed':
      'icon': 'fa fa-fw fa-eye'
      'button': 'btn btn-sm active'
    'missing':
      'icon': 'fa fa-fw fa-eye'
      'button': 'btn btn-sm active'
    'untracked':
      'icon': 'fa fa-fw fa-eye'
      'button': 'btn btn-sm active'
  }


  $scope.get = (repoId) ->
    RepoService.get(repoId)


  $scope.fileStatusFilter = (f) ->
    $scope.showFiles[f.status]


  $scope.toggleFileFilter = (key) ->
    $scope.showFiles[key] = not $scope.showFiles[key]

    if $scope.showFiles[key]
      $scope.fileFilterClass[key].icon = 'fa fa-fw fa-eye'
      $scope.fileFilterClass[key].button = 'btn active'
    else
      $scope.fileFilterClass[key].icon = 'fa fa-fw fa-eye-slash'
      $scope.fileFilterClass[key].button = 'btn'


  $scope.countStatus = (status) ->

    if $scope.repo.value
      statuses = _.pluck($scope.repo.value.status, 'status')

      count = {}

      _.forEach statuses, (status) ->
        if status of count
          count[status] = count[status] + 1
        else
          count[status] = 1
      , count

      if status of count
        return count[status]
      else
        return 0
    else
      return 0


  $scope.selectTab = (tab) ->
    $location.search('active', tab)


  if $scope.repoId
    $scope.get($scope.repoId)

  return



appModule.controller 'RepoFilesCtrl',
($scope, $location, $routeParams, $timeout, RepoFiles, RepoFilesService) ->
  $scope.repoId = $routeParams.repoId
  $scope.repoFiles = RepoFiles.object


  $scope.showFiles = {
    'clean': true
    'ignored': true
    'modified': true
    'added': true
    'removed': true
    'missing': true
    'untracked': true
  }

  $scope.fileFilterClass = {
    'clean':
      'icon': 'fa fa-fw fa-eye'
      'button': 'btn active'
    'ignored':
      'icon': 'fa fa-fw fa-eye'
      'button': 'btn active'
    'modified':
      'icon': 'fa fa-fw fa-eye'
      'button': 'btn active'
    'added':
      'icon': 'fa fa-fw fa-eye'
      'button': 'btn active'
    'removed':
      'icon': 'fa fa-fw fa-eye'
      'button': 'btn active'
    'missing':
      'icon': 'fa fa-fw fa-eye'
      'button': 'btn active'
    'untracked':
      'icon': 'fa fa-fw fa-eye'
      'button': 'btn active'
  }


  $scope.get = (repoId) ->
    RepoFilesService.get(repoId)


  $scope.fileStatusFilter = (f) ->
    $scope.showFiles[f.status]


  $scope.toggleFileFilter = (key) ->
    $scope.showFiles[key] = not $scope.showFiles[key]

    if $scope.showFiles[key]
      $scope.fileFilterClass[key].icon = 'fa fa-fw fa-eye'
      $scope.fileFilterClass[key].button = 'btn active'
    else
      $scope.fileFilterClass[key].icon = 'fa fa-fw fa-eye-slash'
      $scope.fileFilterClass[key].button = 'btn'


  $scope.countStatus = (status) ->

    if $scope.repoFiles.value
      statuses = _.pluck($scope.repoFiles.value.status, 'status')

      count = {}

      _.forEach statuses, (status) ->
        if status of count
          count[status] = count[status] + 1
        else
          count[status] = 1
      , count

      if status of count
        return count[status]
      else
        return 0
    else
      return 0


  if $scope.repoId
    $scope.get($scope.repoId)

  return




appModule.controller 'RepoTipCtrl',
($scope, $location, $routeParams, $timeout, RepoTip, RepoTipService) ->
  $scope.repoId = $routeParams.repoId
  $scope.repoTip = RepoTip.object

  $scope.get = () ->
    RepoTipService.get($scope.repoId)

  if $scope.repoId
    $scope.get()

  return




appModule.controller 'RepoLogsCtrl',
($scope, $location, $routeParams, $timeout, RepoLogs, RepoLogsService) ->
  $scope.repoId = $routeParams.repoId
  $scope.repoLogs = RepoLogs.object

  $scope.page = 1
  $scope.itemsPerPage = 10

  $scope.searchInput = null


  $scope.get = () ->
    offset = ($scope.page - 1) * $scope.itemsPerPage + 1
    count = $scope.itemsPerPage
    RepoLogsService.get($scope.repoId, offset, count)


  $scope.onSelectPage = (page) ->
    $scope.page = page
    $scope.get()


  $scope.onSearch = (keywords) ->
    RepoLogsService.search($scope.repoId, keywords)


  if $scope.repoId
    $scope.get()

  return




appModule.controller 'StatusFilterCtrl', ($scope, StatusFilter) ->
  $scope.statusFilter = StatusFilter.object


  $scope.toggleStatus = () ->
    return

  return





appModule.controller 'AboutCtrl',
($scope) ->

  return





appModule.controller 'HgVersionCtrl',
($scope, HgVersion, HgVersionService) ->
  $scope.hgVersion = HgVersion.object

  $scope.get = (repoId, changeId) ->
    HgVersionService.get()

  $scope.get()

  return

