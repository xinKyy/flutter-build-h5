/*
 * @Author: 王长春
 * @Date: 2022-03-14 09:24:34
 * @LastEditors: 王长春
 * @LastEditTime: 2022-03-17 10:01:41
 * @Description: 截图工具，生成截图，保存到相册或者保存本地cash文件夹返回文件路径（供分享使用）
 */

import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

//全局key-截图key
final GlobalKey boundaryKey = GlobalKey();

class RepaintBoundaryUtils {
//申请存本地相册权限
  Future<bool> getPormiation() async {
    if (Platform.isIOS) {
      var status = await Permission.photos.status;
      if (status.isDenied) {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.photos,
        ].request();
        // saveImage(globalKey);
      }
      return status.isGranted;
    } else {
      var status = await Permission.storage.status;
      if (status.isDenied) {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.storage,
        ].request();
      }
      return status.isGranted;
    }
  }

//保存到相册
  void savePhoto() async {
    RenderRepaintBoundary? boundary = boundaryKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary?;

    double dpr = ui.window.devicePixelRatio; // 获取当前设备的像素比
    var image = await boundary!.toImage(pixelRatio: dpr);
    // 将image转化成byte
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    //获取保存相册权限，如果没有，则申请改权限
    bool permition = await getPormiation();

    var status = await Permission.photos.status;
    if (permition) {
      if (Platform.isIOS) {
        if (status.isGranted) {
          Uint8List images = byteData!.buffer.asUint8List();
          final result = await ImageGallerySaver.saveImage(images,
              quality: 60, name: "hello");
        }
        if (status.isDenied) {

        }
      } else {
        //安卓
        if (status.isGranted) {
          Uint8List images = byteData!.buffer.asUint8List();
          final result = await ImageGallerySaver.saveImage(images, quality: 60);
          if (result != null) {

          } else {
            print('error');
            // toast("保存失败");
          }
        }
      }
    }else{
      //重新请求--第一次请求权限时，保存方法不会走，需要重新调一次
      savePhoto();
    }
  }
}
