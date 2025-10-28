import 'package:diety/core/constants/app_colors.dart';
import 'package:diety/presentation/widgets/right_side_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: const RightSideDrawer(),
          appBar: AppBar(
            title: Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * .025,
              ),
              child: GestureDetector(
                onTap: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                child: Align(
                  alignment: AlignmentGeometry.topLeft,
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: MediaQuery.of(context).size.height * .04,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            elevation: 4,
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            leading: Builder(
              builder: (context) => InkWell(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .08,
                        height: MediaQuery.of(context).size.height * .007,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .004,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .08,
                        height: MediaQuery.of(context).size.height * .007,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Leader Pop',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'سياسة الخصوصية وبيان سرية المعلومات',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'تاريخ آخر تحديث: سبتمبر 2025 | تاريخ السريان: سبتمبر 2025',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('1. مقدمة'),
                  _buildParagraph(
                    'نحن في Leader Pop نلتزم بحماية خصوصيتكم وضمان أمان بياناتكم الشخصية. تشرح هذه السياسة كيفية جمعنا واستخدامنا وحمايتنا ومشاركتنا للمعلومات الشخصية التي تقدمونها لنا عند استخدام موقعنا الإلكتروني وخدماتنا.',
                  ),
                  _buildSectionTitle('2. المعلومات التي نجمعها'),
                  _buildSubTitle('2.1 المعلومات التي تقدمونها مباشرة'),
                  _buildList([
                    'البيانات الشخصية: الاسم، عنوان البريد الإلكتروني، رقم الهاتف، العنوان',
                    'معلومات الحساب: اسم المستخدم، كلمة المرور، تفضيلات الحساب',
                    'المحتوى: التعليقات، المراجعات، الرسائل، الملفات المحملة',
                    'المعلومات المالية: بيانات بطاقات الائتمان، معلومات الدفع (مشفرة ومحمية)',
                  ]),
                  _buildSubTitle('2.2 المعلومات المجمعة تلقائياً'),
                  _buildList([
                    'معلومات تقنية: عنوان IP، نوع المتصفح، نظام التشغيل، إعدادات اللغة',
                    'بيانات الاستخدام: الصفحات المزارة، وقت التصفح، مسار التنقل، تكرار الزيارات',
                    'معلومات الجهاز: معرف الجهاز، معلومات الشبكة، بيانات الموقع الجغرافي',
                  ]),
                  _buildSectionTitle('3. كيفية استخدام المعلومات'),
                  _buildSubTitle('3.1 تقديم الخدمات'),
                  _buildList([
                    'تشغيل وصيانة الموقع والخدمات',
                    'معالجة الطلبات والمعاملات المالية',
                    'تقديم الدعم الفني وخدمة العملاء',
                    'إنشاء وإدارة حساباتكم',
                  ]),
                  _buildSectionTitle('12. معلومات الاتصال'),
                  _buildSubTitle('12.1 معلومات الشركة'),
                  _buildList([
                    'اسم الشركة: Leader Pop',
                    'البريد الإلكتروني: hello@diety.tn',
                    'الموقع الإلكتروني: leaderpop.net',
                  ]),
                  _buildSectionTitle('13. الاختصاص القضائي والقانون المطبق'),
                  _buildSubTitle('13.1 القانون المطبق'),
                  _buildParagraph(
                    'تخضع هذه السياسة وتفسر وفقاً للقوانين التونسية وأنظمتها النافذة.',
                  ),
                  _buildSubTitle('13.2 حل النزاعات والاختصاص القضائي'),
                  _buildList([
                    'نفضل حل النزاعات بالتفاوض والوساطة',
                    'جميع النزاعات والخلافات يجب أن تُعرض حصرياً على المحاكم المختصة لمدينة تونس',
                    'لا يمكن تغيير الاختصاص القضائي أو المكان حتى بعد الطعن',
                  ]),
                  const SizedBox(height: 24),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      children: const [
                        TextSpan(
                          text: 'ملاحظة مهمة: ',
                          style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              'هذه الوثيقة تحتوي على جميع المعلومات الجوهرية حول كيفية تعاملنا مع بياناتكم الشخصية. إذا كان لديكم أي أسئلة أو مخاوف، لا تترددوا في التواصل معنا.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF007AFF),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSubTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 6.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF262F82),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(text, style: const TextStyle(fontSize: 16, height: 1.6)),
    );
  }

  Widget _buildList(List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(fontSize: 16, height: 1.6),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
