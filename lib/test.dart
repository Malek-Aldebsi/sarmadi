// SizedBox(
// width: width * 0.72,
// height: height * 0.65,
// child: ListView(
// children: [
// for (int i = 0;
// i <
// websiteProvider
//     .subjects.length;
// i += 3) ...[
// Padding(
// padding: EdgeInsets.symmetric(
// vertical: height * 0.02),
// child: Row(
// children: [
// for (int j = 0;
// j < 3 &&
// j + i <
// websiteProvider
//     .subjects
//     .length;
// j++)
// if (websiteProvider
//     .subjects[
// i + j]['id'] ==
// '2d3ce0b6-c7b5-4b47-a344-ec1f36a077ab')
// Padding(
// padding:
// EdgeInsets.only(
// left: width *
// 0.02),
// child:
// CustomContainer(
// onTap: () {
// quizProvider.setSubject(
// '2d3ce0b6-c7b5-4b47-a344-ec1f36a077ab',
// 'اللغة العربية');
//
// websiteProvider
//     .setLoaded(
// false);
//
// context.pushReplacement(
// '/WritingQuiz');
// },
// width: width * 0.21,
// height:
// height * 0.16,
// verticalPadding: 0,
// horizontalPadding:
// 0,
// borderRadius:
// width * 0.005,
// border: null,
// buttonColor: quizProvider
//     .subjectID ==
// '2d3ce0b6-c7b5-4b47-a344-ec1f36a077ab'
// ? kPurple
//     : kDarkGray,
// child: Stack(
// alignment: Alignment
//     .bottomLeft,
// children: [
// Image(
// image: const AssetImage(
// 'images/planet.png'),
// width: width *
// 0.1,
// fit: BoxFit
//     .contain,
// alignment:
// Alignment
//     .bottomLeft,
// ),
// Padding(
// padding: EdgeInsets.only(
// right: width *
// 0.025),
// child: Align(
// alignment:
// Alignment
//     .centerRight,
// child: Text(
// 'تعبير عربي',
// style: textStyle(
// 2,
// width,
// height,
// quizProvider.subjectID == '2d3ce0b6-c7b5-4b47-a344-ec1f36a077ab'
// ? kDarkBlack
//     : kWhite),
// ),
// ),
// ),
// ],
// ),
// ),
// )
// else if (websiteProvider
//     .subjects[
// i + j]['id'] ==
// '7376be1e-e252-4d22-874b-9ec129326807')
// Padding(
// padding:
// EdgeInsets.only(
// left: width *
// 0.02),
// child:
// CustomContainer(
// onTap: () {
// quizProvider.setSubject(
// '7376be1e-e252-4d22-874b-9ec129326807',
// 'اللغة الإنجليزية');
//
// websiteProvider
//     .setLoaded(
// false);
//
// context.pushReplacement(
// '/WritingQuiz');
// },
// width: width * 0.21,
// height:
// height * 0.16,
// verticalPadding: 0,
// horizontalPadding:
// 0,
// borderRadius:
// width * 0.005,
// border: null,
// buttonColor: quizProvider
//     .subjectID ==
// '7376be1e-e252-4d22-874b-9ec129326807'
// ? kPurple
//     : kDarkGray,
// child: Stack(
// alignment: Alignment
//     .bottomLeft,
// children: [
// Image(
// image: const AssetImage(
// 'images/planet.png'),
// width: width *
// 0.1,
// fit: BoxFit
//     .contain,
// alignment:
// Alignment
//     .bottomLeft,
// ),
// Padding(
// padding: EdgeInsets.only(
// right: width *
// 0.025),
// child: Align(
// alignment:
// Alignment
//     .centerRight,
// child: Text(
// 'تعبير إنجليزي',
// style: textStyle(
// 2,
// width,
// height,
// quizProvider.subjectID == '7376be1e-e252-4d22-874b-9ec129326807'
// ? kDarkBlack
//     : kWhite),
// ),
// ),
// ),
// ],
// ),
// ),
// )
// else
// Padding(
// padding:
// EdgeInsets.only(
// left: width *
// 0.02),
// child:
// CustomContainer(
// onTap: () {
// quizProvider.setSubject(
// websiteProvider
//     .subjects[
// i + j]
// ['id'],
// websiteProvider
//     .subjects[
// i + j]
// ['name']);
//
// websiteProvider
//     .setLoaded(
// false);
//
// context.pushReplacement(
// '/AdvanceQuizSetting');
// },
// width: width * 0.21,
// height:
// height * 0.16,
// verticalPadding: 0,
// horizontalPadding:
// 0,
// borderRadius:
// width * 0.005,
// border: null,
// buttonColor: quizProvider
//     .subjectID ==
// websiteProvider
//     .subjects[
// i + j]['id']
// ? kPurple
//     : kDarkGray,
// child: Stack(
// alignment: Alignment
//     .bottomLeft,
// children: [
// Image(
// image: const AssetImage(
// 'images/planet.png'),
// width: width *
// 0.1,
// fit: BoxFit
//     .contain,
// alignment:
// Alignment
//     .bottomLeft,
// ),
// Padding(
// padding: EdgeInsets.only(
// right: width *
// 0.025),
// child: Align(
// alignment:
// Alignment
//     .centerRight,
// child: Text(
// '${websiteProvider.subjects[i + j]['name']}',
// style: textStyle(
// 2,
// width,
// height,
// quizProvider.subjectID == websiteProvider.subjects[i + j]['id']
// ? kDarkBlack
//     : kWhite),
// ),
// ),
// ),
// ],
// ),
// ),
// ),
// ],
// ),
// )
// ],
// ],
// ),
// ),
