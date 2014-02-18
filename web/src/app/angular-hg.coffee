

m = angular.module "angular-hg", []




m.directive 'hgLog', ($filter) ->

  restrict: "E"
  replace: true
  template: """
  <table class="table table-condensed table-responsive">
      <tr ng-repeat="logItem in log">
        <td><span class="label label-info" ng-show="logItem.tag"><i class="fa fa-tag fa-fw"></i> {{logItem.tag}}</span></td>
        <td class="angular-hg-tag">{{logItem.changeset}}</td>
        <td>{{logItem.date}}</td>
        <td>{{logItem.user}}</td>
        <td>{{logItem.summary}}</td>
      </tr>
  </table>
  """
  scope:
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
  <table class="table table-condensed table-responsive">
      <tr ng-repeat="(file, fileStatus) in status">
        <td class="angular-hg-filename angular-hg-status-{{fileStatus}}" >
          {{file}}
        </td>
        <td>
          {{fileStatus}}
        </td>
      </tr>
  </table>
  """
  scope:
    status: '=status'




m.directive 'hgSummary', ($filter) ->

  restrict: "E"
  replace: true
  template: """
  <div ng-cloak>
  <pre>{{summary}}</pre>
  <div class="alert alert-info" ng-show="summary.commit != '(clean)'">{{summary.commit}}</div>
  </div>
  """
  scope:
    summary: '=summary'




m.directive 'hgSummaryCommitAlert', ($filter) ->

  restrict: "E"
  replace: true
  template: """
  <div class="alert alert-info" ng-show="summary.commit && (summary.commit != '(clean)')">{{summary.commit}}</div>
  """
  scope:
    summary: '=summary'




m.directive 'hgSummaryUpdateAlert', ($filter) ->

  restrict: "E"
  replace: true
  template: """
  <div class="alert alert-info" ng-show="summary.commit && (summary.update != '(current)')">{{summary.update}}</div>
  """
  scope:
    summary: '=summary'

