# ar_flutter_ti

## Augmented Reality (AR)
Flutter Plugin for (collaborative) Augmented Reality.<br>
Many thanks to Oleksandr Leuschenko and CariusLars for the 
[ar_flutter_plugin](https://github.com/CariusLars/ar_flutter_plugin).<br>

## Getting Started<br>
I probed only Android platform.<br>
![vsc](ar_demo_ti/images/vscicon1.png) : [Visual Studio Code](https://code.visualstudio.com/).<br>

### Installing<br>
You created clone repository from ar_flutter_ti.<br>
Install Flutter, Dart extensions etc. in Visual Studio Code.<br>


![Flutter](ar_demo_ti/images/fluttericon1.png) : [Flutter](https://flutter.dev/).<br>
![Dart](ar_demo_ti/images/darticon1.png) : [Dart](https://dart.dev/).<br>

IDE :
<div align="center">

![IDE](ar_demo_ti/images/vsc.jpg)

</div><br>

Open Folder the ar_flutter_ti directory.<br>
You connected you android mobil. Android version is >= 9. <br>

Debug version is in terminal windows:
```bash
./ar_demo_ti/android/local.properties:
sdk.dir=d:/Users/Appdata/Android/sdk  // overwrite this with the name of your own sdk.dir of directory.
flutter.sdk=d:\\ProgramFiles\\flutter // overwrite this with the name of your own flutter.dir of directory.
.
.

cd ar_demo_ti
```
In Run menu "Start Debuging" or "Run Without Debugging". <br>

Release version is in terminal windows: <br>

```bash
Flutter clean
flutter build apk
flutter install

// To the Google Play bundle file type and
// if your need the new key.properties, then 
// generating key create a file called key.properties in the android directory.
// this is need the for the bundle file.
// My key is good.
// https://dev.to/mimanjh/flutter-deploying-your-app-to-play-store-2nnc
// my batch file in ./key_tool/keytool.bat

flutter build appbundle 
```

## App result images:<br>
<div align="center">

![1.](ar_demo_ti/images/ar_demo_ti_screen1.jpg)
![2.](ar_demo_ti/images/ar_demo_ti_screen2.jpg)

</div><br>
<div align="center">

![3.](ar_demo_ti/images/ar_demo_ti_screen3.jpg)
![4.](ar_demo_ti/images/ar_demo_ti_screen4.jpg)

</div><br>
<div align="center">

![5.](ar_demo_ti/images/ar_demo_ti_screen5.jpg)
![6.](ar_demo_ti/images/ar_demo_ti_screen6.jpg)

</div><br>
<br>
YouTube video (click):<br>
<div align="center">

[![YouTube video](https://img.youtube.com/vi/AvguI4dyZtY/0.jpg)](https://www.youtube.com/watch?v=AvguI4dyZtY)

</div><br>

## The name is in the Google Play: ar_demo_ti
