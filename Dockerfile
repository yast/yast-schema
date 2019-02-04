FROM yastdevel/ruby
RUN zypper --gpg-auto-import-keys --non-interactive in --no-recommends \
  autoyast2 \
  trang \
  yast2 \
  yast2-add-on \
  yast2-audit-laf \
  yast2-auth-client \
  yast2-auth-server \
  yast2-bootloader \
  yast2-country \
  yast2-dhcp-server \
  yast2-dns-server \
  yast2-firewall \
  yast2-firstboot \
  yast2-ftp-server \
  yast2-http-server \
  yast2-tftp-server \
  yast2-installation \
  yast2-iscsi-client \
  yast2-kdump \
  yast2-mail \
  yast2-network \
  yast2-nfs-client \
  yast2-nfs-server \
  yast2-nis-client \
  yast2-nis-server \
  yast2-ntp-client \
  yast2-online-update-configuration \
  yast2-printer \
  yast2-proxy \
  && zypper clean -a
COPY . /usr/src/app
