# File Tree View Flutter Package

A Flutter package to view directories and files in a foldable tree structure. This package allows you to display files and folders in a tree view, with the ability to customize the folder and file icons, text styles, and handle file taps.

## Features

- **Folder and File Tree Structure**: Display files and folders in a nested tree layout.
- **Foldable Directories**: Allow users to expand and collapse directories.
- **Custom Icons**: Easily customize foldaer and file icons.
- **Custom Text Styles**: Style folder and file names using `TextStyle`.
- **File Tap Handler**: Handle file taps to perform custom actions.

| Platform   | Supported  |
|------------|------------|
| **Android** | ✓          |
| **iOS**     | ✓          |
| **Windows** | ✓          |
| **Linux**   | ✓          |
| **macOS**   | ✓          |
| **Web**     | ✘          |

_Note_: This package is not currently compatible with Web. 

<br>

<img src="https://i.imgur.com/CIw6251.gif" alt="gif" width="210" height="390" style="padding-right:45px"/>
<img src = "https://i.imgur.com/acLZGFu.gif" alt="gif" width="210" height="390"/>

## Installation

```yaml
dependencies:
  file_tree_view: ^0.0.7
```

## Basic Usage
```dart
import 'package:file_tree_view/file_tree_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('File Tree View')),
        body: DirectoryTreeViewer(rootPath: '/path/to/your/directory'), // Specify the root directory path
      ),
    );
  }
}

```

## Custom Icons and TextStyle
```dart
import 'package:file_tree_view/file_tree_view.dart';
import 'package:file_tree_view/style.dart';
import 'package:flutter/material.dart';
import 'package:file_icon/file_icon.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/foundation.dart'; 
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(
    const MaterialApp(
      home: kIsWeb?Scaffold(body: Center(child: Text("Web not supported"),),): Home()
    ));
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff181818),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.grey),
      ),
      drawer: Drawer(
        backgroundColor:  const Color(0xff2b2b2b),
        child: SingleChildScrollView(
          child: SizedBox(
            child: DirectoryTreeViewer(
              rootPath: 'Your directory path here',
              enableCreateFileOption: true,
              enableCreateFolderOption: true,
              editingFieldStyle: EditingFieldStyle(
                textStyle: const TextStyle(
                  color: Colors.grey,
                ),
                cursorColor: Colors.grey,
                cursorHeight: 18,
                verticalTextAlign: TextAlignVertical.top,
                textfieldDecoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                    borderSide: BorderSide(color: Colors.grey)
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                    borderSide: BorderSide(color: Colors.grey)
                  ),
                ),
                folderIcon: const Icon(Icons.folder, color: Colors.grey,size: 20),
                fileIcon: const Icon(Icons.edit_document, color: Colors.grey,size: 20),
                doneIcon: const Icon(Icons.check, color: Colors.grey,size: 20),
                cancelIcon: const Icon(Icons.close, color: Colors.grey,size: 20),
              ),
              folderStyle: FolderStyle(
                folderNameStyle:  TextStyle(color: Colors.grey[400]),
                folderClosedicon: SvgPicture.asset('assets/icons/folder.svg',height: 25,width: 25),
                folderOpenedicon: SvgPicture.asset('assets/icons/open-file-folder.svg',height: 25,width: 25),
                iconForCreateFile: const Icon(FontAwesomeIcons.fileCirclePlus,color: Colors.grey,size: 14),
                iconForCreateFolder: const Icon(Icons.create_new_folder,color: Colors.grey,size: 17)
              ),
              fileStyle: FileStyle(
                fileNameStyle: TextStyle(color: Colors.grey[400]),
              ),
              fileIconBuilder: (extension)=>FileIcon(extension),
          ),    
          ),
        ),
      ),
      body: const Center(child: Text("Example with custom icons",style: TextStyle(color: Colors.grey))),
    );
  }
}

```
