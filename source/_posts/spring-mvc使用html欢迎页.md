---
title: Spring MVC 使用html静态页面做欢迎页
date: 2017/06/09 13:20:00
categories: 技术
tags: spring
---
最近的一个项目做了前后端的分离，前端使用vuejs+elementUI+webpack,后端使用spring mvc，但是蛋疼的需要部署到一个tomcat上。所以有了以下辗转反侧的配置过程，简单做下记录。

spring mvc 使用欢迎页面一般的方式是直接在controller中拦截根目录（/）渲染jsp或者其他模板页面做欢迎页，但是这个前后端分离的项目并不合适。

网上查了一些方案，大同小异

## 方案1：`web.xml` 欢迎页导向servlet

```xml
<welcome-file-list>
<welcome-file>index</welcome-file>
</welcome-file-list>
```
这种方案与之前提到的servlet拦截大同小异，没有什么本质区别。

## 方案2：default-servlet

1. 在spring配置中添加default-servlet-handler

```xml
 <mvc:default-servlet-handler/>
```

这种配置之后静态目录不需要单独配置，当controller中没有相应访问目录的mapping时，自动使用tomcat容器的servlet进行处理。即webapp为根目录的方式。


## 参考

[What is the need and use of <mvc:default-servlet-handler />](https://stackoverflow.com/questions/31346267/what-is-the-need-and-use-of-mvcdefault-servlet-handler)
[spring文档中的说明](http://docs.spring.io/spring/docs/current/spring-framework-reference/html/mvc.html#mvc-default-servlet-handler)
