################################################################################
#
# opencv4
#
################################################################################

OPENCV4_VERSION = 4.9.0
OPENCV4_SITE = $(call github,opencv,opencv,$(OPENCV4_VERSION))
OPENCV4_INSTALL_STAGING = YES
OPENCV4_LICENSE = Apache-2.0
OPENCV4_LICENSE_FILES = LICENSE
OPENCV4_CPE_ID_VENDOR = opencv
OPENCV4_CPE_ID_PRODUCT = opencv
OPENCV4_SUPPORTS_IN_SOURCE_BUILD = NO

OPENCV4_CXXFLAGS = $(TARGET_CXXFLAGS)

# Uses __atomic_fetch_add_4
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
OPENCV4_CXXFLAGS += -latomic
endif

# Fix c++11 build with missing std::exception_ptr
ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_64735),y)
OPENCV4_CXXFLAGS += -DCV__EXCEPTION_PTR=0
endif

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_68485),y)
OPENCV4_CXXFLAGS += -O0
endif

# OpenCV component options
OPENCV4_CONF_OPTS += \
	-DCMAKE_CXX_FLAGS="$(OPENCV4_CXXFLAGS)" \
	-DBUILD_DOCS=OFF \
	-DBUILD_PERF_TESTS=$(if $(BR2_PACKAGE_OPENCV4_BUILD_PERF_TESTS),ON,OFF) \
	-DBUILD_TESTS=$(if $(BR2_PACKAGE_OPENCV4_BUILD_TESTS),ON,OFF) \
	-DBUILD_WITH_DEBUG_INFO=OFF \
	-DDOWNLOAD_EXTERNAL_TEST_DATA=OFF \
	-DOPENCV_GENERATE_PKGCONFIG=ON \
	-DOPENCV_ENABLE_PKG_CONFIG=ON

ifeq ($(BR2_PACKAGE_OPENCV4_BUILD_TESTS)$(BR2_PACKAGE_OPENCV4_BUILD_PERF_TESTS),)
OPENCV4_CONF_OPTS += -DINSTALL_TEST=OFF
else
OPENCV4_CONF_OPTS += -DINSTALL_TEST=ON
endif

# OpenCV build options
OPENCV4_CONF_OPTS += \
	-DBUILD_WITH_STATIC_CRT=OFF \
	-DENABLE_CCACHE=OFF \
	-DENABLE_COVERAGE=OFF \
	-DENABLE_FAST_MATH=ON \
	-DENABLE_IMPL_COLLECTION=OFF \
	-DENABLE_NOISY_WARNINGS=OFF \
	-DENABLE_OMIT_FRAME_POINTER=ON \
	-DENABLE_PRECOMPILED_HEADERS=OFF \
	-DENABLE_PROFILING=OFF \
	-DOPENCV_WARNINGS_ARE_ERRORS=OFF

# OpenCV link options
OPENCV4_CONF_OPTS += \
	-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=OFF \
	-DCMAKE_SKIP_RPATH=OFF \
	-DCMAKE_USE_RELATIVE_PATHS=OFF

# OpenCV packaging options:
OPENCV4_CONF_OPTS += \
	-DBUILD_PACKAGE=OFF \
	-DENABLE_SOLUTION_FOLDERS=OFF \
	-DINSTALL_CREATE_DISTRIB=OFF

# OpenCV module selection
# * Modules on:
#   - core: if not set, opencv does not build anything
#   - hal: core's dependency
# * Modules off:
#   - android*: android stuff
#   - apps: programs for training classifiers
#   - java: java bindings
#   - viz: missing VTK dependency
#   - world: all-in-one module
#
OPENCV4_CONF_OPTS += \
	-DBUILD_opencv_androidcamera=OFF \
	-DBUILD_opencv_apps=OFF \
	-DBUILD_opencv_calib3d=$(if $(BR2_PACKAGE_OPENCV4_LIB_CALIB3D),ON,OFF) \
	-DBUILD_opencv_core=ON \
	-DBUILD_opencv_dnn=$(if $(BR2_PACKAGE_OPENCV4_LIB_DNN),ON,OFF) \
	-DBUILD_opencv_features2d=$(if $(BR2_PACKAGE_OPENCV4_LIB_FEATURES2D),ON,OFF) \
	-DBUILD_opencv_flann=$(if $(BR2_PACKAGE_OPENCV4_LIB_FLANN),ON,OFF) \
	-DBUILD_opencv_highgui=$(if $(BR2_PACKAGE_OPENCV4_LIB_HIGHGUI),ON,OFF) \
	-DBUILD_opencv_imgcodecs=$(if $(BR2_PACKAGE_OPENCV4_LIB_IMGCODECS),ON,OFF) \
	-DBUILD_opencv_imgproc=$(if $(BR2_PACKAGE_OPENCV4_LIB_IMGPROC),ON,OFF) \
	-DBUILD_opencv_java=OFF \
	-DBUILD_opencv_ml=$(if $(BR2_PACKAGE_OPENCV4_LIB_ML),ON,OFF) \
	-DBUILD_opencv_objdetect=$(if $(BR2_PACKAGE_OPENCV4_LIB_OBJDETECT),ON,OFF) \
	-DBUILD_opencv_photo=$(if $(BR2_PACKAGE_OPENCV4_LIB_PHOTO),ON,OFF) \
	-DBUILD_opencv_shape=$(if $(BR2_PACKAGE_OPENCV4_LIB_SHAPE),ON,OFF) \
	-DBUILD_opencv_stitching=$(if $(BR2_PACKAGE_OPENCV4_LIB_STITCHING),ON,OFF) \
	-DBUILD_opencv_superres=$(if $(BR2_PACKAGE_OPENCV4_LIB_SUPERRES),ON,OFF) \
	-DBUILD_opencv_ts=$(if $(BR2_PACKAGE_OPENCV4_LIB_TS),ON,OFF) \
	-DBUILD_opencv_video=$(if $(BR2_PACKAGE_OPENCV4_LIB_VIDEO),ON,OFF) \
	-DBUILD_opencv_videoio=$(if $(BR2_PACKAGE_OPENCV4_LIB_VIDEOIO),ON,OFF) \
	-DBUILD_opencv_videostab=$(if $(BR2_PACKAGE_OPENCV4_LIB_VIDEOSTAB),ON,OFF) \
	-DBUILD_opencv_viz=OFF \
	-DBUILD_opencv_world=OFF

# Hardware support options.
#
# * PowerPC and VFPv3 support are turned off since their only effects
#   are altering CFLAGS, adding '-mcpu=G3 -mtune=G5' or '-mfpu=vfpv3'
#   to them, which is already handled by Buildroot.
# * NEON logic is needed as it is not only used to add CFLAGS, but
#   also to enable additional NEON code.
OPENCV4_CONF_OPTS += \
	-DENABLE_POWERPC=OFF \
	-DENABLE_NEON=$(if $(BR2_ARM_CPU_HAS_NEON),ON,OFF) \
	-DENABLE_VFPV3=OFF

# Cuda stuff
OPENCV4_CONF_OPTS += \
	-DBUILD_CUDA_STUBS=OFF \
	-DBUILD_opencv_cudaarithm=OFF \
	-DBUILD_opencv_cudabgsegm=OFF \
	-DBUILD_opencv_cudacodec=OFF \
	-DBUILD_opencv_cudafeatures2d=OFF \
	-DBUILD_opencv_cudafilters=OFF \
	-DBUILD_opencv_cudaimgproc=OFF \
	-DBUILD_opencv_cudalegacy=OFF \
	-DBUILD_opencv_cudaobjdetect=OFF \
	-DBUILD_opencv_cudaoptflow=OFF \
	-DBUILD_opencv_cudastereo=OFF \
	-DBUILD_opencv_cudawarping=OFF \
	-DBUILD_opencv_cudev=OFF \
	-DWITH_CUBLAS=OFF \
	-DWITH_CUDA=OFF \
	-DWITH_CUFFT=OFF

