#!/bin/sh

pidfile=`cat pid`
kill $pidfile

nohup hexo server &
echo $! > pid
