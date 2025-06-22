import 'dart:async';
import 'dart:io';
import 'package:file_tree_view/style.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

late bool isParentOpen;
String? currentDir;

class DirectoryTreeViewer extends StatelessWidget {
  /// The root path of the directory to display.
  final String rootPath;

  /// Initial state of the [DirectoryTreeViewer].
  /// isUnfoldedFirst = true by defualt
  final bool isUnfoldedFirst;

  /// Enables folder creation option
  final bool enableCreateFolderOption;

  /// Enables file creation option
  final bool enableCreateFileOption;

  ///Enables folder deletion option
  final bool enableDeleteFolderOption;

  /// Enables file deletion option
  final bool enableDeleteFileOption;

  /// Customizable folder styling
  final FolderStyle? folderStyle;

  /// Customizable file styling
  final FileStyle? fileStyle;

  /// Custom styling for text editing field.
  final EditingFieldStyle? editingFieldStyle;

  /// Callback function when a file is tapped. Accepts a [File] and [TapDownDetails] as parameters.
  final void Function(File, TapDownDetails)? onFileTap;

  /// Callback function when a file is right-clicked.
  final void Function(File, TapDownDetails)? onFileSecondaryTap;

  /// Callback function when a directory is tapped.
  final void Function(Directory, TapDownDetails)? onDirTap;

  /// Callback function when a directory is right-clicked.
  final void Function(Directory, TapDownDetails)? onDirSecondaryTap;

  ///Additional folder action widgets
  final List<Widget>? folderActions;

  ///Additional file action widgets
  final List<Widget>? fileActions;

  /// A function that returns a custom file icon based on the file extension.
  final Widget Function(String fileExtension)? fileIconBuilder;

  /// Constructs a [DirectoryTreeViewer] with the given properties.
  const DirectoryTreeViewer({
    super.key,
    required this.rootPath,
    this.onFileTap,
    this.onFileSecondaryTap,
    this.onDirTap,
    this.onDirSecondaryTap,
    this.folderActions,
    this.fileActions,
    this.folderStyle,
    this.fileStyle,
    this.isUnfoldedFirst = true,
    this.editingFieldStyle,
    this.enableCreateFileOption = false,
    this.enableCreateFolderOption = false,
    this.enableDeleteFileOption = false,
    this.enableDeleteFolderOption = false,
    this.fileIconBuilder,
  });

  @override
  Widget build(BuildContext context) {
    /// Check if the platform is Web or WASM, and display a message if it is.
    if (kIsWasm || kIsWeb) {
      return const AlertDialog(title: Text("Web platform is not supported"));
    }
    isParentOpen = isUnfoldedFirst;
    return DirectoryTreeStateProvider(
      notifier: DirectoryTreeStateNotifier(),
      child: FoldableDirectoryTree(
        folderStyle: folderStyle,
        fileStyle: fileStyle,
        editingFieldStyle: editingFieldStyle,
        enableCreateFolderOption: enableCreateFolderOption,
        enableCreateFileOption: enableCreateFileOption,
        enableDeleteFileOption: enableDeleteFileOption,
        enableDeleteFolderOption: enableDeleteFolderOption,
        folderActions: folderActions,
        fileActions: fileActions,
        rootPath: rootPath,
        onFileTap: onFileTap,
        onFileSecondaryTap: onFileSecondaryTap,
        onDirTap: onDirTap,
        onDirSecondaryTap: onDirSecondaryTap,
        fileIconBuilder: fileIconBuilder,
      ),
    );
  }
}

/// Manages the state of the directory tree, handling folder expansion and file operations.
class DirectoryTreeStateNotifier extends ChangeNotifier {
  ///// Tracks open/close state of folders
  final Map<String, bool> _folderStates = {};

  /// Path of the new entry being created
  String? newEntryPath;

  /// Flag to determine if new entry is a folder
  bool isFolderCreation = false;

  ///Watches for file system changes
  StreamSubscription<FileSystemEvent>? _directoryWatcher;

  /// Checks if a folder is expanded or collapsed
  bool isUnfolded(String dirPath, String rootPath) => dirPath == rootPath
      ? _folderStates[rootPath] = isParentOpen
      : (_folderStates[dirPath] ?? false);

  /// Toggles folder expansion/collapse state
  void toggleFolder(String dirPath, String rootPath) {
    if (dirPath != rootPath) {
      _folderStates[dirPath] = !(_folderStates[dirPath] ?? false);
    }
    notifyListeners();
  }

  /// Starts the creation process of a new folder or file
  void startCreating(String parentPath, bool folder) {
    newEntryPath = parentPath;
    isFolderCreation = folder;
    notifyListeners();
  }

  /// Stops the creation process and clears the state
  void stopCreating() {
    newEntryPath = null;
    notifyListeners();
  }

