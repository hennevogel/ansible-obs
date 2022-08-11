FROM registry.opensuse.org/obs/server/unstable/containers/containers/openbuildservice/ansible-obs-base:latest

ARG USER_ID=1000
ARG GROUP_ID=100
ARG USER_NAME=foo

RUN useradd -l -u ${USER_ID} -g ${GROUP_ID} --home-dir /home/${USER_NAME} --create-home ${USER_NAME}
RUN ln -sf /home/${USER_NAME}/ansible-obs/tmp/bash_history /home/${USER_NAME}/.bash_history

USER ${USER_NAME}
WORKDIR /home/${USER_NAME}/ansible-obs

ADD Gemfile /home/${USER_NAME}/ansible-obs
ADD Gemfile.lock /home/${USER_NAME}/ansible-obs

RUN bundle.ruby3.1 config set --local path 'vendor/bundle'; \
    bundle.ruby3.1 config build.nokogiri --use-system-libraries; \
    bundle.ruby3.1 install --jobs=4 --retry=3; \
    bundle.ruby3.1 binstubs --all

ENTRYPOINT ["bash", "-l"]
