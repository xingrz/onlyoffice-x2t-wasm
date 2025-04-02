#!/usr/bin/env bash

embuild.sh UnicodeConverter
embuild.sh Common

# Link zlib into Common instead of including it in the build
sed -i -e 's/build_all_zlib//' \
    Common/kernel.pro
sed -i -e 's/build_zlib_as_sources//' \
    Common/kernel.pro

# Do not include zlib in the build, but link it later
sed -i -e 's,$$OFFICEUTILS_PATH/src/zlib[^ ]*\.c,,' \
    DesktopEditor/graphics/pro/raster.pri
sed -i -e 's,$$OFFICEUTILS_PATH/src/zlib[^ ]*\.c,,' \
    DesktopEditor/graphics/pro/freetype.pri

embuild.sh DesktopEditor/graphics/pro

# Do not include freetype in the build, but link it later
sed -i -e 's,$$FREETYPE_PATH/[^ ]*\.c,,' \
    DesktopEditor/graphics/pro/freetype.pri

embuild.sh TxtFile/Projects/Linux
embuild.sh OOXML/Projects/Linux/BinDocument
embuild.sh OOXML/Projects/Linux/DocxFormatLib
embuild.sh OOXML/Projects/Linux/PPTXFormatLib
embuild.sh OOXML/Projects/Linux/XlsbFormatLib
embuild.sh MsBinaryFile/Projects/VbaFormatLib/Linux
embuild.sh MsBinaryFile/Projects/DocFormatLib/Linux
embuild.sh MsBinaryFile/Projects/PPTFormatLib/Linux
embuild.sh MsBinaryFile/Projects/XlsFormatLib/Linux
embuild.sh OdfFile/Projects/Linux
embuild.sh RtfFile/Projects/Linux
embuild.sh Common/cfcpp
embuild.sh Common/3dParty/cryptopp/project
# embuild.sh Fb2File
embuild.sh Common/Network
embuild.sh --no-sanitize PdfFile
# embuild.sh HtmlFile2
# embuild.sh EpubFile
# embuild.sh XpsFile
# embuild.sh DjVuFile
# embuild.sh HtmlRenderer
embuild.sh -q "CONFIG+=doct_renderer_empty" DesktopEditor/doctrenderer
embuild.sh DocxRenderer

cat /wrap-main.cpp >> /core/X2tConverter/src/main.cpp
embuild.sh \
    -c -g \
    -l "-lgumbo" \
    -l "-lkatana" \
    -l "-L/usr/local/lib" \
    -l "--pre-js /pre-js.js" \
    -l "-sEXPORTED_RUNTIME_METHODS=ccall,FS" \
    -l "-sEXPORTED_FUNCTIONS=_main1" \
    -l "-sALLOW_MEMORY_GROWTH" \
    X2tConverter/build/Qt/X2tConverter.pro

cp /core/build/bin/linux_64/x2t* /out/
