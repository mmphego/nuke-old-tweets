FROM python:3
ENV USERNAME=mmphego

# https://github.com/mmphego/semiphemeral
RUN pip install https://github.com/mmphego/semiphemeral/archive/master.zip

RUN useradd -m $USERNAME
USER $USERNAME
WORKDIR /home/$USERNAME
COPY .semiphemeral .semiphemeral
RUN echo "semiphemeral fetch && sleep 10 && semiphemeral delete" > script.sh
RUN echo "cat .semiphemeral/settings.json | jq 'del(.api_key,.api_secret,.access_token_key,.access_token_secret,.username,.user_id)'" >> script.sh

USER root
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME

USER $USERNAME
CMD [ "bash", "script.sh" ]
