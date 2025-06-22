import 'package:flutter/material.dart';
import 'package:app_tieng_anh/config/theme.dart';
import '../../services/user_api.dart';
import '../../models/user.dart';
import 'register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home/home_page.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleLogin() async {
    // Xác thực đầu vào cơ bản
    if (_usernameController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng nhập tên đăng nhập và mật khẩu';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await UserApi.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );
      print(response['user']);
      if (response['message'] == "Đăng nhập thành công") {
        Users user = Users.fromJson(response['user']);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Đăng nhập thành công: ${user.name}')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChonLoaiCauHoiScreen(userId: user.id),
            ),
          );
        }
      } else {
        setState(() {
          _errorMessage = response['message'];
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 5), // Đẩy toàn bộ biểu mẫu xuống một chút
                  // Nút quay lại
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: AppColors.backIcon),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Tiêu đề
                  const Text(
                    'Đăng nhập',
                    style: TextStyle(
                      color: AppColors.whiteText,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60), // Khoảng cách đã điều chỉnh
                  // Hình ảnh logo
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0), // Giảm để đưa hình ảnh gần hơn với ô nhập
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/duo7.gif', // Đường dẫn hình ảnh của bạn
                            width: 150, // Kích thước phù hợp từ yêu cầu trước
                            height: 150,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Ô nhập Tên đăng nhập/Email
                  TextField(
                    controller: _usernameController,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Tên đăng nhập hoặc email',
                      hintStyle: AppTextStyles.subTitle_1,
                      filled: true,
                      fillColor: const Color.fromARGB(255, 53, 50, 50),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.dialogBorder,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.dialogBorder,
                        ),
                      ),
                    ),
                    style: const TextStyle(color: AppColors.whiteText),
                  ),
                  const SizedBox(height: 16),
                  // Ô nhập Mật khẩu với nút hiển thị/ẩn
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Mật khẩu',
                      hintStyle: AppTextStyles.subTitle_1,
                      filled: true,
                      fillColor: const Color.fromARGB(255, 53, 50, 50),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.dialogBorder,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.dialogBorder,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: AppColors.buttonGreen,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    style: const TextStyle(color: AppColors.whiteText),
                  ),
                  const SizedBox(height: 16),
                  // Thông báo lỗi
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  // Nút đăng nhập
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: AppColors.whiteText,
                          )
                        : const Text(
                            'ĐĂNG NHẬP',
                            style: AppTextStyles.buttonTextPrimary,
                          ),
                  ),
                  const SizedBox(height: 16),
                  // Liên kết đăng ký
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Chưa có tài khoản?',
                          style: TextStyle(
                            color: Color.fromARGB(255, 119, 118, 118),
                            fontSize: 18,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Đăng ký',
                            style: TextStyle(
                              color: AppColors.buttonGreen,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(height: 16),
                  // Văn bản chân trang
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Khi đăng ký trên Duolingo, bạn đã đồng ý với Điều khoản và Chính sách bảo mật của chúng tôi.',
                      style: AppTextStyles.subTitle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}