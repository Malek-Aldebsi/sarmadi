// window.onBeforeUnload.listen((Event e) {
//   // display confirmation dialog
//   BeforeUnloadEvent event = e as BeforeUnloadEvent;
//   event.returnValue = 'Are you sure you want to leave?';
// });

// WillPopScope(
//                onWillPop: () async {
//                  // show confirmation dialog
//                  bool confirm = await showDialog(
//                    context: context,
//                    builder: (BuildContext context) {
//                      return AlertDialog(
//                        title: Text("Are you sure?"),
//                        content: Text("Do you want to exit the app?"),
//                        actions: <Widget>[
//                          TextButton(
//                            child: Text("CANCEL"),
//                            onPressed: () => Navigator.of(context).pop(false),
//                          ),
//                          TextButton(
//                            child: Text("YES"),
//                            onPressed: () => Navigator.of(context).pop(true),
//                          ),
//                        ],
//                      );
//                    },
//                  );
//                  // return true if user confirms action, false otherwise
//                  return confirm ?? false;
//                },
//                child:
