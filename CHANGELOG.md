## 0.0.1
* Initial release

## 0.0.2
* Added KisWeb to detect and prevent webapps

## 0.0.3
* Minor Changes

## 0.0.4
* Added Create and delete file/folder option and optional action buttons

## 0.0.5
* Updated documentation

## 0.0.6
* Pub point error on 0.0.5

## 0.0.7
* Added onFileSecondaryTap and onDirSecondaryTap callbacks for handling right-click events on files and directories respectively.

* Modified existing onFileTap and onDirTap callbacks to include TapDownDetails as a parameter, providing more context about the tap event.

* Wrapped file and directory widgets with GestureDetector to enable these new tap interactions.

* Added MouseRegion to provide visual feedback (click cursor) on hover for files and directories.

* Imported flutter/gestures.dart for TapDownDetails.