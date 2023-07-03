'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "bfe4d440eeea0c357aa7f0f7260d304a",
"assets/assets/fonts/Dubai-Bold.ttf": "8fbdda63d87a91c5600c512a12aec79a",
"assets/assets/fonts/Dubai-Light.ttf": "2f7c5bb9cf55f5b0cb2d06c57d5a8ae7",
"assets/assets/fonts/Dubai-Medium.ttf": "1b70cb9a589df286a5e4faf70e2a50d9",
"assets/assets/fonts/Dubai-Regular.ttf": "24ab51f6ae1804c808f822d28b9be18a",
"assets/assets/fonts/SarmadiIcons.ttf": "5b645a8b30aae64785e06fa2c0f5274c",
"assets/FontManifest.json": "e6505b1ca10d5b89b9b1049b23a8d812",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/images/advises.png": "1044be08c1968aa7201e42eab5794493",
"assets/images/adv_3.png": "9a00671fc19c06cb0eb8659240e0ecb7",
"assets/images/clock.png": "ca6f2460a90e13a12eae135c04e7163c",
"assets/images/clock_imoji.png": "fb7d623330903e67596a2cee65434db7",
"assets/images/facebook_logo.png": "45bb1848108e1395cf924f7fbd42ebd1",
"assets/images/following_up_your_analyses.png": "5097b643b9170caa6a30aa107767d921",
"assets/images/google_logo.png": "56516f5442263851d0e147599bb59b9b",
"assets/images/home_dashboard_background.jpg": "2961d0ae9689bd1538e1635cccb87ba8",
"assets/images/home_dashboard_background.png": "0de09b17512e2bf174f2c5f026a6f174",
"assets/images/latest_ai_tech.png": "65043e425ffb6cb92b83c4db9d700d1f",
"assets/images/led.png": "4f0d6a552bf44405303c74f2b00a8295",
"assets/images/logo.png": "22dd26934a263ecc9052338e2ec2fda8",
"assets/images/magnifying_glass.png": "7b0c69c82b4a81ec941b88650b830b7d",
"assets/images/monitor_your_performance.png": "3e915343b0ad62558f13efa313e5435e",
"assets/images/planet.png": "945afb54e0a2d40440ade522e0afed8a",
"assets/images/planet_2.png": "2fac04dd8ec8584bb0b4e2495d074b09",
"assets/images/quiz_revision.png": "d821cd85e33a9d6db609913cbf67058e",
"assets/images/signup_background.jpg": "86d87140bb2338f025d40bef5f4e6f13",
"assets/images/signup_background.png": "e92851735d74e4b816b75609790a20b5",
"assets/images/single_question_background.jpg": "f0549114b9ad1331095f636db02e8907",
"assets/images/single_question_background.png": "c38ab169d4abf5ae3b6f8a468b9f86c7",
"assets/images/study_is_your_game.png": "9fa86e58010390c41d2252262276b7eb",
"assets/images/various_question_sources.png": "2a3ba84383742ddc016da2ad345d3901",
"assets/images/varity_in_questions.png": "2047e4edfef8fa70584d540e3ec433a7",
"assets/images/welcome_bg.jpg": "89516f51d9ba2af52f9fc2010c4a2253",
"assets/images/welcome_bg.png": "0bb2d09b6d73132764febaa767dd8cee",
"assets/images/welcome_full_bg.jpg": "c4e06af2339b555eb96742d377cd0a53",
"assets/images/welcome_full_bg.png": "01a2ef71f4b79959e94b38a2505abb40",
"assets/images/your_weakness_point.png": "c5d32f90080b2cd1166e4669c51b5b77",
"assets/NOTICES": "dda6d2ba12aa128ddb2979ce32d9fa7c",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_AMS-Regular.ttf": "657a5353a553777e270827bd1630e467",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Caligraphic-Bold.ttf": "a9c8e437146ef63fcd6fae7cf65ca859",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Caligraphic-Regular.ttf": "7ec92adfa4fe03eb8e9bfb60813df1fa",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Fraktur-Bold.ttf": "46b41c4de7a936d099575185a94855c4",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Fraktur-Regular.ttf": "dede6f2c7dad4402fa205644391b3a94",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Bold.ttf": "9eef86c1f9efa78ab93d41a0551948f7",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-BoldItalic.ttf": "e3c361ea8d1c215805439ce0941a1c8d",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Italic.ttf": "ac3b1882325add4f148f05db8cafd401",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Regular.ttf": "5a5766c715ee765aa1398997643f1589",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Math-BoldItalic.ttf": "946a26954ab7fbd7ea78df07795a6cbc",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Math-Italic.ttf": "a7732ecb5840a15be39e1eda377bc21d",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Bold.ttf": "ad0a28f28f736cf4c121bcb0e719b88a",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Italic.ttf": "d89b80e7bdd57d238eeaa80ed9a1013a",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Regular.ttf": "b5f967ed9e4933f1c3165a12fe3436df",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Script-Regular.ttf": "55d2dcd4778875a53ff09320a85a5296",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size1-Regular.ttf": "1e6a3368d660edc3a2fbbe72edfeaa85",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size2-Regular.ttf": "959972785387fe35f7d47dbfb0385bc4",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size3-Regular.ttf": "e87212c26bb86c21eb028aba2ac53ec3",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size4-Regular.ttf": "85554307b465da7eb785fd3ce52ad282",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Typewriter-Regular.ttf": "87f56927f1ba726ce0591955c8b3b42d",
"assets/packages/flutter_tex/js/flutter_tex.css": "062a3279da48d0913eeeeb0d2266e26f",
"assets/packages/flutter_tex/js/flutter_tex.js": "102560c832679dc644c9e7f64a17cda0",
"assets/packages/flutter_tex/js/katex/auto-render.min.js": "8634ca81ec07bf42c8a5a6d433a04cd7",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_AMS-Regular.ttf": "56573229753fad48910bda2ea1a6dd54",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_AMS-Regular.woff": "10824af77e9961cfd548c8a458f10851",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_AMS-Regular.woff2": "66c678209ce93b6e2b583f02ce41529e",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Caligraphic-Bold.ttf": "497bf407c4c609c6cf1f1ad38f437f7f",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Caligraphic-Bold.woff": "de2ba279933d60f7819ff61f71c17bed",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Caligraphic-Bold.woff2": "a9e9b0953b078cd40f5e19ef4face6fc",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Caligraphic-Regular.ttf": "e6fb499fc8f9925eea3138cccba17fff",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Caligraphic-Regular.woff": "a25140fbe6692bffe71a2ab861572eb3",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Caligraphic-Regular.woff2": "08d95d99bf4a2b2dc7a876653857f154",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Fraktur-Bold.ttf": "b9d7c4497cab3702487214651ab03744",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Fraktur-Bold.woff": "40934fc076960bb989d590db044fef62",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Fraktur-Bold.woff2": "796f3797cdf36fcaea18c3070a608378",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Fraktur-Regular.ttf": "97a699d83318e9334a0deaea6ae5eda2",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Fraktur-Regular.woff": "e435cda5784e21b26ab2d03fbcb56a99",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Fraktur-Regular.woff2": "f9e6a99f4a543b7d6cad1efb6cf1e4b1",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Main-Bold.ttf": "8e431f7ece346b6282dae3d9d0e7a970",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Main-Bold.woff": "4cdba6465ab9fac5d3833c6cdba7a8c3",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Main-Bold.woff2": "a9382e25bcf75d856718fcef54d7acdb",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Main-BoldItalic.ttf": "52fb39b0434c463d5df32419608ab08a",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Main-BoldItalic.woff": "5f875f986a9bce1264e8c42417b56f74",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Main-BoldItalic.woff2": "d873734390c716d6e18ff3f71ac6eb8b",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Main-Italic.ttf": "39349e0a2b366f38e2672b45aded2030",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Main-Italic.woff": "8ffd28f6390231548ead99d7835887fa",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Main-Italic.woff2": "652970624cde999882102fa2b6a8871f",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Main-Regular.ttf": "818582dae57e6fac46202cfd844afabb",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Main-Regular.woff": "f1cdb692ee31c10b37262caffced5271",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Main-Regular.woff2": "f8a7f19f45060f7a177314855b8c7aa3",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Math-BoldItalic.ttf": "6589c4f1f587f73f0ad0af8ae35ccb53",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Math-BoldItalic.woff": "48155e43d9a284b54753e50e4ba586dc",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Math-BoldItalic.woff2": "1320454d951ec809a7dbccb4f23fccf0",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Math-Italic.ttf": "fe5ed5875d95b18c98546cb4f47304ff",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Math-Italic.woff": "ed7aea12d765f9e2d0f9bc7fa2be626c",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Math-Italic.woff2": "d8b7a801bd87b324efcbae7394119c24",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_SansSerif-Bold.ttf": "f2ac73121357210d91e5c3eaa42f72ea",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_SansSerif-Bold.woff": "0e897d27f063facef504667290e408bd",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_SansSerif-Bold.woff2": "ad546b4719bcf690a3604944b90b7e42",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_SansSerif-Italic.ttf": "f60b4a34842bb524b562df092917a542",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_SansSerif-Italic.woff": "ef725de572b71381dccf53918e300744",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_SansSerif-Italic.woff2": "e934cbc86e2d59ceaf04102c43dc0b50",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_SansSerif-Regular.ttf": "3243452ee6817acd761c9757aef93c29",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_SansSerif-Regular.woff": "5f8637ee731482c44a37789723f5e499",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_SansSerif-Regular.woff2": "1ac3ed6ebe34e473519ca1da86f7a384",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Script-Regular.ttf": "a189c37d73ffce63464635dc12cbbc96",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Script-Regular.woff": "a82fa2a7e18b8c7a1a9f6069844ebfb9",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Script-Regular.woff2": "1b3161eb8cc67462d6e8c2fb96c68507",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Size1-Regular.ttf": "0d8d9204004bdf126342605f7bbdffe6",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Size1-Regular.woff": "4788ba5b6247e336f734b742fe9900d5",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Size1-Regular.woff2": "82ef26dc680ba60d884e051c73d9a42d",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Size2-Regular.ttf": "1fdda0e59ed35495ebac28badf210574",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Size2-Regular.woff": "b0628bfd27c979a09f702a2277979888",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Size2-Regular.woff2": "95a1da914c20455a07b7c9e2dcf2836d",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Size3-Regular.ttf": "963af864cbb10611ba33267ba7953777",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Size3-Regular.woff": "4de844d4552e941f6b9c38837a8d487b",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Size3-Regular.woff2": "9108a400f4787cffdcc3a3b813401e6a",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Size4-Regular.ttf": "27a23ee69999affa55491c7dab8e53bf",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Size4-Regular.woff": "3045a61f722bc4b198450ce69b3e3824",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Size4-Regular.woff2": "61522cd3d9043622e235ab57762754f2",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Typewriter-Regular.ttf": "6bf4287568e1d3004b54d5d60f9f08f9",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Typewriter-Regular.woff": "0e0460587676d22eae09accd6dcfebc6",
"assets/packages/flutter_tex/js/katex/fonts/KaTeX_Typewriter-Regular.woff2": "b8b8393d2e65fcebda5fa99fa3264f41",
"assets/packages/flutter_tex/js/katex/index.html": "d72365d725f76c51dbcb8931ca70dd68",
"/": "0f30f2dc257f0c51e16de0d4bb0f9b86",
"assets/packages/flutter_tex/js/katex/katex.min.css": "c9f7e21f3011f52c6b9a93b6aeb92edb",
"assets/packages/flutter_tex/js/katex/katex.min.js": "b1a8a50d76f3bd8d824ac86825b6ae5b",
"assets/packages/flutter_tex/js/katex/mhchem.min.js": "9b29ccab32b45fb570484fdf14724255",
"assets/packages/flutter_tex/js/mathjax/extensions/asciimath2jax.js": "ba4a24f0884938191d5cc8a719050c08",
"assets/packages/flutter_tex/js/mathjax/extensions/AssistiveMML.js": "39c008cb2bc669cf413f7dbec5eed5c6",
"assets/packages/flutter_tex/js/mathjax/extensions/CHTML-preview.js": "ccd22964427efb2f7b8b5d47a81d0634",
"assets/packages/flutter_tex/js/mathjax/extensions/fast-preview.js": "f82f1573916c74e598b02c0739a123c0",
"assets/packages/flutter_tex/js/mathjax/extensions/FontWarnings.js": "54dc42c1c40d7965a622fb01c66b9d61",
"assets/packages/flutter_tex/js/mathjax/extensions/HelpDialog.js": "a3a81636a5169e8d4bbfd6a91e0d1ce4",
"assets/packages/flutter_tex/js/mathjax/extensions/jsMath2jax.js": "c0161a7cbc5e2b0ab68ec640b0aa8052",
"assets/packages/flutter_tex/js/mathjax/extensions/MatchWebFonts.js": "5ccc51f3e476e49f7dbe199707fb2111",
"assets/packages/flutter_tex/js/mathjax/extensions/MathEvents.js": "1ba83b0ae280ef29dab5fcd2888f5992",
"assets/packages/flutter_tex/js/mathjax/extensions/MathMenu.js": "46871bab94870bbd170c994c28b99240",
"assets/packages/flutter_tex/js/mathjax/extensions/MathML/content-mathml.js": "0ec4a3e1ad4484b0c68a6f757a244532",
"assets/packages/flutter_tex/js/mathjax/extensions/MathML/mml3.js": "d09efa633025b9964d1973933b847df6",
"assets/packages/flutter_tex/js/mathjax/extensions/MathZoom.js": "0227892f0f35af73e37a7f7019bf366d",
"assets/packages/flutter_tex/js/mathjax/extensions/mml2jax.js": "835e7b107ce67d0e09a002302b64d979",
"assets/packages/flutter_tex/js/mathjax/extensions/Safe.js": "43fcac7fb8b68b0e6026b260d29f52b9",
"assets/packages/flutter_tex/js/mathjax/extensions/TeX/action.js": "b291ae5afcf2686e6007e2ad0ac5cb07",
"assets/packages/flutter_tex/js/mathjax/extensions/TeX/AMScd.js": "3688a0945311e1a2d4422674c3978f62",
"assets/packages/flutter_tex/js/mathjax/extensions/TeX/AMSmath.js": "2a0d678068a6a80be023bad13a50d845",
"assets/packages/flutter_tex/js/mathjax/extensions/TeX/AMSsymbols.js": "aef5a6cdabcbb03c017905b91157999d",
"assets/packages/flutter_tex/js/mathjax/extensions/TeX/autobold.js": "85c15711cd25778da413647db10806f5",
"assets/packages/flutter_tex/js/mathjax/extensions/TeX/autoload-all.js": "4bd547185b751a5499f7cb74b0975f19",
"assets/packages/flutter_tex/js/mathjax/extensions/TeX/bbox.js": "ea841d1b20ee93b7ef4268301ae0d6e2",
"assets/packages/flutter_tex/js/mathjax/extensions/TeX/begingroup.js": "ad78446e91555049457f3ee8e3330ec7",
"assets/packages/flutter_tex/js/mathjax/extensions/TeX/boldsymbol.js": "567c12ebe2987167bc8bb56382c8bb23",
"assets/packages/flutter_tex/js/mathjax/extensions/TeX/cancel.js": "6b05f99b08bc0db84d1eedc95d4013ff",
"assets/packages/flutter_tex/js/mathjax/extensions/TeX/color.js": "81ada75a6f4efce1b3b317cbd693af67",
"assets/packages/flutter_tex/js/mathjax/extensions/TeX/enclose.js": "c0b4bb3761086f90c82c5cde9a173af2",
"assets/packages/flutter_tex/js/mathjax/extensions/TeX/extpfeil.js": "52e41797d7f6c1008c14e06b4bcf9a19",
"assets/packages/flutter_tex/js/mathjax/extensions/TeX/HTML.js": "dd05d732ce5a656edd0ef35488d236fe",
"assets/packages/flutter_tex/js/mathjax/extensions/TeX/mathchoice.js": "da60bce2273c8f343a89f19dd334cb0b",
"assets/packages/flutter_tex/js/mathjax/extensions/TeX/mediawiki-texvc.js": "bab41699c500f82c5e30f204689667bf",
"assets/packages/flutter_tex/js/mathjax/extensions/TeX/mhchem.js": "e2471e4a8a4f434354af76a55feab242",
"assets/packages/flutter_tex/js/mathjax/extensions/TeX/mhchem3/mhchem.js": "f29ec4834edb500aaf18d4a4ac5d94ba",
"assets/packages/flutter_tex/js/mathjax/extensions/TeX/newcommand.js": "3d30b98aa3e6f9304d8ddf2ded6def5c",
"assets/packages/flutter_tex/js/mathjax/extensions/TeX/noErrors.js": "83663e8d081cb5b405482e041be951e5",
"assets/packages/flutter_tex/js/mathjax/extensions/TeX/noUndefined.js": "133cd9dd68f0e555ecc1358fd707948f",
"assets/packages/flutter_tex/js/mathjax/extensions/TeX/text-macros.js": "e26678d55796849a74bb32e2effe9403",
"assets/packages/flutter_tex/js/mathjax/extensions/TeX/unicode.js": "6d5c8e9a1069c920832efc089e987d41",
"assets/packages/flutter_tex/js/mathjax/extensions/TeX/verb.js": "0a894ca8fcced14fb954975530d125c2",
"assets/packages/flutter_tex/js/mathjax/extensions/tex2jax.js": "6313aa4e8b7edf452102de2729ec6aed",
"assets/packages/flutter_tex/js/mathjax/extensions/toMathML.js": "bb10d4f7465fa653bbe0dde8ab4a0ac1",
"assets/packages/flutter_tex/js/mathjax/index.html": "38d1f4150e30dc63ccaebfcc9eaaa709",
"assets/packages/flutter_tex/js/mathjax/jax/element/mml/jax.js": "70c06ee3014f9b36027101a7ca1fdd0f",
"assets/packages/flutter_tex/js/mathjax/jax/element/mml/optable/Arrows.js": "cd22fc0311779024bdf280961e3e0da5",
"assets/packages/flutter_tex/js/mathjax/jax/element/mml/optable/BasicLatin.js": "cac9b2e71382e62270baa55fab07cc13",
"assets/packages/flutter_tex/js/mathjax/jax/element/mml/optable/CombDiacritMarks.js": "f93aa0e2e266bd4c584135477a8c62ed",
"assets/packages/flutter_tex/js/mathjax/jax/element/mml/optable/CombDiactForSymbols.js": "a546cc2e04b694b272d3701d0574d8cc",
"assets/packages/flutter_tex/js/mathjax/jax/element/mml/optable/Dingbats.js": "059600ef627ed3ed8bb2115b6994942a",
"assets/packages/flutter_tex/js/mathjax/jax/element/mml/optable/GeneralPunctuation.js": "da9ce79f07efe980dfd5ca66f879e739",
"assets/packages/flutter_tex/js/mathjax/jax/element/mml/optable/GeometricShapes.js": "53a4eb7cee17491160e00656b97ea5be",
"assets/packages/flutter_tex/js/mathjax/jax/element/mml/optable/GreekAndCoptic.js": "7c3c6d008598e331bae1e26fccfb7f5c",
"assets/packages/flutter_tex/js/mathjax/jax/element/mml/optable/Latin1Supplement.js": "cb26901092cf263c18de37986141dc74",
"assets/packages/flutter_tex/js/mathjax/jax/element/mml/optable/LetterlikeSymbols.js": "509f92c99cab336ecf4adec735adfaac",
"assets/packages/flutter_tex/js/mathjax/jax/element/mml/optable/MathOperators.js": "08e26ceffc57907eb6f1f4ec8dc39cd2",
"assets/packages/flutter_tex/js/mathjax/jax/element/mml/optable/MiscMathSymbolsA.js": "234873cd2f7f069a8f5616c00f7437cc",
"assets/packages/flutter_tex/js/mathjax/jax/element/mml/optable/MiscMathSymbolsB.js": "34d5c8d0c0d1efa6051845cc0830dc85",
"assets/packages/flutter_tex/js/mathjax/jax/element/mml/optable/MiscSymbolsAndArrows.js": "e8402159215942989336661560724c92",
"assets/packages/flutter_tex/js/mathjax/jax/element/mml/optable/MiscTechnical.js": "19cd81efdd76cc0fed0c14c05560761c",
"assets/packages/flutter_tex/js/mathjax/jax/element/mml/optable/SpacingModLetters.js": "a3f8559b799ecacc12683a39e2c29819",
"assets/packages/flutter_tex/js/mathjax/jax/element/mml/optable/SupplementalArrowsA.js": "4645a0b9cb5fba1b5d2ad7605e158dd1",
"assets/packages/flutter_tex/js/mathjax/jax/element/mml/optable/SupplementalArrowsB.js": "b38a7bc0f88379f31a11ae4f068b769a",
"assets/packages/flutter_tex/js/mathjax/jax/element/mml/optable/SuppMathOperators.js": "f8cc084aabc1d52fb0a94457d6d8e7e2",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/config.js": "cf85ea4a5bc5ac677243e755a7c31464",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/entities/a.js": "997185dd1d2e45dc233bd6b4dd8e4958",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/entities/b.js": "d973c36cb037c5514a73d0d9b6626966",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/entities/c.js": "4d5c64c1f1f43db2b180f499910dff56",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/entities/d.js": "9e5558405f28de118492d95d97441aea",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/entities/e.js": "c11b52d52968ce00245693c04c22d0e5",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/entities/f.js": "9277e2d9f1d4ac45b51c6aaad3c70bcb",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/entities/fr.js": "eb79fa45457e18414aef18a99d622ea4",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/entities/g.js": "5f51d546a5718a7fe99e89feba054276",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/entities/h.js": "3015ebd7f13c11e334c0a7a9ab308767",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/entities/i.js": "770ae1b26b8a2f1a593923ec33855889",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/entities/j.js": "8455021e272e277e99236b4a4fb0edd0",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/entities/k.js": "6414e632ff2cd2ec868d2976aee1018c",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/entities/l.js": "80abb62bfbdba0bb9742ffac7b034895",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/entities/m.js": "db49b39bfe1583819efdfce232b4d1e8",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/entities/n.js": "59b4b5b42fb4304785c6212c59cbb82c",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/entities/o.js": "22baa9e0bbb7760311a193a6e0b10b99",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/entities/opf.js": "a241d729bce659ffed7d91c7f66c84ac",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/entities/p.js": "ff073de21d6efae5f456d5e31c9cfc31",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/entities/q.js": "632221c21f96010d8bdc81bbc62b8526",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/entities/r.js": "8bf057da0768d9dbf0cfe4fef625f548",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/entities/s.js": "99fb74daf2d1fd537f7ce35b916fc793",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/entities/scr.js": "d7f570707643fba84335a507bc9a35cc",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/entities/t.js": "ac6fae5975acbc3a673f8547daa7973f",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/entities/u.js": "4d765eac78c0046d5552654eea91e4c9",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/entities/v.js": "c44170b66aa9a7287b1158006b3a0e16",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/entities/w.js": "d3ba9e2084b7adf1866b70f6cb9dd413",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/entities/x.js": "af4e41f5e5158b126edb92261a52918b",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/entities/y.js": "f9807dae1160344aa125404301c8bba0",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/entities/z.js": "f1e3d439bf2837ef365dd1c39484fd1c",
"assets/packages/flutter_tex/js/mathjax/jax/input/MathML/jax.js": "addaed8cba00c8777540933e45cf9807",
"assets/packages/flutter_tex/js/mathjax/jax/input/TeX/config.js": "c6de0381e92b311e75264dac618de39d",
"assets/packages/flutter_tex/js/mathjax/jax/input/TeX/jax.js": "095f5949e9fcae675246f56a4fa5fa75",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/autoload/annotation-xml.js": "5c0a5ac13c601aaa920fe9a99eed23fa",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/autoload/maction.js": "6267f292f88b2f7a011d43e7b2288375",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/autoload/menclose.js": "7b2ea9eb6ab045b23927ad91ca7269e4",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/autoload/mglyph.js": "2fed982e207e72c96899caf9d25dca64",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/autoload/mmultiscripts.js": "5f56f7566baf73e3e745f5f4325e6645",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/autoload/ms.js": "d6a2a58b5b979b352c0fa9919772618c",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/autoload/mtable.js": "b8c87ca1398f29238deb7235a08508ca",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/autoload/multiline.js": "dbf95bacbdf5b615b1c4c768aa13e192",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/config.js": "2331dfa04ed33a371d8735e1798c4980",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/fonts/Gyre-Pagella/Alphabets/Regular/Main.js": "efe14a410f0f6068cc8f3295492e9c8a",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/fonts/Gyre-Pagella/Arrows/Regular/Main.js": "665c0e57895adfb6966675bebdf83863",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/fonts/Gyre-Pagella/DoubleStruck/Regular/Main.js": "05efb6ce00d94b5cf3837dff31b3f71c",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/fonts/Gyre-Pagella/fontdata-extra.js": "1f8deeefc60655afe9fa112bd0a0713d",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/fonts/Gyre-Pagella/fontdata.js": "df1b5ef97cf27cab4d02762d04df2b19",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/fonts/Gyre-Pagella/Fraktur/Regular/Main.js": "e3614ebdb6144db9f6a7eaa8d28abfb9",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/fonts/Gyre-Pagella/Latin/Regular/Main.js": "6ea87ff970625b5e69720cea202b3d72",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/fonts/Gyre-Pagella/Main/Regular/Main.js": "18979444cbc184de17d8211badbde33a",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/fonts/Gyre-Pagella/Marks/Regular/Main.js": "1ba4c71aae376a97764d6d987c352727",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/fonts/Gyre-Pagella/Misc/Regular/Main.js": "83905891ae1c1ba5113af6dd20752d3f",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/fonts/Gyre-Pagella/Monospace/Regular/Main.js": "da942728fba8835448b144bf5978c64d",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/fonts/Gyre-Pagella/NonUnicode/Regular/Main.js": "405ada06bcbd00ce0d8bcbb25a090060",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/fonts/Gyre-Pagella/Normal/Regular/Main.js": "076ba0f589c1743a9c62aa91d42a0bef",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/fonts/Gyre-Pagella/Operators/Regular/Main.js": "dee87779bf7bd236dfa2582f5c67100e",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/fonts/Gyre-Pagella/SansSerif/Regular/Main.js": "3aa7be9c67f8d7964473e683c646a895",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/fonts/Gyre-Pagella/Script/Regular/Main.js": "0a4bed2eb2cdd41e0ea0f0fba08bd761",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/fonts/Gyre-Pagella/Shapes/Regular/Main.js": "ace21a50708f5f803b02c659981bbb8f",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/fonts/Gyre-Pagella/Size1/Regular/Main.js": "288666c04f3e95c93475786725e042aa",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/fonts/Gyre-Pagella/Size2/Regular/Main.js": "288e754ba2854b9523cbcea6ebbbb60c",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/fonts/Gyre-Pagella/Size3/Regular/Main.js": "632d9bde1dfa761e0b8ca7f6ad528f99",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/fonts/Gyre-Pagella/Size4/Regular/Main.js": "b619df9dbc3d32cf4bf4050a9c0bd4f7",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/fonts/Gyre-Pagella/Size5/Regular/Main.js": "fddbbbcd462a8e11582c211334afea0f",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/fonts/Gyre-Pagella/Size6/Regular/Main.js": "aeb0ccd2bd94068b57dbf4639961de84",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/fonts/Gyre-Pagella/Symbols/Regular/Main.js": "d0990851f00fd8c80cc70a31d016110d",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/fonts/Gyre-Pagella/Variants/Regular/Main.js": "a0e179664a7f9c7429169f18c62423fa",
"assets/packages/flutter_tex/js/mathjax/jax/output/SVG/jax.js": "983708db351371378d03356a7848f4d1",
"assets/packages/flutter_tex/js/mathjax/LICENSE": "3b83ef96387f14655fc854ddc3c6bd57",
"assets/packages/flutter_tex/js/mathjax/MathJax.js": "b2c103388b71bb3d11cbf9aa45fe9b68",
"assets/packages/math_keyboard/fonts/CustomKeyIcons.ttf": "b0bace3f25c2bd05862680e5ad4c6b54",
"canvaskit/canvaskit.js": "97937cb4c2c2073c968525a3e08c86a3",
"canvaskit/canvaskit.wasm": "3de12d898ec208a5f31362cc00f09b9e",
"canvaskit/profiling/canvaskit.js": "c21852696bc1cc82e8894d851c01921a",
"canvaskit/profiling/canvaskit.wasm": "371bc4e204443b0d5e774d64a046eb99",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "a85fcf6324d3c4d3ae3be1ae4931e9c5",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "0f30f2dc257f0c51e16de0d4bb0f9b86",
"main.dart.js": "0fec3358a2181fc2a855ba4db5fad406",
"manifest.json": "ef7948be2c1f37b325a01798c9a0d666",
"version.json": "8eee33a88a0318d2cf51bb121025f70c"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
