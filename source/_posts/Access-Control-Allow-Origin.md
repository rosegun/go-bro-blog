---
title: Access-Control-Allow-Origin 作用方式
date: 2016/08/23 13:20:00
categories: 技术
tags: http
---

`Access-Control-Allow-Origin` 是一个html5中添加的CORS(Cross-Origin Resource Sharing)头

跨域访问时，B站点 通过在响应头中添加
`Access-Control-Allow-Origin:http://siteA` 向浏览器表示该资源可被A站点正常访问使用。除非添加了`Access-Control-Allow-Origin`响应头，否则默认情况下一个站点的资源不允许来自于其他域的任何XMLHttpRequest请求。

对于B站点任意页面或者资源，如果想要允许被A站点访问，则应在页面或者资源请求的响应中添加相应头：
`Access-Control-Allow-Origin: http://siteA.com`

#### *Simple*请求

现代浏览器不会完全阻止跨域请求。如果A站点请求B站点的一个*页面P*，浏览器实际上会在网络级拉取*页面P*，然后检查*页面P*响应头中A站点是否在允许列表中。如果响应中没有声明A站点具有访问权限，则浏览器会触发`XMLHttpRequest's error`事件，并且阻止响应数据的执行。

#### *Non-Simple* 请求

真实发生的网络级请求实际上会稍微复杂一点。如果一个请求是*Non-Simple*的，浏览器首先会发送一个不包含数据的`OPTIONS` http请求，以此来验证服务器是否接受该站点的相应请求（GET,POST,PUT..etg.），一个*Simple*的请求需要同时满足以下两点：

* 只能使用HTTP的`GET`,`POST`或者`HEAD`方法
* 只能使用*Simple*的请求头：
  * `Accept`
  * `Accept-Language`
  * `Content-Language`
  * `Last-Event-ID`
  * `Content-Type` (*Simple*的请求定义中，content-type只能是`application/x-www-form-urlencoded`, `multipart/form-data`,或者 `text/plain`)

不符合这种情况的请求则是一个*Non-Simple*的请求，除此之外的http方法和http头叫做*Non-Simple*方法和头

如果服务端对`OPTIONS`预请求的响应中包含了恰当的`Non-Simple`响应头(`Access-Control-Allow-Headers`,`Access-Control-Allow-Methods`),并且响应头的值中包含了真实要发生的请求的*Non-Simple*请求头和方法，浏览器才会继续发送真正的*Non-Simple*请求。

假设一个如下场景：
> 站点A向站点B的`/somePage`页面发送一个`PUT`请求，`Content-Type`是`application/json`

浏览器会现发送一个`OPTIONS`预请求：
```
OPTIONS /somePage HTTP/1.1
Origin: http://siteA.com
Access-Control-Request-Method: PUT
Access-Control-Request-Headers: Content-Type
```
`Access-Control-Request-Method`,`Access-Control-Request-Header`这两个请求头是浏览器根据真实请求自动生成的。正常获取到的响应是如下的形式：
```
Access-Control-Allow-Origin: http://siteA.com
Access-Control-Allow-Methods: GET, POST, PUT
Access-Control-Allow-Headers: Content-Type
```
判断响应服务端支持真实请求，则真实请求方式与之前提到的*Simple*请求方式相同，这个过程中会重新检查响应报文是否包含`Access-Control-Allow-Origin`响应头

真实请求：
```
PUT /somePage HTTP/1.1
Origin: http://siteA.com
Content-Type: application/json

{ "myRequestContent": "JSON is so great" }
```

服务端响应头：
`Access-Control-Allow-Origin: http://siteA.com`

原文：[How does Access-Control-Allow-Origin header work?](http://stackoverflow.com/questions/10636611/how-does-access-control-allow-origin-header-work)

参考：
* [Using CORS](http://www.html5rocks.com/en/tutorials/cors/)
* [Understanding XMLHttpRequest over CORS](http://stackoverflow.com/a/13400954/710446)