  /// Watches the given directory for changes and updates the UI accordingly
  void watchDirectory(String directoryPath) {
    _directoryWatcher?.cancel();
    final dir = Directory(directoryPath);
    if (dir.existsSync()) {
      _directoryWatcher = dir.watch(recursive: true).listen((event) {
        if (event is FileSystemCreateEvent ||
            event is FileSystemModifyEvent ||
            event is FileSystemDeleteEvent) {
          notifyListeners();
        }
      });
    }
  }
}

/// A provider that supplies [DirectoryTreeStateNotifier] to its descendants in the widget tree.
class DirectoryTreeStateProvider
    extends InheritedNotifier<DirectoryTreeStateNotifier> {
  /// Constructs a [DirectoryTreeStateProvider] with the given notifier and child widget.
  const DirectoryTreeStateProvider({
    super.key,
    required DirectoryTreeStateNotifier super.notifier,
    required super.child,
  });

  /// Accesses the [DirectoryTreeStateNotifier] in the widget tree.
  static DirectoryTreeStateNotifier of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<DirectoryTreeStateProvider>();
    assert(provider != null, 'No DirectoryTreeStateProvider found in context');
    return provider!.notifier!;
  }
}

/// A widget that displays a foldable directory tree, showing files and subdirectories.
class FoldableDirectoryTree extends StatefulWidget {
  final String rootPath;
  final bool enableCreateFolderOption, enableCreateFileOption;
  final bool enableDeleteFolderOption, enableDeleteFileOption;
  final FolderStyle? folderStyle;
  final FileStyle? fileStyle;
  final EditingFieldStyle? editingFieldStyle;
  final void Function(File, TapDownDetails)? onFileTap;
  final void Function(File, TapDownDetails)? onFileSecondaryTap;
  final void Function(Directory, TapDownDetails)? onDirTap;
  final void Function(Directory, TapDownDetails)? onDirSecondaryTap;
  final List<Widget>? folderActions;
  final List<Widget>? fileActions;
  final Widget Function(String fileExtension)? fileIconBuilder;

  const FoldableDirectoryTree({
    super.key,
    required this.rootPath,
    this.onFileTap,
    this.onFileSecondaryTap,
    this.onDirTap,
    this.onDirSecondaryTap,
    this.folderStyle,
    this.fileStyle,
    this.folderActions,
    this.fileActions,
    this.editingFieldStyle,
    this.enableCreateFileOption = false,
    this.enableCreateFolderOption = false,
    this.enableDeleteFileOption = false,
    this.enableDeleteFolderOption = false,
    this.fileIconBuilder,
  });

  @override
  State<FoldableDirectoryTree> createState() => _FoldableDirectoryTreeState();
}

