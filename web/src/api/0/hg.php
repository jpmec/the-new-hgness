<?php

date_default_timezone_set('America/Chicago');


function hg_cli($cmd, $options)
{

//    $num_args = func_num_args();
//    $args = func_get_args();


    $options_str = '';
    if (!is_null($options))
    {
        $options_str = ' ';

        foreach ($options as $key=>$value)
        {
            $options_str .= $key . ' ' . $value . ' ';
        }
    }

    return '/opt/local/bin/hg ' . $cmd . $options_str;
}




function hg_annotate($options)
{
    $cli = hg_cli('annotate', $options);

    $hg = shell_exec($cli);

    return $hg;
}




function hg_branches($options)
{
    $cli = hg_cli('branches', $options);

    $hg = shell_exec($cli);

    return $hg;
}




function hg_cat($options, $file)
{
    $cli = hg_cli('cat', $options);

    $cli .= ' ' . $file;

    $hg = shell_exec($cli);

    $lines = explode(PHP_EOL, $hg);

    $result = array('lines' => $lines);

    return $result;
}




function hg_diff($options)
{
    $cli = hg_cli('diff', $options);

    $hg = shell_exec($cli);

    $lines = explode(PHP_EOL, $hg);

    $result = array(
        'raw' => $hg,
        'files' => array()
    );


    $file = null;
    $hunk = null;
    foreach ($lines as $line)
    {
        $matches = array();
        if (preg_match ('/^diff (.*) (.*) (.*) (.*) (.*)$/', $line, $matches))
        {
            if (!is_null($file))
            {
                $result['files'][] = $file;
            }

            $file = array(
                'name' => $matches[5],
                'hunks' => array()
            );
        }

        else if (preg_match ('/^--- (.*)\t(.*)$/', $line, $matches))
        {
            $file['from-file'] = $matches[1];
            $file['from-file-modification-time'] = strtotime($matches[2]);
        }

        else if (preg_match ('/^\+\+\+ (.*)\t(.*)$/', $line, $matches))
        {
            $file['to-file'] = $matches[1];
            $file['to-file-modification-time'] = strtotime($matches[2]);
        }

        else if (preg_match ('/^@@ -(.*),(.*) \+(.*),(.*) @@$/', $line, $matches))
        {
            if (!is_null($hunk))
            {
                $file['hunks'][] = $hunk;
            }

            $hunk = array(
                'lines' => array()
            );

            $hunk['from-file-line-number'] = $matches[1];
            $hunk['from-file-line-count'] = $matches[2];
            $hunk['to-file-line-number'] = $matches[3];
            $hunk['to-file-line-count'] = $matches[4];
        }

        // else if (preg_match ('/^\+(.*)$/'))
        // {
        //     $hunk['lines'][] = $line;
        // }

        else
        {
            if (preg_match('/^\s*\+\s*(.*)$/', $line, $matches))
            {
                $hunk['lines'][] = array('text' => $line, 'status' => 'added');
            }
            elseif (preg_match('/^\s*-\s*(.*)$/', $line, $matches))
            {
                $hunk['lines'][] = array('text' => $line, 'status' => 'removed');
            }
            else
            {
                $hunk['lines'][] = array('text' => $line, 'status' => 'same');
            }
        }

    }

    if (!is_null($hunk))
    {
        $file['hunks'][] = $hunk;
    }

    if (!is_null($file))
    {
        $result['files'][] = $file;
    }

    return $result;
}




function hg_identify($options)
{
    $cli = hg_cli('identify', $options);

    $hg = shell_exec($cli);

    return $hg;
}




function hg_log($options)
{
    $cli = hg_cli('log', $options);

    $hg = shell_exec($cli);

    $lines = explode(PHP_EOL, $hg);

    $result = array();
    $log = array();
    foreach ($lines as $line)
    {
        if (0 < strlen($line))
        {
            $parts = explode(':', $line, 2);

            $key = trim($parts[0]);
            $value = trim($parts[1]);

            if ($key == "date")
            {
                $log[$key] = strtotime($value) * 1000;
            }
            elseif ($key == "changeset")
            {
                $parts = explode(':', $value);

                $log['rev'] = trim($parts[0]);
                $log['nodeid'] = trim($parts[1]);
                $log[$key] = $value;
            }
            else
            {
                $log[$key] = $value;
            }
        }
        else
        {
            if (count($log))
            {
                $result[] = $log;
            }
            $log = array();
        }
    }

    $resultCount = count($result);
    if (0 == $resultCount)
    {
        return null;
    }
    elseif(1 == $resultCount)
    {
        return $result[0];
    }
    else
    {
        return $result;
    }
}




function hg_manifest($options)
{
    $cli = hg_cli('manifest', $options);

    $hg = shell_exec($cli);

    return $hg;
}




function hg_status($options)
{
    $cli = hg_cli('status', $options);

    $hg = shell_exec($cli);

    $lines = explode(PHP_EOL, $hg);

    $result = array();
    foreach ($lines as $line)
    {
        if (0 < strlen($line))
        {
            $status_array = array();

            $parts = explode(' ', $line, 2);

            $status = trim($parts[0]);
            $filename = trim($parts[1]);

            $status_array['filename'] = $filename;

            if ($status == 'C') {
                $status_array['status'] = 'clean';
            }
            elseif ($status == 'M') {
                $status_array['status'] = 'modified';
            }
            elseif ($status == 'A') {
                $status_array['status'] = 'added';
            }
            elseif ($status == 'R') {
                $status_array['status'] = 'removed';
            }
            elseif ($status == 'I') {
                $status_array['status'] = 'ignored';
            }
            elseif ($status == '!') {
                $status_array['status'] = 'missing';
            }
            elseif ($status == '?') {
                $status_array['status'] = 'untracked';
            }

            $result[] = $status_array;
        }
    }

    return $result;
}




function hg_summary($options)
{
    $cli = hg_cli('summary', $options);

    $hg = shell_exec($cli);

    $lines = explode(PHP_EOL, $hg);

    $result = array('messages' => array());
    foreach ($lines as $line)
    {
        if (0 < strlen($line))
        {
            $parts = explode(':', $line, 2);

            if (1 < count($parts))
            {
                $key = trim($parts[0]);
                $value = trim($parts[1]);

                $result[$key] = $value;
            }
            else
            {

                $result['messages'][] = $line;
            }
        }
    }

    return $result;
}




function hg_tags($options)
{
    $cli = hg_cli('tags', $options);

    $hg = shell_exec($cli);

    return $hg;
}




function hg_verify($options)
{
    $cli = hg_cli('verify', $options);

    $hg = shell_exec($cli);

    return $hg;
}




function hg_version($options)
{
    $cli = hg_cli('version', $options);

    $hg = shell_exec($cli);

    return $hg;
}
