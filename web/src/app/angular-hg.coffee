

m = angular.module "angular-hg", []



m.directive 'hgDiff', ($filter) ->
  restrict: "E"
  replace: true
  scope:
    diff: '=diff'

  template: """
  <pre>{{diff}}</pre>
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

