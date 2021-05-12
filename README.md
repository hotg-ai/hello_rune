# hello_rune

An example app to deploy and run runes on iOS and Android

## Getting Started

### Add the RuneVM plugin to your pubspec.yaml file

```
dependencies:
  flutter:
    sdk: flutter
  runevm_fl:
    git:
      url: https://github.com/hotg-ai/runevm_fl.git 

```

### Load and run your rune file

```dart

import 'package:runevm_fl/runevm_fl.dart';
import 'dart:typed_data';
import 'dart:async';

class RunMyRune {

  RunMyRune() {
    initAndRunRune([5,128,12,39]);
  }

  initAndRunRune(List<int> input) async {
    try {
      bytes = await rootBundle.load('assets/microspeech.rune');
      bool loaded =
          await RunevmFl.loadWASM(bytes!.buffer.asUint8List()) ?? false;
      if (loaded) {
        String manifest = (await RunevmFl.manifest).toString();
        print("Manifest loaded: $manifest");
      }
    } on Exception {
      print('Failed to init rune');
    }
    String? output = await RunevmFl.runRune(Uint8List.fromList(input));
  }

}

```

### Android

No extra config needed

### iOS

I you are creating a new app,
First run 
```console
foo@bar:~$ flutter run
```
to generate the podfile.

Minimum iOS version should be at least 12.1 to be compatible with the plugin:

Set this in XCode > Runner > General > Deployment info


Bitcode needs to be disabled either for the runevm_fl target:

XCode > Pods > Targets > runevm_fl > Build Settings > Enable Bitcode > Set to 'No'

or directly in the Podfile:

```
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    ## Add these 3 lines to your podfile
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
    
  end
end
```

### Run it 

```console
foo@bar:~$ flutter run
```

