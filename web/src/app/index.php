<!DOCTYPE html>
<html lang="en" ng-app="TheNewHgnessApp">

  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>The New Hgness</title>

    <?php include('index_css.php') ?>
  </head>

  <body>

    <?php include('index_navbar.php') ?>
    <div class="container">

      <ng-view></ng-view>

    </div>

    <?php include('index_scripts.php') ?>
  </body>

</html>
