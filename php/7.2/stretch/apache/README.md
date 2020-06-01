PHP 7.2 container image
================

This container image includes PHP 7.2 as a base image for your PHP 7.2 applications.

Description
-----------

PHP 7.2 available as container is a base platform for
running various PHP 7.2 applications and frameworks.
PHP is an HTML-embedded scripting language. PHP attempts to make it easy for developers 
to write dynamically generated web pages. PHP also offers built-in database integration 
for several commercial and non-commercial database management systems, so writing 
a database-enabled webpage with PHP is fairly simple. The most common use of PHP coding 
is probably as a replacement for CGI scripts.

Environment variables
---------------------

The following environment variables set their equivalent property value in the opcache.ini file:
* **OPCACHE_ENABLE**
  * Determines if Zend OPCache is enabled.
  * Default: 1
* **OPCACHE_MEMORY_CONSUMPTION**
  * The OPcache shared memory storage size in megabytes.
  * Default: 128
* **OPCACHE_INTERNED_STRINGS_BUFFER**
  * The amount of memory for interned strings in Mbytes.
  * Default: 8  
* **OPCACHE_MAX_ACCELERATED_FILES**
  * The maximum number of keys (scripts) in the OPcache hash table. Only numbers between 200 and 1000000 are allowed.
  * Default: 4000
* **OPCACHE_VALIDATE_TIMESTAMPS**
  * When disabled, you must reset the OPcache manually or restart the webserver for changes to the filesystem to take effect.
  * Default: 0  
* **OPCACHE_REVALIDATE_FREQ**
  * How often to check script timestamps for updates, in seconds. 0 will result in OPcache checking for updates on every request.
  * Default: 2
* **OPCACHE_FAST_SHUTDOWN**
  * If enabled, a fast shutdown sequence is used for the accelerated code, Depending on the used Memory Manager this may cause some incompatibilities.
  * Default: 2  


You can override the Apache settings of the PHP application. You can override this at any time by 
specifying the values yourself:
* **HTTPD_DOCUMENT_ROOT**
  * Path that defines the DocumentRoot for your application (ie. /public)
  * Default: /


You can override the Apache [MPM prefork](https://httpd.apache.org/docs/2.4/mod/mpm_common.html)
settings to increase the performance for of the PHP application. In case you set
some Cgroup limits, the image will attempt to automatically set the
optimal values. You can override this at any time by specifying the values
yourself:
* **HTTPD_START_SERVERS**
  * The [StartServers](https://httpd.apache.org/docs/2.4/mod/mpm_common.html#startservers)
    directive sets the number of child server processes created on startup.
  * Default: 8
* **HTTPD_MAX_REQUEST_WORKERS**
  * The [MaxRequestWorkers](https://httpd.apache.org/docs/2.4/mod/mpm_common.html#maxrequestworkers)
    directive sets the limit on the number of simultaneous requests that will be served.
  * `MaxRequestWorkers` was called `MaxClients` before version httpd 2.3.13.
  * Default: 256 (this is automatically tuned by setting Cgroup limits for the container using this formula:
    `TOTAL_MEMORY / 15MB`. The 15MB is average size of a single httpd process.


Source repository layout
------------------------

You do not need to change anything in your existing PHP project's repository.
However, if these files exist they will affect the behavior of the build process:

* **.htaccess**

  In case the **DocumentRoot** of the application is nested within the source directory `/opt/app-root/src`,
  users can provide their own Apache **.htaccess** file.  This allows the overriding of Apache's behavior and
  specifies how application requests should be handled. The **.htaccess** file needs to be located at the root
  of the application source.


Extending image
---------------
Not only content, but also startup scripts and configuration of the image can
be extended.

The structure of the application can look like this:

| Folder name       | Description                |
|-------------------|----------------------------|
| `/usr/share/container-scripts/php`| Can contain shell scripts (`*.sh`) that are sourced before `httpd` is started|
| `./`              | Application source code |


Security Implications
---------------------

-p 8080:8080

     Opens  container  port  8080  and  maps it to the same port on the Host.