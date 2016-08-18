#!/bin/sh

pid=`cat pidfile`
kill $pid

nohup hexo server &
echo $! > pidfile