# NVidia stuff
OPENCV4_CONF_OPTS += -DWITH_NVCUVID=OFF

# AMD stuff
OPENCV4_CONF_OPTS += \
	-DWITH_OPENCLAMDBLAS=OFF \
	-DWITH_OPENCLAMDFFT=OFF

# Intel stuff
OPENCV4_CONF_OPTS += \
	-DBUILD_WITH_DYNAMIC_IPP=OFF \
	-DWITH_INTELPERC=OFF \
	-DWITH_IPP=OFF \
	-DWITH_IPP_A=OFF

# Smartek stuff
OPENCV4_CONF_OPTS += -DWITH_GIGEAPI=OFF

# Prosilica stuff
OPENCV4_CONF_OPTS += -DWITH_PVAPI=OFF

# Ximea stuff
OPENCV4_CONF_OPTS += -DWITH_XIMEA=OFF

# Non-Linux support (Android options) must remain OFF:
OPENCV4_CONF_OPTS += \
	-DANDROID=OFF \
	-DBUILD_ANDROID_CAMERA_WRAPPER=OFF \
	-DBUILD_ANDROID_EXAMPLES=OFF \
	-DBUILD_ANDROID_SERVICE=OFF \
	-DBUILD_FAT_JAVA_LIB=OFF \
	-DINSTALL_ANDROID_EXAMPLES=OFF \
	-DWITH_ANDROID_CAMERA=OFF

# Non-Linux support (Mac OSX options) must remain OFF:
OPENCV4_CONF_OPTS += \
	-DWITH_AVFOUNDATION=OFF \
	-DWITH_CARBON=OFF \
	-DWITH_QUICKTIME=OFF

# Non-Linux support (Windows options) must remain OFF:
OPENCV4_CONF_OPTS += \
	-DWITH_CSTRIPES=OFF \
	-DWITH_DSHOW=OFF \
	-DWITH_MSMF=OFF \
	-DWITH_VFW=OFF \
	-DWITH_VIDEOINPUT=OFF \
	-DWITH_WIN32UI=OFF

# Software/3rd-party support options:
# - disable all examples
OPENCV4_CONF_OPTS += \
	-DBUILD_EXAMPLES=OFF \
	-DBUILD_JASPER=OFF \
	-DBUILD_JPEG=OFF \
	-DBUILD_OPENEXR=OFF \
	-DBUILD_OPENJPEG=OFF \
	-DBUILD_PNG=OFF \
	-DBUILD_PROTOBUF=OFF \
	-DBUILD_TIFF=OFF \
	-DBUILD_ZLIB=OFF \
	-DINSTALL_C_EXAMPLES=OFF \
	-DINSTALL_PYTHON_EXAMPLES=OFF \
	-DINSTALL_TO_MANGLED_PATHS=OFF

# Disabled features (mostly because they are not available in Buildroot)
OPENCV4_CONF_OPTS += \
	-DWITH_1394=OFF \
	-DWITH_CLP=OFF \
	-DWITH_GDAL=OFF \
	-DWITH_GPHOTO2=OFF \
	-DWITH_GSTREAMER_0_10=OFF \
	-DWITH_LAPACK=OFF \
	-DWITH_MATLAB=OFF \
	-DWITH_OPENCL=OFF \
	-DWITH_OPENCL_SVM=OFF \
	-DWITH_OPENEXR=OFF \
	-DWITH_OPENNI2=OFF \
	-DWITH_OPENNI=OFF \
	-DWITH_UNICAP=OFF \
	-DWITH_VA=OFF \
	-DWITH_VA_INTEL=OFF \
	-DWITH_VTK=OFF \
	-DWITH_XINE=OFF

OPENCV4_DEPENDENCIES += host-pkgconf zlib

