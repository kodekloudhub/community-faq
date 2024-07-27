# Configure Nginx + PHP-FPM Using Unix Sock

IMPORTANT: Various parameters highlighted below in the question may be different each time you reset the lab. As such the solution below is tailored to this particular instance of the question. You must change it accordingly with what your version of the question asks for.


## Question

The Nautilus application development team is planning to launch a new PHP-based application, which they want to deploy on Nautilus infra in Stratos DC. The development team had a meeting with the production support team and they have shared some requirements regarding the infrastructure. Below are the requirements they shared:



a. Install nginx on `app server 2` , configure it to use port `8094` and its document root should be `/var/www/html`.


b. Install php-fpm version `7.4` on `app server 2`, it must use the unix socket `/var/run/php-fpm/default.sock` (create the parent directories if don't exist).


c. Configure php-fpm and nginx to work together.


d. Once configured correctly, you can test the website using `curl http://stapp02:8094/index.php` command from jump host.

## Solution

1. SSH to the app server requested - it may be a different app server for you.

    ```bash
    ssh steve@stapp02
    ```

1. Become root to save typing `sudo` on every command

    ```bash
    sudo -i
    ```

1. Install `ngnix` and `php-fpm`

    ```bash
    dnf install -y nginx
    dnf module -y install php:8.1/common
    ```

1.  Configure php-fpm

    1. Edit `/etc/php-fpm.d/www.conf` with vi.
    1. Edit the `user =` and `group =` lines to both use `nginx` instead of `apache`.
    1. Edit the `listen =` line to refer the path to the socket given in the question.
    1. Save and exit
    1. Set directory permissions on php files to nginx group
        ```bash
        chown -R root:nginx /var/lib/php
        ```

1. Configure nginx

    1. Open `/etc/nginx/nginx.conf` in vi
    1. Set given port number (which may be different for you)
    1. Set given HTML directory
    1. Set location block for PHP files.
    1. The `server` configuration should look like this when completed

        ```text
            server {
                listen       8094 default_server;
                listen       [::]:8094 default_server;
                server_name  _;
                root         /var/www/html;

                # Load configuration files for the default server block.
                include /etc/nginx/default.d/*.conf;

                location / {
                }

                # Add this location configuration
                location ~ \.php$ {
                    try_files $uri =404;
                    fastcgi_pass php-fpm;
                    fastcgi_index index.php;
                    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                    include fastcgi_params;
                }

                error_page 404 /404.html;
                    location = /40x.html {
                }

                error_page 500 502 503 504 /50x.html;
                    location = /50x.html {
                }
            }
        ```
1. Configure php-fpm nginx module

    1. Open `/etc/nginx/conf.d/php-fpm.conf` in vi
    1. Edit the path to the socket to match that in the question

1. Restart services

    ```bash
    systemctl restart php-fpm
    systemctl restart nginx
    ```

1. curl test

    ```bash
    curl http://stapp02:8094/index.php
    ```

1. Return to jump host and curl test from there

    ```text
    [steve@stapp02 ~]$ exit
    logout
    Connection to stapp02 closed.
    thor@jump_host ~$ curl http://stapp02:8094/index.php
    Welcome to xFusionCorp Industries!thor@jump_host ~$
    ```
