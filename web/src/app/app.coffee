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
  $routeProvider.when('/repos',
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
  ).when('/about',
    templateUrl: 'app/app_about_view.html'
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




appModule.factory 'RepoFiles', () ->
  object:
    value: null




appModule.factory 'RepoLogs', () ->
  object:
    value: null




appModule.factory 'RepoTip', () ->
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




appModule.service 'RepoFilesService', ($http, RepoFiles, Requesting) ->

  @url = 'api/0/repo_files/'

  @get = (repoId, onSuccess, onError) ->

    Requesting.object.value = true

    $http.get(@url + repoId)
    .success (data, status, headers, config) ->
      RepoFiles.object.value = data

      Requesting.object.value = false

      if onSuccess
        onSuccess()

      return

    .error (data, status, headers, config) ->
      RepoFiles.object.value = null

      Requesting.object.value = false

      if onError
        onError()

      return

  return




appModule.service 'RepoLogsService', ($http, RepoLogs, Requesting) ->

  @url = 'api/0/repo_logs/'

  @get = (repoId, offset, count, onSuccess, onError) ->

    rev = '-' + offset + ':' + '-' + (offset + count - 1)

    Requesting.object.value = true

    $http.get(@url + repoId + '?' + 'rev=' + rev)
    .success (data, status, headers, config) ->
      RepoLogs.object.value = data

      Requesting.object.value = false

      if onSuccess
        onSuccess()

      return

    .error (data, status, headers, config) ->
      RepoLogs.object.value = null

      Requesting.object.value = false

      if onError
        onError()

      return


  @search = (repoId, keywords, onSuccess, onError) ->

    Requesting.object.value = true

    $http.get(@url + repoId + '?' + 'keywords=' + keywords)
    .success (data, status, headers, config) ->
      RepoLogs.object.value = data

      Requesting.object.value = false

      if onSuccess
        onSuccess()

      return

    .error (data, status, headers, config) ->
      RepoLogs.object.value = null

      Requesting.object.value = false

      if onError
        onError()

      return

  return




appModule.service 'RepoTipService', ($http, RepoTip) ->

  @url = 'api/0/repo_tip/'

  @get = (repoId, onSuccess, onError) ->

    $http.get(@url + repoId + '?' + 'rev=tip')
    .success (data, status, headers, config) ->
      RepoTip.object.value = data

      if onSuccess
        onSuccess()

      return

    .error (data, status, headers, config) ->
      RepoTip.object.value = null

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




appModule.service 'FileService', ($http, File, Requesting) ->

  @url = 'api/0/file/'

  @get = (repoId, fileName, rev, onSuccess, onError) ->

    Requesting.object.value = true

    url = @url + repoId + '/' + fileName

    if rev
      url += '?rev=' + rev

    $http.get(url)
    .success (data, status, headers, config) ->
      File.object.value = data

      Requesting.object.value = false

      if onSuccess
        onSuccess()

      return

    .error (data, status, headers, config) ->
      File.object.value = null

      Requesting.object.value = false

      if onError
        onError()

      return

  return





appModule.service 'HgVersionService', ($http, HgVersion, Requesting) ->

  @url = 'api/0/hg_version'

  @get = (onSuccess, onError) ->

    Requesting.object.value = true

    $http.get(@url)
    .success (data, status, headers, config) ->
      HgVersion.object.value = data

      Requesting.object.value = false

      if onSuccess
        onSuccess()

      return

    .error (data, status, headers, config) ->
      HgVersion.object.value = null

      Requesting.object.value = false

      if onError
        onError()

      return

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
  $scope.timeoutMilliseconds = (1) * (60) * (1000)


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

