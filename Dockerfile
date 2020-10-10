FROM centos:centos7

# composer設定
ENV PATH="$PATH:/opt/composer/vendor/bin"
ENV COMPOSER_HOME="/usr/bin/composer"
# composer update、install時のメモリ上限を無効化
ENV COMPOSER_MEMORY_LIMIT=-1
ENV TZ='Asia/Tokyo'

# マルチステージビルド
# composer 公式イメージからcomposerを移植
COPY --from=composer:1.10.13 /usr/bin/composer /usr/bin/composer

RUN yum update -y \
  # 基本パッケージのインストール
  && yum install -y vim wget git openssh-server \
  # php用のリポジトリ登録
  && rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
  && rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm \
  # php依存パッケージのインストール
  && yum install -y gcc gcc-c++ make libtool httpd openssl-devel autoconf zlib-devel systemd-sysv automake pcre-devel krb5-devel libxslt libxml2-devel libedit-devel python-setuptools \
  # 標準リポジトリを無効化、remiリポジトリを有効化してphpをインストール
  && yum install -y --disablerepo=* --enablerepo=epel,remi,remi-php72 php php-fpm php-cli php-common php-devel php-mbstring php-pear php-pecl-apcu php-soap php-xml php-xmlrpc php-zip php-pdo php-mysql php-mysqlnd supervisor \
  # xdebugのインストール
  && pecl install xdebug-2.9.8 \
  # アプリケーションマウントポイント作成
  && mkdir /var/www/app/ && chmod 775 -R /var/www/ \
  # supervisorの設定
  && curl -o /etc/rc.d/init.d/supervisord https://raw.githubusercontent.com/Supervisor/initscripts/master/redhat-init-equeffelec \
  && chmod 755 /etc/rc.d/init.d/supervisord \
  # ルートログインの有効化(ノーパス)
  && sed -i -e 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config \
  && sed -i -e 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config \
  && sed -i -e 's/#PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config \
  && passwd -d root \
  && usermod -a -G root apache \
  && chmod u+x /etc/rc.local \
  && chmod u+x /etc/rc.d/rc.local \
  && systemctl enable php-fpm \
  && systemctl enable supervisord \
  && rm -rf /var/cache/yum/* \
  && yum clean all

COPY ./conf/supervisor/supervisor /etc/logrotate.d/supervisor
COPY ./conf/supervisor/sample.ini /etc/supervisord.d/sample.ini

EXPOSE 22
EXPOSE 80
EXPOSE 9000
EXPOSE 9001

WORKDIR /var/www/app/public

CMD ["/sbin/init"]
