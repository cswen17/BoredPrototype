FROM cswen17/teudu:latest
MAINTAINER Connie Wen <connie.s.wen@gmail.com>
WORKDIR /home
RUN git clone https://github.com/cswen17/BoredPrototype.git
WORKDIR /home/BoredPrototype
RUN bundle install
RUN bundle exec rake db:migrate
