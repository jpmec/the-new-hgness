

m = angular.module "angular-hg", []



m.controller 'hgHunkCtrl',
($scope) ->

  $scope.number = ($offset, $index) ->
    parseInt($offset) + parseInt($index)

  return



m.directive 'hgDiff', ($filter) ->
  restrict: "E"
  replace: true
  scope:
    diff: '=diff'
    repo: '=repo'
    rev: '=rev'

  template: """
  <div>
    <div ng-repeat="file in diff.files">
      <h3>
        <a href="#/file/{{repo}}/{{file.name}}?rev={{rev}}">{{file.name}}</a>
      </h3>
      <h4>
        {{file['from-file']}}
        {{file['from-file-modification-time'] | date:'short'}}
      </h4>
      <h4>
        {{file['to-file']}}
        {{file['to-file-modification-time'] | date:'short'}}
      </h4>
      <div ng-repeat="hunk in file.hunks" ng-controller="hgHunkCtrl">
        <div class="panel panel-default">
          <div class="panel-heading">
            <div class="panel-title">
              <h5>
                {{hunk['from-file-line-number']}}
                {{hunk['to-file-line-number']}}
              </h5>
            </div>
          </div>
          <div class="panel-body">
            <table>
              <tbody>
                <tr ng-repeat="hunkline in hunk['lines'] track by $index">
                  <td>
                    <span class="angular-hg-file-line-number">{{number(hunk['from-file-line-number'], $index)}}</span>
                  </td>
                  <td>
                    <span class="angular-hg-file-line-number">{{number(hunk['to-file-line-number'], $index)}}</span>
                  </td>
                  <td>
                    <span class="angular-hg-hunk-line-{{hunkline.status}}">{{hunkline.text}}</span>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
  """




  # template: """
  # <div>
  #   <pre>{{diff.files}}</pre>
  #   <pre>{{diff.raw}}</pre>

  #   <div ng-repeat="file in diff.files">
  #     <h3>{{file.name}}</h3>
  #     <h4>{{file['from-file']}} {{file['from-file-modification-time']}}</h4>
  #     <h4>{{file['to-file']}} {{file['to-file-modification-time']}}</h4>

  #     <div ng-repeat="hunk in file.hunks">

  #       {{hunk['from-file-line-numbers']}}
  #       {{hunk['to-file-line-numbers']}}

  #       <pre ng-repeat="line in hunk.lines">
  #         {{line}}
  #       </pre>
  #     </div>

  #     <pre>{{file}}</pre>
  #   </div>
  # </div>
  # """



m.directive 'hgFile', ($filter) ->
  restrict: "E"
  replace: true
  scope:
    repo: '=repo'
    file: '=file'

  template: """
  <div class="panel panel-default">
    <div class="panel-body">
      <table class="table-hover">
        <tr ng-repeat="line in file.lines track by $index">
          <td>
            <span class="angular-hg-file-line-number">{{$index}}</span>
          </td>
          <td>
            <span class="angular-hg-file-line">{{line}}</span>
          </td>
        </tr>
      </table>
    </div>
  </div>
  """




m.directive 'hgLog', ($filter) ->

  restrict: "E"
  replace: true
  template: """
  <table class="table table-condensed table-responsive">
    <thead>
      <th>Tag</th>
      <th>Date</th>
      <th>User</th>
      <th>Summary</th>
    </thead>
    <tbody>
      <tr ng-repeat="logItem in log">
        <td>
          <span class="label label-info" ng-show="logItem.tag">
            <i class="fa fa-tag fa-fw"></i> {{logItem.tag}}
          </span>
        </td>
        <td>
          <span tooltip="{{logItem.date| date:'EEE MMM d, y h:mm:ss a'}}">
            {{logItem.date*1000 | date:'short'}}
          </span>
        </td>
        <td>{{logItem.user | hgUser}}</td>
        <td>
          <span tooltip-placement="left" tooltip="{{logItem.changeset}}">
            <a href="#/diff/change/{{repo}}/{{logItem.changeset}}">
              <b>{{logItem.summary}}</b>
            </a>
          </span>
        </td>
      </tr>
    </tbody>
  </table>
  """
  scope:
    repo: '=repo'
    log: '=log'




m.directive 'hgLogSearch', ($filter) ->

  restrict: "E"
  replace: true
  template: """
  <form class="form-inline form-search" role="search">
    <div class="form-group">
      <label class="sr-only" for="hgLogSearchKeyword">Keyword</label>
      <input type="text" class="form-control" id="hgLogSearchKeyword" placeholder="Keyword">
    </div>
    <button type="submit" class="btn btn-default">Search</button>
  </form>
  """
  scope:
    repo: '=repo'
    log: '=log'




m.directive 'hgLogPagination', ($filter) ->
  restrict: "E"
  replace: true
  template: """
  <div>
    <pagination total-items="logCount"
    page="logPage"
    items-per-page="itemsPerPage"
    max-size="10"
    boundary-links="true"
    rotate="false"
    on-select-page="onSelectPage(page)">
    </pagination>
  </div>
  """
  scope:
    repo: '=repo'
    logPage: '=logPage'
    logCount: '=logCount'
    itemsPerPage: '=itemsPerPage'
    onSelectPage: '=onSelectPage'




m.directive 'hgManifest', ($filter) ->

  restrict: "E"
  replace: true
  template: '<pre>{{manifest}}</pre>'
  scope:
    manifest: '=manifest'




m.directive 'hgStatus', ($filter) ->

  restrict: "E"
  replace: true
  template: """
  <div>
    <table class="table table-condensed table-responsive table-hover">
        <tr ng-repeat="file in status | filter:statusFilter">
          <td class="angular-hg-filename angular-hg-status-{{file.status}}" >
            <a href="#/file/{{repo}}/{{file.filename}}">
              <i class="fa fa-fw fa-file-text-o"></i> {{file.filename}}
            </a>
          </td>
          <td>
            {{file.status}}
          </td>
        </tr>
    </table>
  </div>
  """
  scope:
    status: '=status'
    repo: '=repo'
    statusFilter: '=statusFilter'




m.directive 'hgSummary', ($filter) ->

  restrict: "E"
  replace: true
  template: """
  <div ng-cloak>
    <pre>{{summary}}</pre>
    <div class="alert alert-info" ng-show="summary.commit != '(clean)'">
      {{summary.commit}}
    </div>
  </div>
  """
  scope:
    summary: '=summary'




m.directive 'hgSummaryCommitAlert', ($filter) ->

  restrict: "E"
  replace: true
  template: """
  <div class="alert alert-info"
  ng-show="summary.commit && (summary.commit != '(clean)')">
    {{summary.commit}}
  </div>
  """
  scope:
    summary: '=summary'




m.directive 'hgSummaryUpdateAlert', ($filter) ->

  restrict: "E"
  replace: true
  template: """
  <div class="alert alert-info"
  ng-show="summary.commit && (summary.update != '(current)')">
    {{summary.update}}
  </div>
  """
  scope:
    summary: '=summary'


m.filter 'hgUser', () ->
  return (input) ->
    match = input.match /(.+) <(\w+@\w+\.\w+)>/

    if match
      # "<a ng-href='mailto:#{match[2]}'>#{match[1]}</a>"
      match[1]
    else
      input