/// Recursively builds the directory tree for a given [directory] using [stateNotifier] to manage folder states.
class _FoldableDirectoryTreeState extends State<FoldableDirectoryTree> {
  Widget _buildDirectoryTree(
    Directory directory,
    DirectoryTreeStateNotifier stateNotifier,
  ) {
    final entries = directory.listSync();
    entries.sort((a, b) {
      if (a is Directory && b is File) return -1;
      if (a is File && b is Directory) return 1;
      return a.path.compareTo(b.path);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTapDown: (details) {
            if (widget.onDirTap != null) {
              widget.onDirTap!(directory, details);
            }
          },
          onSecondaryTapDown: (details) {
            if (widget.onDirSecondaryTap != null) {
              widget.onDirSecondaryTap!(directory, details);
            }
          },
          onTap: () {
            stateNotifier.toggleFolder(directory.path, widget.rootPath);
            currentDir = directory.path;
            if (directory.path == widget.rootPath) {
              setState(() {
                isParentOpen = !isParentOpen;
              });
            }
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Row(
              children: [
                directory.path != widget.rootPath
                    ? (stateNotifier.isUnfolded(directory.path, widget.rootPath)
                          ? widget.folderStyle?.folderOpenedicon ??
                                FolderStyle().folderOpenedicon
                          : widget.folderStyle?.folderClosedicon ??
                                FolderStyle().folderClosedicon)
                    : isParentOpen
                    ? widget.folderStyle?.rootFolderOpenedIcon ??
                          FolderStyle().rootFolderOpenedIcon
                    : widget.folderStyle?.rootFolderClosedIcon ??
                          FolderStyle().rootFolderClosedIcon,
                const SizedBox(width: 8),
                Text(
                  path.basename(directory.path),
                  style:
                      widget.folderStyle?.folderNameStyle ??
                      FolderStyle().folderNameStyle,
                ),
                SizedBox(
                  width: widget.folderStyle?.itemGap ?? FolderStyle().itemGap,
                ),
                if (widget.enableCreateFileOption &&
                    stateNotifier.isUnfolded(directory.path, widget.rootPath) &&
                    currentDir == directory.path)
                  IconButton(
                    onPressed: () =>
                        stateNotifier.startCreating(directory.path, false),
                    icon:
                        widget.folderStyle?.iconForCreateFile ??
                        FolderStyle().iconForCreateFile,
                  ),
                if (widget.enableCreateFolderOption &&
                    stateNotifier.isUnfolded(directory.path, widget.rootPath) &&
                    currentDir == directory.path)
                  IconButton(
                    onPressed: () =>
                        stateNotifier.startCreating(directory.path, true),
                    icon:
                        widget.folderStyle?.iconForCreateFolder ??
                        FolderStyle().iconForCreateFolder,
                  ),
                if (widget.enableDeleteFolderOption &&
                    stateNotifier.isUnfolded(directory.path, widget.rootPath) &&
                    currentDir == directory.path)
                  IconButton(
                    onPressed: () {
                      Directory(directory.path).delete(recursive: true);
                      setState(() {});
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ...widget.folderActions ?? [],
              ],
            ),
          ),
        ),
        if (stateNotifier.isUnfolded(directory.path, widget.rootPath))
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...entries.map((entry) {
                  if (entry is Directory) {
                    return _buildDirectoryTree(
                      Directory(entry.path),
                      stateNotifier,
                    );
                  } else if (entry is File) {
                    return _buildFileItem(entry);
                  }
                  return const SizedBox.shrink();
                }),
                if (stateNotifier.newEntryPath == directory.path)
                  _buildNewEntryField(directory, stateNotifier),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildNewEntryField(
    Directory parent,
    DirectoryTreeStateNotifier stateNotifier,
  ) {
    TextEditingController controller = TextEditingController();
    return Row(
      children: [
        stateNotifier.isFolderCreation
            ? widget.editingFieldStyle?.folderIcon ??
                  EditingFieldStyle().folderIcon
            : widget.editingFieldStyle?.fileIcon ??
                  EditingFieldStyle().fileIcon,
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            height: widget.editingFieldStyle?.textFieldHeight,
            width: widget.editingFieldStyle?.textFieldWidth,
            child: TextField(
              style: widget.editingFieldStyle?.textStyle,
              textAlignVertical: widget.editingFieldStyle?.verticalTextAlign,
              cursorRadius: widget.editingFieldStyle?.cursorRadius,
              cursorWidth: widget.editingFieldStyle?.cursorWidth ?? 2.0,
              cursorHeight: widget.editingFieldStyle?.cursorHeight,
              cursorColor: widget.editingFieldStyle?.cursorColor,
              controller: controller,
              autofocus: true,
              decoration:
                  widget.editingFieldStyle?.textfieldDecoration ??
                  EditingFieldStyle().textfieldDecoration,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  final newPath = path.join(parent.path, value.trim());
                  if (stateNotifier.isFolderCreation) {
                    Directory(newPath).createSync();
                  } else {
                    File(newPath).createSync();
                  }
                }
                stateNotifier.stopCreating();
              },
            ),
          ),
        ),
        IconButton(
          icon:
              widget.editingFieldStyle?.doneIcon ??
              EditingFieldStyle().doneIcon,
          onPressed: () {
            if (controller.text.trim().isNotEmpty) {
              final newPath = path.join(parent.path, controller.text.trim());
              if (stateNotifier.isFolderCreation) {
                Directory(newPath).createSync();
              } else {
                File(newPath).createSync();
              }
            }
            stateNotifier.stopCreating();
          },
        ),
        IconButton(
          icon:
              widget.editingFieldStyle?.cancelIcon ??
              EditingFieldStyle().cancelIcon,
          onPressed: () {
            stateNotifier.stopCreating();
          },
        ),
      ],
    );
  }

  /// Builds the widget for a single file item.
  Widget _buildFileItem(File file) {
    final extension = path.extension(file.path).toLowerCase();
    final customIcon = widget.fileIconBuilder != null
        ? widget.fileIconBuilder!(extension)
        : widget.fileStyle?.fileIcon ?? FileStyle().fileIcon;
    return GestureDetector(
      onTapDown: (details) {
        if (widget.onFileTap != null) {
          widget.onFileTap!(file, details);
        }
      },
      onSecondaryTapDown: (details) {
        if (widget.onFileSecondaryTap != null) {
          widget.onFileSecondaryTap!(file, details);
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Row(
          children: [
            customIcon,
            const SizedBox(width: 8),
            Text(
              path.basename(file.path),
              style:
                  widget.fileStyle?.fileNameStyle ?? FileStyle().fileNameStyle,
            ),
            ...widget.fileActions ?? [],
            if (widget.enableDeleteFileOption)
              IconButton(
                onPressed: () {
                  file.deleteSync(recursive: true);
                  setState(() {});
                },
                icon:
                    widget.fileStyle?.iconForDeleteFile ??
                    FileStyle().iconForDeleteFile,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stateNotifier = DirectoryTreeStateProvider.of(context);
    stateNotifier.watchDirectory(widget.rootPath);
    final rootDirectory = Directory(widget.rootPath);

    if (!rootDirectory.existsSync()) {
      return const Center(child: Text('Directory does not exist'));
    }

    return SingleChildScrollView(
      child: _buildDirectoryTree(rootDirectory, stateNotifier),
    );
  }
}
