# qt5-base                 5.15.18#1        Qt Base provides the basic non-GUI functionality required by all Qt applic...
# qt5-base[cups]                            Provides support for the Common Unix Printing System
# qt5-base[mysqlplugin]                     Build the sql plugin for connecting to mysql databases
# qt5-base[openssl]                         Build with OpenSSL support
# qt5-base[postgresqlplugin]                Build the sql plugin for connecting to postgresql databases
# qt5-base[sqlite3plugin]                   Build the sql plugin for connecting to sqlite3 databases
# qt5-base[vulkan]                          Enable Vulkan support in QtGui
# qt5-base[zstd]                            Zstandard support
# & "vcpkg" install "qt5-base[mysqlplugin, openssl, postgresqlplugin, sqlite3plugin, vulkan]"
# QT5 extras?
# qt5[all]                                  Install all Qt5 submodules (Warning: Could take a long time and fail...)
# charts,
# connectivity,
# datavis3d,
# declarative,
# doc,
# essentials, #                           Build the essential qt modules
# gamepad,
# qt5[location]
# qt5[mqtt]
# qt5[purchasing]
# qt5[quickcontrols2]
# qt5[remoteobjects]
# qt5[scxml]
# qt5[sensors]
# qt5[serialbus]
# qt5[serialport]
# & "vcpkg" install "qt5[3d, activeqt, essentials, extras, graphicaleffects, imageformats, multimedia, networkauth, speech, svg, tools, translations, virtualkeyboard, webchannel, webengine, webglplugin, websockets, webview]"

# opencv4                  4.12.0#1         Open Source Computer Vision Library
# opencv4[ade]                              graph api
# opencv4[aravis]                           aravis
# opencv4[calib3d]                          calib3d module
# opencv4[carotene]                         carotene module
# opencv4[contrib]                          opencv_contrib module
# opencv4[cuda]                             CUDA support for opencv
# opencv4[cudnn]                            cuDNN support for opencv
# opencv4[dc1394]                           Dc1394 support for opencv
# opencv4[directml]                         Build with DirectML support
# opencv4[dnn]                              Enable dnn module
# opencv4[dnn-cuda]                         Build dnn module with CUDA support
# opencv4[dshow]                            Enable DirectShow
# opencv4[eigen]                            Eigen support for opencv
# opencv4[ffmpeg]                           ffmpeg support for opencv
# opencv4[freetype]                         Freetype support for opencv
# opencv4[fs]                               Enable filesystem support
# opencv4[gapi]                             Enable gapi module
# opencv4[gdcm]                             GDCM support for opencv
# opencv4[gstreamer]                        gstreamer support for opencv
# opencv4[gtk]                              GTK support for opencv
# opencv4[halide]                           Halide support for opencv
# opencv4[hdf]                              Enable Hierarchical Data Format (hdf) I/O
# opencv4[highgui]                          highgui module
# opencv4[intrinsics]                       Enable intrinsics
# opencv4[ipp]                              Enable Intel Integrated Performance Primitives
# opencv4[jpeg]                             JPEG support for opencv
# opencv4[jpegxl]                           JPEGXL support for opencv
# opencv4[msmf]                             Microsoft Media Foundation support for opencv
# opencv4[nonfree]                          allow nonfree and unredistributable libraries
# opencv4[opencl]                           Enable opencl support
# opencv4[openexr]                          OpenEXR support for opencv
# opencv4[opengl]                           opengl support for opencv
# opencv4[openjpeg]                         JPEG 2000 support for opencv
# opencv4[openmp]                           Enable OpenMP support
# opencv4[openvino]                         OpenVINO support for OpenCV DNN
# opencv4[ovis]                             opencv_ovis module
# opencv4[png]                              PNG support for opencv
# opencv4[python]                           Python wrapper support for opencv
# opencv4[qt]                               Qt GUI support for opencv
# opencv4[quality]                          Build opencv_quality module
# opencv4[quirc]                            Enable QR code module
# opencv4[rgbd]                             Build opencv_rgbd module
# opencv4[sfm]                              opencv_sfm module
# opencv4[tbb]                              Enable Intel Threading Building Blocks
# opencv4[text]                             Enable Scene Text Detection and Recognition
# opencv4[thread]                           Enable thread support
# opencv4[tiff]                             TIFF support for opencv
# opencv4[vtk]                              vtk support for opencv
# opencv4[vulkan]                           Vulkan support for opencv dnn
# opencv4[webp]                             WebP support for opencv
# opencv4[win32ui]                          Enable win32ui
# opencv4[world]                            Compile to a single package support for opencvbabl                     0.1.118          A pixel encoding and color space conversion engine.
# babl[cmyk-icc]                            Support CMYK ICC profiles.
# babl[introspection]                       Enable introspection

& vcpkg install "opencv4[ipp, jpeg, msmf, nonfree, opencl, opengl, openjpeg, openmp, ovis, png, python, qt, rgbd, tbb, text, thread, tiff, vulkan, webp, win32ui]"
