import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Defines customizable styling options for folder elements in the directory tree.
class FolderStyle {
  /// Icon displayed when the folder is closed.
  final dynamic folderClosedicon;

  /// Icon displayed when the folder is opened.
  final dynamic folderOpenedicon;

  /// Text style applied to folder names.
  final TextStyle? folderNameStyle;

  /// Icon used for the "create new folder" action.
  final dynamic iconForCreateFolder;

  /// Icon used for the "create new file" action within a folder.
  final dynamic iconForCreateFile;

  /// Icon used for the "delete folder" action.
  final dynamic iconForDeleteFolder;

  /// Icon for root folder closed state.
  final dynamic rootFolderClosedIcon;

  /// Icon for root folder open state.
  final dynamic rootFolderOpenedIcon;

  /// Gap between items.
  final double itemGap;

  /// Constructs a [FolderStyle] with customizable icons and text styles.
  FolderStyle({
    this.itemGap = 15,
    this.rootFolderClosedIcon = const Icon(Icons.chevron_right_sharp),
    this.rootFolderOpenedIcon = const Icon(Icons.keyboard_arrow_down_sharp),
    this.folderNameStyle = const TextStyle(),
    this.iconForCreateFolder = const Icon(Icons.create_new_folder),
    this.iconForCreateFile = const Icon(
      FontAwesomeIcons.fileCirclePlus,
      size: 20,
    ),
    this.iconForDeleteFolder = const Icon(Icons.delete),
    this.folderClosedicon = const Icon(Icons.folder),
    this.folderOpenedicon = const Icon(Icons.folder_open),
  });
}

/// Defines customizable styling options for file elements in the directory tree.
class FileStyle {
  /// Default file icon.
  /// Applied when no custom icon is provided via fileIconBuilder.
  final dynamic fileIcon;

  /// [TextStyle] for file tile title.
  final TextStyle? fileNameStyle;

  /// Icon for delete button if it is enabled.
  final dynamic iconForDeleteFile;

  /// Constructs a [FileStyle] with customizable icons and text styles.
  FileStyle({
    this.fileNameStyle = const TextStyle(),
    this.fileIcon = const Icon(Icons.insert_drive_file),
    this.iconForDeleteFile = const Icon(Icons.delete),
  });
}

class EditingFieldStyle {
  /// Leading icon/widget displayed while creating new folder.
  final dynamic folderIcon;

  /// Leading icon/widget displayed while creating new file.
  final dynamic fileIcon;

  /// [InputDecoration] for [TextField] which appears while creating new file/folder.
  final InputDecoration textfieldDecoration;

  /// Icon for done button.
  final dynamic doneIcon;

  /// Icon for cancel button.
  final dynamic cancelIcon;

  /// Height of the text field.
  final double textFieldHeight;

  /// Width of the text field.
  final double textFieldWidth;

  /// Cursor color.
  final Color? cursorColor;

  /// Height of the cursor.
  final double cursorHeight;

  /// Width of the cursor.
  final double cursorWidth;

  /// Cursor radius.
  final Radius? cursorRadius;

  /// Text (Cursor) vertical alignment
  final TextAlignVertical? verticalTextAlign;

  /// [TextStyle] for text in the text filed.
  final TextStyle? textStyle;

  ///Custom styling for the [TextField] for creating files/folders.
  EditingFieldStyle({
    this.textFieldHeight = 30,
    this.textFieldWidth = double.infinity,
    this.cursorHeight = 20,
    this.cursorWidth = 2.0,
    this.cursorRadius,
    this.cursorColor,
    this.verticalTextAlign,
    this.textStyle,
    this.textfieldDecoration = const InputDecoration(),
    this.folderIcon = const Icon(Icons.folder),
    this.fileIcon = const Icon(Icons.edit_document),
    this.doneIcon = const Icon(Icons.check),
    this.cancelIcon = const Icon(Icons.close),
  });
}
