import 'package:faleh_hafez/presentation/home/components/button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

bool isShowAthanLogo = false;

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  void initState() {
    super.initState();
    isShowAthanLogo = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'درباره ما',
          style: TextStyle(
            fontFamily: 'iranSans',
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                'ما در این اپلیکیشن به نام "فال حافظ" توانسته‌ایم یک تجربه جذاب و منحصربه‌فرد را برای کاربران خود فراهم کنیم. با این اپلیکیشن، کاربران می‌توانند به سادگی و به صورت خودکار از تعبیر فال‌های مختلفی از جمله فال تاروت، جادویی، روزانه و... بهره‌مند شوند.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontFamily: 'vazir',
                ),
              ),
            ),
            const SizedBox(height: 5),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                'تمامی فال‌های ارائه شده در این اپلیکیشن، با دقت و دانش تخصصی از جانب کارشناسان و استادان متخصص ارائه می‌شوند تا به کاربران کمک کنند تا بهترین تفسیر را برای سوالات و نیازهایشان داشته باشند.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontFamily: 'vazir',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Divider(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                'ویژگی‌های اصلی این اپلیکیشن شامل :',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 18,
                  fontFamily: 'iranSans',
                ),
              ),
            ),
            const SizedBox(height: 15),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                '1)  تنوع در فال‌ها: ارائه انواع مختلف فال‌ها از جمله تاروت، جادویی، روزانه، عشق و روابط، شانس و... برای پاسخ به نیازهای مختلف کاربران.\n\n2) خودکارسازی: این اپلیکیشن با بهره‌گیری از الگوریتم‌های پیشرفته، به صورت خودکار فال‌ها را برای کاربران ارائه می‌دهد، بدون نیاز به تداخل انسانی. \n\n3) دقت و تخصص: تفسیرات ارائه شده توسط این اپلیکیشن، بر اساس دانش و تخصص کارشناسان متخصص صورت می‌گیرد تا بهترین تجربه ممکن برای کاربران فراهم شود. \n\n4) رابط کاربری کارآمد: رابط کاربری ساده و دوستانه که امکان دسترسی آسان و سریع به فال‌ها را برای همه ارائه می‌دهد.',
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontFamily: 'lalezar',
                ),
              ),
            ),
            // Container(
            //   margin: const EdgeInsets.symmetric(vertical: 5),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10),
            //     color: Theme.of(context).colorScheme.primary,
            //   ),
            //   child: TextButton(
            //     onPressed: () => setState(() {
            //       if (isShowAthanLogo) {
            //         isShowAthanLogo = false;
            //       } else {
            //         isShowAthanLogo = true;
            //       }
            //     }),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         Text(
            //           'Developer Info',
            //           style: TextStyle(
            //             color: Theme.of(context).colorScheme.onPrimary,
            //             fontSize: 20,
            //             fontWeight: FontWeight.w700,
            //           ),
            //         ),
            //         const Image(
            //           image:
            //               AssetImage('assets/images/ATHAN_Logo_black_PNG.png'),
            //           height: 40,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // Center(
            //   child: Visibility(
            //     visible: isShowAthanLogo,
            //     child: Container(
            //       decoration: BoxDecoration(
            //         color: Theme.of(context).colorScheme.primary,
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //       padding: const EdgeInsets.symmetric(
            //         horizontal: 30,
            //         vertical: 15,
            //       ),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: [
            //           const Image(
            //             height: 40,
            //             image: AssetImage(
            //               'assets/images/ATHAN_Logo_black_PNG.png',
            //             ),
            //           ),
            //           const SizedBox(
            //             width: 10,
            //           ),
            //           TextButton(
            //             onPressed: () async {
            //               try {
            //                 final url = Uri.parse(
            //                     'https://www.instagram.com/m_m_d_r_e_z_a/');
            //                 await launchUrl(url);
            //               } catch (e) {
            //                 throw 'Could not launch';
            //               }
            //             },
            //             child: Container(
            //               padding: const EdgeInsets.all(10),
            //               decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(5),
            //                 color: Theme.of(context).colorScheme.onPrimary,
            //               ),
            //               child: Row(
            //                 children: [
            //                   const Image(
            //                     height: 25,
            //                     image: AssetImage(
            //                       'assets/images/instagram.png',
            //                     ),
            //                   ),
            //                   const SizedBox(width: 25),
            //                   Text(
            //                     "Instagram Profile",
            //                     style: TextStyle(
            //                       color: Theme.of(context).colorScheme.primary,
            //                       fontWeight: FontWeight.w700,
            //                       fontSize: 20,
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
