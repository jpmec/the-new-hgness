<?php

set_include_path('lib');

require 'hg.php';
require 'Slim/Slim.php';



\Slim\Slim::registerAutoloader();


$app = new \Slim\Slim();
$app->response->headers->set('Content-Type', 'application/json; charset=UTF-8');


$app->config(array(
    'root' => "/Users/Josh/Projects/"
));



$app->get(
    '/diff/change/:repo_id/:change',
    function ($repo_id, $change) use ($app) {

        $root_dir = $app->config('root');

        $dir = $root_dir . $repo_id;


        $hg = hg_diff(array(
            "--cwd" => $dir,
            "--change" => $change
        ));

        $result = array(
            "repo" => $repo_id,
            "change" => $change,
            "diff" => $hg
        );

        echo html_entity_decode(json_encode($result));
    }
);





$app->get(
    '/repos',
    function () use ($app) {

        $root_dir = $app->config('root');


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

        echo html_entity_decode(json_encode($result));

    }
);




$app->get(
    '/repo/:repo_id',
    function ($repo_id) use ($app) {

        $root_dir = $app->config('root');

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
            "branchesCount" => count($branches),
            "tags" => $tags,
            "tagsCount" => count($tags),
            "summary" => $summary,
            "manifest" => $manifest,
            "status" => $status,
            "statusCount" => count($status),
            "log" => $log,
            "logCount" => count($log)
        );

        echo html_entity_decode(json_encode($result));

    }
);




$app->get(
    '/repo_files/:repo_id',
    function ($repo_id) use ($app) {

        $root_dir = $app->config('root');

        $dir = $root_dir . $repo_id;

        $status = hg_status(array(
            "--cwd" => $dir,
            "--all" => ""
        ));

        $result = array(
            "id" => $repo_id,
            "status" => $status,
            "statusCount" => count($status)
        );

        echo html_entity_decode(json_encode($result));

    }
);




$app->get(
    '/repo_logs/:repo_id',
    function ($repo_id) use ($app) {

        $root_dir = $app->config('root');
        $dir = $root_dir . $repo_id;

        $rev = $app->request()->get('rev');
        if (is_null($rev))
        {
            $rev = 'tip:0';
        }

        $keywords = $app->request()->get('keywords');

        $tip = hg_log(array(
            "--cwd" => $dir,
            "--rev" => 'tip'
        ));


        $options = array(
            "--cwd" => $dir,
            "--rev" => $rev
        );

        if (!is_null($keywords))
        {
            $options["--keyword"] = $keywords;
        }

        $log = hg_log($options);

        $result = array(
            "id" => $repo_id,
            "tip" => $tip,
            "log" => $log,
            "rev" => $rev,
            "logCount" => count($log)
        );

        echo html_entity_decode(json_encode($result));

    }
);




$app->get(
    '/manifest/:repo_id/:rev',
    function ($repo_id, $rev) use ($app) {

        $root_dir = $app->config('root');

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

        echo html_entity_decode(json_encode($result));

    }
);




$app->get(
    '/file/:repo_id/:file_name',
    function ($repo_id, $file_name) use ($app) {

        $root_dir = $app->config('root');
        $dir = $root_dir . $repo_id;

        $options = array(
            "--cwd" => $dir
        );

        $result = array(
            'file' => array(
                'name' => $file_name,
                'repo' => $repo_id
            )
        );

        $rev = $app->request()->get('rev');

        if (!is_null($rev))
        {
            $options['--rev'] = $rev;
            $result['file']['rev'] = $rev;
        }

        $hg = hg_cat($options, $file_name);

        $result['file'] = array_merge($result['file'], $hg);

        echo html_entity_decode(json_encode($result));

    }
);




$app->get(
    '/hg_version',
    function () use ($app) {

        $hg = hg_version(null);

        $result = array(
            "version" => $hg
        );

        echo html_entity_decode(json_encode($result));

    }
);




$app->run();
