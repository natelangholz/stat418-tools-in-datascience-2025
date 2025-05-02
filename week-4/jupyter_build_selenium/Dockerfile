FROM quay.io/jupyter/minimal-notebook

COPY ./requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER