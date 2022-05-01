ARG PYTHON_VERSION
FROM python:${PYTHON_VERSION}
RUN useradd --create-home --shell /bin/nologin \
    --system --home-dir /app app
WORKDIR /app
COPY --chown=app:app ./requirements.txt /app/
RUN pip install -r /app/requirements.txt; \
    mkdir -p /app/static; \
    chown -R app:app /app/static
COPY --chown=app:app . /app/
ENV DEBUG=True
USER app
EXPOSE 8000
CMD [ "./manage.py", "runserver", "0.0.0.0:8000" ]
