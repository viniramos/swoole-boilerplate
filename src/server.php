#!/usr/bin/env php

<?php

require_once 'vendor/autoload.php';

use Siler\Swoole;

$server = fn() => Swoole\emit('Hello World');

Swoole\http($server)->start();