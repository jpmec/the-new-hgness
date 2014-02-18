<?php



function hg_cli($cmd, $options)
{
    $options_str = ' ';

    foreach ($options as $key=>$value)
    {
        $options_str .= $key . ' ' . $value . ' ';
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




function hg_diff($options)
{
    $cli = hg_cli('diff', $options);

    $hg = shell_exec($cli);

    return $hg;
}




function hg_log($options)
{

    $cli = hg_cli('log', $options);

    $logs = shell_exec($cli);

    $lines = explode(PHP_EOL, $logs);

    $result = '';
    $log = array();
    foreach ($lines as $line)
    {
        if (0 < strlen($line))
        {
            $parts = explode(':', $line, 2);
            $log[trim($parts[0])] = trim($parts[1]);
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
            $parts = explode(' ', $line, 2);

            $status = trim($parts[0]);
            $file = trim($parts[1]);

            if ($status == 'C') {
                $result[$file] = 'clean';
            }
            elseif ($status == 'M') {
                $result[$file] = 'modified';
            }
            elseif ($status == 'A') {
                $result[$file] = 'added';
            }
            elseif ($status == 'R') {
                $result[$file] = 'removed';
            }
            elseif ($status == 'I') {
                $result[$file] = 'ignored';
            }
            elseif ($status == '!') {
                $result[$file] = 'missing';
            }
            elseif ($status == '?') {
                $result[$file] = 'untracked';
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




function hg_version($options)
{
    $cli = hg_cli('version', $options);

    $hg = shell_exec($cli);

    return $hg;
}