ifeq ($(BR2_PACKAGE_OPENCV4_CONTRIB),y)
# OPENCV4 depends on OPENCV4_CONTRIB, and not the other way around.
# The modules in OPENCV4_CONTRIB get built as part of the build
# process for OPENCV4, so the source needs to be unpacked already
OPENCV4_DEPENDENCIES += opencv4-contrib
OPENCV4_CONF_OPTS += \
	-DOPENCV_EXTRA_MODULES_PATH=$(OPENCV4_CONTRIB_DIR)/modules \
	-DBUILD_opencv_alphamat=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_ALPHAMAT),ON,OFF) \
	-DBUILD_opencv_aruco=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_ARUCO),ON,OFF) \
	-DBUILD_opencv_barcode=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_BARCODE),ON,OFF) \
	-DBUILD_opencv_bgsegm=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_BGSEGM),ON,OFF) \
	-DBUILD_opencv_bioinspired=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_BIOINSPIRED),ON,OFF) \
	-DBUILD_opencv_ccalib=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_CCALIB),ON,OFF) \
	-DBUILD_opencv_cnn_3dobj=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_CNN_3DOBJ),ON,OFF) \
	-DBUILD_opencv_cvv=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_CVV),ON,OFF) \
	-DBUILD_opencv_datasets=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_DATASETS),ON,OFF) \
	-DBUILD_opencv_dnn_objdetect=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_DNN_OBJDETECT),ON,OFF) \
	-DBUILD_opencv_dnn_superres=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_DNN_SUPERRES),ON,OFF) \
	-DBUILD_opencv_dnns_easily_fooled=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_DNNS_EASILY_FOOLED),ON,OFF) \
	-DBUILD_opencv_dpm=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_DPM),ON,OFF) \
	-DBUILD_opencv_face=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_FACE),ON,OFF) \
	-DBUILD_opencv_freetype=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_FREETYPE),ON,OFF) \
	-DBUILD_opencv_fuzzy=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_FUZZY),ON,OFF) \
	-DBUILD_opencv_hdf=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_HDF),ON,OFF) \
	-DBUILD_opencv_hfs=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_HFS),ON,OFF) \
	-DBUILD_opencv_img_hash=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_IMG_HASH),ON,OFF) \
	-DBUILD_opencv_intensity_transform=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_INTENSITY_TRANSFORM),ON,OFF) \
	-DBUILD_opencv_julia=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_JULIA),ON,OFF) \
	-DBUILD_opencv_line_descriptor=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_LINE_DESCRIPTOR),ON,OFF) \
	-DBUILD_opencv_matlab=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_MATLAB),ON,OFF) \
	-DBUILD_opencv_mcc=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_MCC),ON,OFF) \
	-DBUILD_opencv_optflow=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_OPTFLOW),ON,OFF) \
	-DBUILD_opencv_ovis=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_OVIS),ON,OFF) \
	-DBUILD_opencv_phase_unwrapping=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_PHASE_UNWRAPPING),ON,OFF) \
	-DBUILD_opencv_plot=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_PLOT),ON,OFF) \
	-DBUILD_opencv_quality=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_QUALITY),ON,OFF) \
	-DBUILD_opencv_rapid=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_RAPID),ON,OFF) \
	-DBUILD_opencv_reg=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_REG),ON,OFF) \
	-DBUILD_opencv_rgbd=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_RGBD),ON,OFF) \
	-DBUILD_opencv_saliency=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_SALIENCY),ON,OFF) \
	-DBUILD_opencv_sfm=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_SFM),ON,OFF) \
	-DBUILD_opencv_shape=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_SHAPE),ON,OFF) \
	-DBUILD_opencv_stereo=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_STEREO),ON,OFF) \
	-DBUILD_opencv_structured_light=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_STRUCTURED_LIGHT),ON,OFF) \
	-DBUILD_opencv_superres=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_SUPERRES),ON,OFF) \
	-DBUILD_opencv_surface_matching=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_SURFACE_MATCHING),ON,OFF) \
	-DBUILD_opencv_text=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_TEXT),ON,OFF) \
	-DBUILD_opencv_tracking=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_TRACKING),ON,OFF) \
	-DBUILD_opencv_videostab=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_VIDEOSTAB),ON,OFF) \
	-DBUILD_opencv_viz=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_VIZ),ON,OFF) \
	-DBUILD_opencv_wechat_qrcode=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_WECHAT_QRCODE),ON,OFF) \
	-DBUILD_opencv_xfeatures2d=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_XFEATURES2D),ON,OFF) \
	-DBUILD_opencv_ximgproc=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_XIMGPROC),ON,OFF) \
	-DBUILD_opencv_xobjdetect=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_XOBJDETECT),ON,OFF) \
	-DBUILD_opencv_xphoto=$(if $(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_XPHOTO),ON,OFF)
