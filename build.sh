#!/usr/bin/env bash

dobuild.sh UnicodeConverter
dobuild.sh Common
dobuild.sh DesktopEditor/graphics/pro
dobuild.sh TxtFile/Projects/Linux
dobuild.sh OOXML/Projects/Linux/BinDocument
dobuild.sh OOXML/Projects/Linux/DocxFormatLib
dobuild.sh OOXML/Projects/Linux/PPTXFormatLib
dobuild.sh OOXML/Projects/Linux/XlsbFormatLib
dobuild.sh MsBinaryFile/Projects/VbaFormatLib/Linux
dobuild.sh MsBinaryFile/Projects/DocFormatLib/Linux
dobuild.sh MsBinaryFile/Projects/PPTFormatLib/Linux
dobuild.sh MsBinaryFile/Projects/XlsFormatLib/Linux
dobuild.sh OdfFile/Projects/Linux
dobuild.sh RtfFile/Projects/Linux
dobuild.sh Common/cfcpp
dobuild.sh Common/3dParty/cryptopp/project
# dobuild.sh Fb2File
dobuild.sh Common/Network
dobuild.sh --no-sanitize PdfFile
# dobuild.sh HtmlFile2
# dobuild.sh EpubFile
# dobuild.sh XpsFile
# dobuild.sh DjVuFile
# dobuild.sh HtmlRenderer
dobuild.sh -q "CONFIG+=doct_renderer_empty" DesktopEditor/doctrenderer
dobuild.sh DocxRenderer

cat /wrap-main.cpp >> /core/X2tConverter/src/main.cpp
dobuild.sh \
    -c -g \
    -l "-lgumbo" \
    -l "-lkatana" \
    -l "-L/usr/local/lib" \
    X2tConverter/build/Qt/X2tConverter.pro

cp /usr/local/lib/libicuuc.so.58 /usr/local/lib/libicudata.so.58 build/lib/linux_64
