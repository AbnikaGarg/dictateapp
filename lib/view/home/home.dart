import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speechtotext/controllers/homeController.dart';
import 'package:speechtotext/models/DictationsDataModel.dart';
import 'package:speechtotext/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:speechtotext/view/folder/folder.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.type, required this.title});
  final int type;
  final String title;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Color> colorList = [
    const Color.fromRGBO(112, 250, 232, 1),
    Colors.yellow,
    const Color.fromARGB(255, 172, 8, 104),
    const Color.fromARGB(255, 4, 134, 240),
    const Color(0xff3EE094),
    const Color.fromARGB(255, 221, 245, 2),
    const Color(0xffFA4A42),
    const Color(0xffFE9539),
    const Color.fromRGBO(252, 2, 198, 1),
    const Color.fromRGBO(129, 250, 112, 1),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomepageController>(builder: (_controller) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Dictate',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          elevation: 0,
          centerTitle: false,
          titleSpacing: 2,
          leading: GestureDetector(
              onTap: () {
                _controller.getAllFolders();
                Get.to(Folder());
              },
              child: Icon(Icons.folder_copy_outlined)),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
                    onTap: () {
                      _controller.sort();
                    },
                    child: Icon(
                      _controller.isSorted
                          ? CupertinoIcons.sort_down
                          : CupertinoIcons.sort_up,
                      color: _controller.isSorted
                          ? AppTheme.primaryColor
                          : AppTheme.black,
                    ))),
            if (_controller.type == 0)
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: InkWell(
                  onTap: () {
                    _controller.selectEdit();
                  },
                  child: Text(
                    _controller.isSelecting ? "Cancel" : "Edit",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.w600),
                  ),
                ),
              )
          ],
          backgroundColor: AppTheme.whiteColor,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _controller.isSelecting
            ? Container(
                width: double.infinity,
                child: Row(
                  children: [
                    if (_controller.dictationsDataList.isNotEmpty)
                      if (!_controller.dictationsDataList.first.data!.any(
                              (element) =>
                                  element.isSelected == true &&
                                  element.is_ftp == true) ||
                          _controller.type == 3)
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _controller
                                  .saveMultipleRecording(_controller.type);
                              // profileBottomsheet(
                              //   context,
                              //   () {},
                              //   () {},
                              // );
                            },
                            child: Container(
                              height: 45,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Text(
                                "Upload",
                                style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.whiteColor),
                              ),
                            ),
                          ),
                        ),
                    if (_controller.type != 4)
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            _controller.deleteREcor();
                            // profileBottomsheet(
                            //   context,
                            //   () {},
                            //   () {},
                            // );
                          },
                          child: Container(
                            height: 45,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(
                              "Delete",
                              style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.whiteColor),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              )
            : Container(),
        body: !_controller.isLoadedDic
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${_controller.title}",
                            style: GoogleFonts.inter(
                                color: AppTheme.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      if (_controller.type == -1)
                        if (_controller.lastOpenedList.isNotEmpty)
                          ListView.builder(
                            itemCount: _controller.lastOpenedList.length,
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, index) {
                              return buildFolderRow(
                                  context,
                                  index,
                                  _controller.lastOpenedList[index],
                                  _controller);
                            },
                          )
                        else
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 80,
                                ),
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.asset(
                                      "assets/images/nodata.png",
                                      height: 200,
                                    )),
                                SizedBox(
                                  height: 20,
                                ),
                                Text("No Data"),
                              ],
                            ),
                          )
                      else if (_controller.dictationsDataList.isNotEmpty)
                        if (_controller
                            .dictationsDataList.first.data!.isNotEmpty)
                          ListView.builder(
                            itemCount: _controller
                                .dictationsDataList.first.data!.length,
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, index) {
                              // if (_controller.type == 0) {
                              //   if (_controller.dictationsDataList.first
                              //           .data![index].is_local ==
                              //       false) {
                              //     return Container();
                              //   }
                              // }
                              return buildFolderRow(
                                  context,
                                  index,
                                  _controller
                                      .dictationsDataList.first.data![index],
                                  _controller);
                            },
                          )
                        else
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 80,
                                ),
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.asset(
                                      "assets/images/nodata.png",
                                      height: 200,
                                    )),
                                SizedBox(
                                  height: 20,
                                ),
                                Text("No Data"),
                              ],
                            ),
                          )
                    ],
                  ),
                )),
      );
    });
  }

  Widget buildFolderRow(BuildContext context, int index, Data data,
      HomepageController _controller) {
    return GestureDetector(
      onLongPress: () {
        //  setState(() {
        // if (_controller.type == 0 ||_controller.type == 4) {
        _controller.updateDictationUrlSelected(index);
        // }

        // if (!_controller.selectedIndexes.contains(data["path"])) {
        //   _controller.selectedIndexes.add(data["path"]);
        //   _controller.selectedList(index);
        // }
        // });
      },
      onTap: () {
        if (_controller.isSelecting) {
          _controller.updateDictationUrlSelected(index);
        } else {
          _controller.changeIndex(index, data.dictationsdataUrl);
        }
      },
      // onTap: () {
      //   _controller.changeIndex(index, data.dictationsdataUrl);
      // },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.whiteColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              children: [
                if (_controller.type != 3)
                  if (data.is_ftp != null)
                    Icon(
                      CupertinoIcons.arrow_turn_right_up,
                      size: 18,
                      color: Colors.lightBlue,
                    )
                  else
                    Icon(
                      CupertinoIcons.arrow_turn_right_up,
                      size: 18,
                      color: Colors.white,
                    )
                else
                  Icon(
                    CupertinoIcons.arrow_turn_right_up,
                    size: 18,
                    color: Colors.white,
                  ),
                //  if (data.file_status == 1)
                SizedBox(width: 4),
                Container(
                  height: 48,
                  width: 45,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12)),
                  child: _controller.isSelecting
                      ? Checkbox(
                          value: data.isSelected,
                          onChanged: (value) {
                            // setState(() {
                            //   if (value == true) {
                            //     controller.selectedIndexes.add(data["path"]);
                            //   } else {
                            //     controller.selectedIndexes.remove(index);
                            //   }
                            //   if (controller.selectedIndexes.isEmpty)
                            //     controller.isSelecting = false;
                            // });
                          },
                        )
                      : Icon(
                          Icons.mic,
                          size: 24,
                          color: AppTheme.whiteColor,
                        ),
                ),
                // Image.asset("assets/images/pro.png"),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              "${data.filename}",
                              style: GoogleFonts.inter(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                          // if (_controller.selectedIndex == index)
                          //   InkWell(
                          //     onTap: () {
                          //       _controller.editDictation(data);
                          //     },
                          //     child: Icon(
                          //       Icons.edit_rounded,
                          //       color: Colors.red,
                          //       size: 20,
                          //     ),
                          //   )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${data.createdAt!.substring(0, 10)}",
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppTheme.lightText),
                          ),
                          if (data.file_status == 1)
                            Row(
                              children: [
                                Text(
                                  "${DateFormat("dd MMM yyyy hh:mm:ss").format(DateTime.parse(data.fileUploadedDateTime!))}",
                                  style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppTheme.primaryColor),
                                ),
                                // Icon(
                                //   Icons.play_circle_rounded,
                                //   size: 30,
                                //   color: AppTheme.primaryColor,
                                // ),
                              ],
                            )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_controller.selectedIndex == index)
              Obx(
                () => Column(
                  children: [
                    SizedBox(height: 20),
                    SliderTheme(
                      data: const SliderThemeData(
                        trackHeight: 4,
                        rangeThumbShape: RoundRangeSliderThumbShape(
                          enabledThumbRadius: 8,
                          disabledThumbRadius: 5,
                        ),
                        overlayShape: RoundSliderOverlayShape(
                          overlayRadius: 4,
                        ),
                        activeTickMarkColor: Colors.transparent,
                        inactiveTickMarkColor: Colors.transparent,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Slider(
                          max: _controller.max.value,
                          value: _controller.slidervalue.value,
                          onChanged: (value) {
                            value = value;
                            _controller.changeValueinDuration(value.toInt());
                          },
                          min: 0,
                          label: "2",
                        ),
                      ),
                    ),
                    SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _controller.postion.value,
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              height: 0,
                              color: AppTheme.lightText,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          _controller.duration.value,
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              height: 0,
                              color: AppTheme.lightText,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _controller.skip5SecondsBackward();
                          },
                          child: Icon(
                            Icons.fast_rewind,
                            color: AppTheme.lightText,
                            size: 30,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _controller.pausePlaySong(data.id);
                          },
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: AppTheme.lightText,
                                shape: BoxShape.circle),
                            child: Icon(
                              !_controller.isPlaying == false
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 22,
                              color: AppTheme.whiteColor,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _controller.skip5SecondsForward();
                          },
                          child: Icon(
                            Icons.fast_forward,
                            color: AppTheme.lightText,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
