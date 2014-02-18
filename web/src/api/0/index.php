<?php

set_include_path('lib');

require 'hg.php';
require 'Slim/Slim.php';



\Slim\Slim::registerAutoloader();


$app = new \Slim\Slim();




$app->get(
    '/diff/change/:repo_id/:change',
    function ($repo_id, $change) use ($app) {

    $root_dir = "/Users/Josh/Projects/";

    $dir = $root_dir . $repo_id;


    $hg = hg_diff(array(
        "--cwd" => $dir,
        "--change" => $change
    ));

    $result = array(
        "id" => $repo_id,
        "change" => $change,
        "diff" => $hg
    );

    echo json_encode($result);

});





$app->get(
    '/repos',
    function () use ($app) {

    $root_dir = "/Users/Josh/Projects/";


    //$result = scandir($root_dir);

    $fullpaths = glob($root_dir . "**/" . ".hg");

    foreach ($fullpaths as $fullpath)
    {
        $dir = dirname($fullpath);
        $project_name = basename($dir);

        $log = hg_log(array(
            "--cwd" => $dir,
            "--limit" => 1
        ));


        $summary = hg_summary(array(
            "--cwd" => $dir
        ));

        $result[] = array(
            "projectName" => $project_name,
            "dir" => $dir,
            "summary" => $summary,
            "log" => $log
        );
    }

    echo json_encode($result);

});




$app->get(
    '/repo/:repo_id',
    function ($repo_id) use ($app) {

    $root_dir = "/Users/Josh/Projects/";

    $dir = $root_dir . $repo_id;

    // $summary = hg_summary($dir, null);

    // $result = array(
    //     "projectName" => $repo_id,
    //     "dir" => $dir,
    //     "summary" => $summary
    // );

    $branches = hg_branches(array(
        "--cwd" => $dir
    ));

    $tags = hg_tags(array(
        "--cwd" => $dir
    ));

    $summary = hg_summary(array(
        "--cwd" => $dir
    ));


    $log = hg_log(array(
        "--cwd" => $dir
    ));


    $manifest = hg_manifest(array(
        "--cwd" => $dir
    ));


    $status = hg_status(array(
        "--cwd" => $dir,
        "--all" => ""
    ));

    $result = array(
        "id" => $repo_id,
        "branches" => $branches,
        "tags" => $tags,
        "summary" => $summary,
        "manifest" => $manifest,
        "status" => $status,
        "log" => $log
    );

    echo json_encode($result);

});








$app->get(
    '/manifest/:repo_id/:rev',
    function ($repo_id, $rev) use ($app) {

    $root_dir = "/Users/Josh/Projects/";

    $dir = $root_dir . $repo_id;


    $hg = hg_manifest(array(
        "--cwd" => $dir,
        "--rev" => $rev
    ));

    $result = array(
        "id" => $repo_id,
        "rev" => $rev,
        "manifest" => $hg
    );

    echo json_encode($result);

});




$app->run();