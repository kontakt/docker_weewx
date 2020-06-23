FROM python:3.7.7 AS build-env
COPY setup /tmp/setup/
ENV WEEWX_VERSION 4.1.1
RUN ls -la /tmp/setup/ && \
	/tmp/setup/setup.sh && \
	rm -rf /tmp/setup 
	
FROM discolix/python
ENV LIB_PATH /usr/lib/aarch64-linux-gnu

# copy Weewx install
COPY --from=build-env /home/weewx /home/weewx

# copy python dependencies
COPY --from=build-env /usr/local/lib/python3.7/site-packages/ /usr/lib/python3.7/site-packages/

# copy dependencies
COPY --from=build-env $LIB_PATH/libjpeg.so* $LIB_PATH/
COPY --from=build-env $LIB_PATH/libopenjp2.so* $LIB_PATH/
COPY --from=build-env $LIB_PATH/libtiff.so* $LIB_PATH/
COPY --from=build-env $LIB_PATH/libpng16.so* $LIB_PATH/
COPY --from=build-env $LIB_PATH/libxcb.so* $LIB_PATH/
COPY --from=build-env $LIB_PATH/libwebp.so* $LIB_PATH/
COPY --from=build-env $LIB_PATH/libzstd.so* $LIB_PATH/ 
COPY --from=build-env $LIB_PATH/libjbig.so* $LIB_PATH/
COPY --from=build-env $LIB_PATH/libX*.so* $LIB_PATH/
COPY --from=build-env $LIB_PATH/libbsd.so* $LIB_PATH/
COPY --from=build-env $LIB_PATH/libfreetype.so* $LIB_PATH/
COPY --from=build-env /usr/local/lib/libpython3.7m.so* /usr/lib/
ENV PYTHONPATH=/usr/lib/python3.7/site-packages
CMD ["/home/weewx/bin/weewxd"]