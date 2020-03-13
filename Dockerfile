FROM python:3
ENV USERNAME=mmphego
RUN apt-get update -q && \
    apt-get install -qq -y \
    jq && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf  /var/cache/apt/archives/
# https://github.com/mmphego/semiphemeral
RUN pip install https://github.com/mmphego/semiphemeral/archive/master.zip

RUN useradd -m $USERNAME
USER $USERNAME
WORKDIR /home/$USERNAME
COPY .semiphemeral /home/$USERNAME/.semiphemeral
RUN pwd && ls -la /home/$USERNAME/.semiphemeral
RUN cat /home/$USERNAME/.semiphemeral/settings.json
RUN echo "cat /home/$USERNAME/.semiphemeral/settings.json | jq 'del(.api_key,.api_secret,.access_token_key,.access_token_secret,.username,.user_id)'" > script.sh
RUN echo "semiphemeral fetch && sleep 10 && semiphemeral delete" >> script.sh

USER root
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME

USER $USERNAME
CMD [ "bash", "script.sh" ]
