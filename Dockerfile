FROM docker.io/library/ruby:2.6.7 as builder

RUN gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/ && \
     gem install ascii_binder
ADD . /root/uccps-docs/
WORKDIR /root/uccps-docs
USER 0
RUN asciibinder build
RUN    chmod -R 777 _preview

FROM  harbor.chinauos.com/utccp-samples/httpd-24:1.2.1

COPY --from=builder /root/uccps-docs/_preview/openshift-enterprise/main  /var/www/html
RUN cp /var/www/html/welcome/index.html /var/www/html
ADD productization /var/www/html/opt/productization