endif

ifeq ($(BR2_PACKAGE_OPENCV4_CONTRIB_LIB_SFM),y)
OPENCV4_DEPENDENCIES += eigen glog gflags
OPENCV4_CONF_OPTS += -DWITH_EIGEN=ON
endif

ifeq ($(BR2_PACKAGE_OPENCV4_JPEG2000_WITH_JASPER),y)
OPENCV4_CONF_OPTS += -DWITH_JASPER=ON
OPENCV4_DEPENDENCIES += jasper
else
OPENCV4_CONF_OPTS += -DWITH_JASPER=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV4_JPEG2000_WITH_OPENJPEG),y)
OPENCV4_CONF_OPTS += -DWITH_OPENJPEG=ON
OPENCV4_DEPENDENCIES += openjpeg
else
OPENCV4_CONF_OPTS += -DWITH_OPENJPEG=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV4_WITH_FFMPEG),y)
OPENCV4_CONF_OPTS += -DWITH_FFMPEG=ON
OPENCV4_DEPENDENCIES += ffmpeg bzip2
else
OPENCV4_CONF_OPTS += -DWITH_FFMPEG=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV4_WITH_GSTREAMER1),y)
OPENCV4_CONF_OPTS += -DWITH_GSTREAMER=ON
OPENCV4_DEPENDENCIES += gstreamer1 gst1-plugins-base
else
OPENCV4_CONF_OPTS += -DWITH_GSTREAMER=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV4_WITH_GTK)$(BR2_PACKAGE_OPENCV4_WITH_GTK3),)
OPENCV4_CONF_OPTS += -DWITH_GTK=OFF -DWITH_GTK_2_X=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV4_WITH_GTK),y)
OPENCV4_CONF_OPTS += -DWITH_GTK=ON -DWITH_GTK_2_X=ON
OPENCV4_DEPENDENCIES += libgtk2
endif

ifeq ($(BR2_PACKAGE_OPENCV4_WITH_GTK3),y)
OPENCV4_CONF_OPTS += -DWITH_GTK=ON -DWITH_GTK_2_X=OFF
OPENCV4_DEPENDENCIES += libgtk3
endif

ifeq ($(BR2_PACKAGE_OPENCV4_WITH_JPEG),y)
OPENCV4_CONF_OPTS += -DWITH_JPEG=ON
OPENCV4_DEPENDENCIES += jpeg
else
OPENCV4_CONF_OPTS += -DWITH_JPEG=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV4_WITH_OPENGL),y)
OPENCV4_CONF_OPTS += -DWITH_OPENGL=ON
OPENCV4_DEPENDENCIES += libgl
else
OPENCV4_CONF_OPTS += -DWITH_OPENGL=OFF
endif

OPENCV4_CONF_OPTS += -DWITH_OPENMP=$(if $(BR2_TOOLCHAIN_HAS_OPENMP),ON,OFF)

ifeq ($(BR2_PACKAGE_OPENCV4_WITH_PNG),y)
OPENCV4_CONF_OPTS += -DWITH_PNG=ON
OPENCV4_DEPENDENCIES += libpng
else
OPENCV4_CONF_OPTS += -DWITH_PNG=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV4_WITH_PROTOBUF),y)
OPENCV4_CONF_OPTS += \
	-DPROTOBUF_UPDATE_FILES=ON \
	-DWITH_PROTOBUF=ON
