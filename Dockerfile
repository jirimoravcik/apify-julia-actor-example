FROM julia:1.7.1-alpine

WORKDIR /app
COPY . .

RUN julia install.jl

CMD ["julia", "main.jl"]
