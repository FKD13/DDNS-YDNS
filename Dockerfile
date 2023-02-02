FROM thevlang/vlang:alpine

COPY main.v .

RUN v -enable-globals main.v -o ddns-ydns

CMD [ "ddns-ydns" ]