OPENCV4_DEPENDENCIES += protobuf
else
OPENCV4_CONF_OPTS += -DWITH_PROTOBUF=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV4_WITH_QT5),y)
OPENCV4_CONF_OPTS += -DWITH_QT=5
OPENCV4_DEPENDENCIES += qt5base
else
OPENCV4_CONF_OPTS += -DWITH_QT=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV4_WITH_TBB),y)
OPENCV4_CONF_OPTS += -DWITH_TBB=ON
OPENCV4_DEPENDENCIES += tbb
else
OPENCV4_CONF_OPTS += -DWITH_TBB=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV4_WITH_TIFF),y)
OPENCV4_CONF_OPTS += -DWITH_TIFF=ON
OPENCV4_DEPENDENCIES += tiff
else
OPENCV4_CONF_OPTS += -DWITH_TIFF=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV4_WITH_V4L),y)
OPENCV4_CONF_OPTS += \
	-DWITH_LIBV4L=$(if $(BR2_PACKAGE_LIBV4L),ON,OFF) \
	-DWITH_V4L=ON
OPENCV4_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBV4L),libv4l)
else
OPENCV4_CONF_OPTS += -DWITH_V4L=OFF -DWITH_LIBV4L=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV4_WITH_WEBP),y)
OPENCV4_CONF_OPTS += -DWITH_WEBP=ON
OPENCV4_DEPENDENCIES += webp
else
OPENCV4_CONF_OPTS += -DWITH_WEBP=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV4_LIB_PYTHON),y)
OPENCV4_CONF_OPTS += \
	-DBUILD_opencv_python2=OFF \
	-DBUILD_opencv_python3=ON \
	-DPYTHON3_EXECUTABLE=$(HOST_DIR)/bin/python3 \
	-DPYTHON3_INCLUDE_PATH=$(STAGING_DIR)/usr/include/python$(PYTHON3_VERSION_MAJOR) \
	-DPYTHON3_LIBRARIES=$(STAGING_DIR)/usr/lib/libpython$(PYTHON3_VERSION_MAJOR).so \
	-DPYTHON3_NUMPY_INCLUDE_DIRS=$(STAGING_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages/numpy/core/include \
	-DPYTHON3_PACKAGES_PATH=/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages \
	-DPYTHON3_NUMPY_VERSION=$(PYTHON_NUMPY_VERSION)
OPENCV4_DEPENDENCIES += python3
OPENCV4_KEEP_PY_FILES += usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages/cv2/config*.py
OPENCV4_CONF_ENV += $(PKG_PYTHON_SETUPTOOLS_ENV)
OPENCV4_DEPENDENCIES += python-numpy
else
OPENCV4_CONF_OPTS += \
	-DBUILD_opencv_python2=OFF \
	-DBUILD_opencv_python3=OFF
endif

# Installation hooks:
define OPENCV4_CLEAN_INSTALL_LICENSE
	$(RM) -fr $(TARGET_DIR)/usr/share/licenses/opencv4
endef
OPENCV4_POST_INSTALL_TARGET_HOOKS += OPENCV4_CLEAN_INSTALL_LICENSE

define OPENCV4_CLEAN_INSTALL_VALGRIND
	$(RM) -f $(TARGET_DIR)/usr/share/opencv4/valgrind*
endef
OPENCV4_POST_INSTALL_TARGET_HOOKS += OPENCV4_CLEAN_INSTALL_VALGRIND

ifneq ($(BR2_PACKAGE_OPENCV4_INSTALL_DATA),y)
define OPENCV4_CLEAN_INSTALL_DATA
	$(RM) -fr $(TARGET_DIR)/usr/share/opencv4/haarcascades \
		$(TARGET_DIR)/usr/share/opencv4/lbpcascades
endef
OPENCV4_POST_INSTALL_TARGET_HOOKS += OPENCV4_CLEAN_INSTALL_DATA
endif

$(eval $(cmake-package))
