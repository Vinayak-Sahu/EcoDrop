import 'package:flutter/material.dart';
import 'dart:math';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizCompleted = false;
  late List<Map<String, dynamic>> _questions;
  final int _numberOfQuestions = 5; // Number of questions to show in each quiz
  int? _selectedAnswer;
  bool _isAnswerChecked = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final List<Map<String, dynamic>> _allQuestions = [
    {
      'question': 'What is e-waste?',
      'options': [
        'Electronic devices that are still working',
        'Discarded electronic devices and equipment',
        'New electronic devices',
        'Electronic devices for sale',
      ],
      'correctAnswer': 1,
    },
    {
      'question': 'Which of these is NOT a common e-waste item?',
      'options': [
        'Mobile phones',
        'Plastic bottles',
        'Laptops',
        'Batteries',
      ],
      'correctAnswer': 1,
    },
    {
      'question': 'What should you do before recycling a device?',
      'options': [
        'Throw it in the trash',
        'Wipe personal data and remove batteries',
        'Break it into pieces',
        'Leave it as is',
      ],
      'correctAnswer': 1,
    },
    {
      'question': 'Which harmful material is commonly found in e-waste?',
      'options': [
        'Water',
        'Lead',
        'Paper',
        'Wood',
      ],
      'correctAnswer': 1,
    },
    {
      'question': 'What is one benefit of recycling e-waste?',
      'options': [
        'It creates more waste',
        'It pollutes the environment',
        'It recovers valuable materials',
        'It increases energy consumption',
      ],
      'correctAnswer': 2,
    },
    {
      'question': 'How much e-waste is generated globally each year?',
      'options': [
        'Less than 1 million tons',
        'Around 10 million tons',
        'Over 50 million tons',
        'More than 100 million tons',
      ],
      'correctAnswer': 2,
    },
    {
      'question': 'Which country generates the most e-waste per capita?',
      'options': [
        'India',
        'China',
        'Norway',
        'United States',
      ],
      'correctAnswer': 2,
    },
    {
      'question': 'What percentage of e-waste is properly recycled globally?',
      'options': [
        'Less than 20%',
        'Around 40%',
        'More than 60%',
        'Over 80%',
      ],
      'correctAnswer': 0,
    },
    {
      'question': 'Which valuable metal is commonly found in e-waste?',
      'options': [
        'Iron',
        'Gold',
        'Aluminum',
        'Copper',
      ],
      'correctAnswer': 1,
    },
    {
      'question': 'What is the best way to dispose of old batteries?',
      'options': [
        'Throw them in regular trash',
        'Bury them in the ground',
        'Take them to a battery recycling center',
        'Throw them in the ocean',
      ],
      'correctAnswer': 2,
    },
    {
      'question':
          'How long does it take for e-waste to decompose in landfills?',
      'options': [
        'A few months',
        'A few years',
        'Decades',
        'It never decomposes',
      ],
      'correctAnswer': 3,
    },
    {
      'question': 'What is the main reason for recycling e-waste?',
      'options': [
        'To make money',
        'To protect the environment and human health',
        'To create jobs',
        'To reduce storage space',
      ],
      'correctAnswer': 1,
    },
    {
      'question': 'Which of these is a safe way to dispose of old phones?',
      'options': [
        'Throw them in the river',
        'Burn them',
        'Take them to certified e-waste recyclers',
        'Bury them',
      ],
      'correctAnswer': 2,
    },
    {
      'question':
          'What happens to data on devices that aren\'t properly wiped?',
      'options': [
        'Nothing',
        'It disappears automatically',
        'It can be recovered by others',
        'It becomes encrypted',
      ],
      'correctAnswer': 2,
    },
    {
      'question':
          'Which organization regulates e-waste disposal in most countries?',
      'options': [
        'Local governments',
        'International organizations',
        'Private companies',
        'No one regulates it',
      ],
      'correctAnswer': 0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _randomizeQuestions();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _randomizeQuestions() {
    final random = Random();
    _questions = List.from(_allQuestions);
    _questions.shuffle(random);
    _questions = _questions.take(_numberOfQuestions).toList();
  }

  void _checkAnswer(int selectedAnswer) {
    if (_isAnswerChecked) return;

    setState(() {
      _selectedAnswer = selectedAnswer;
      _isAnswerChecked = true;
    });

    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    if (selectedAnswer == _questions[_currentQuestionIndex]['correctAnswer']) {
      setState(() {
        _score++;
      });
    }

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _selectedAnswer = null;
          _isAnswerChecked = false;
          if (_currentQuestionIndex < _questions.length - 1) {
            _currentQuestionIndex++;
          } else {
            _quizCompleted = true;
          }
        });
      }
    });
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _quizCompleted = false;
      _randomizeQuestions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Waste Quiz'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _quizCompleted ? _buildQuizResult() : _buildQuizQuestion(),
      ),
    );
  }

  Widget _buildQuizQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Progress indicator
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / _questions.length,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 24),

        // Question number
        Text(
          'Question ${_currentQuestionIndex + 1}/${_questions.length}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 8),

        // Question text
        Expanded(
          child: Center(
            child: Text(
              _questions[_currentQuestionIndex]['question'],
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        // Options
        ...List.generate(
          _questions[_currentQuestionIndex]['options'].length,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: _getOptionBorderColor(index),
                    width: 2,
                  ),
                  color: _getOptionBackgroundColor(index),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _checkAnswer(index),
                    borderRadius: BorderRadius.circular(30),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              _questions[_currentQuestionIndex]['options']
                                  [index],
                              style: TextStyle(
                                fontSize: 16,
                                color: _isAnswerChecked
                                    ? Colors.white
                                    : Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          if (_isAnswerChecked &&
                              index ==
                                  _questions[_currentQuestionIndex]
                                      ['correctAnswer'])
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Icon(Icons.check_circle,
                                  color: Colors.white, size: 20),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getOptionBorderColor(int index) {
    if (!_isAnswerChecked) {
      return Theme.of(context).colorScheme.primary.withOpacity(0.3);
    }

    if (index == _questions[_currentQuestionIndex]['correctAnswer']) {
      return Colors.green;
    }

    if (index == _selectedAnswer) {
      return Colors.red;
    }

    return Colors.transparent;
  }

  Color _getOptionBackgroundColor(int index) {
    if (!_isAnswerChecked) {
      return Colors.transparent;
    }

    if (index == _questions[_currentQuestionIndex]['correctAnswer']) {
      return Colors.green.withOpacity(0.2);
    }

    if (index == _selectedAnswer) {
      return Colors.red.withOpacity(0.2);
    }

    return Colors.transparent;
  }

  Widget _buildQuizResult() {
    final percentage = (_score / _questions.length) * 100;
    String message;
    IconData icon;
    Color color;
    String emoji;

    if (_score == _questions.length) {
      message = 'Excellent! You\'re an e-waste expert!';
      icon = Icons.emoji_events;
      color = Colors.amber;
      emoji = '🏆';
    } else if (percentage >= 80) {
      message = 'Great job! You know a lot about e-waste!';
      icon = Icons.thumb_up;
      color = Colors.green;
      emoji = '🌟';
    } else if (percentage >= 60) {
      message = 'Good effort! Keep learning about e-waste!';
      icon = Icons.school;
      color = Colors.blue;
      emoji = '👍';
    } else {
      message = 'Try again! You can do better!';
      icon = Icons.refresh;
      color = Colors.orange;
      emoji = '💪';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 80),
          ),
          const SizedBox(height: 24),
          Text(
            'Quiz Complete!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your Score: $_score/${_questions.length}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _restartQuiz,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.exit_to_app),
            label: const Text('Exit Quiz'),
          ),
        ],
      ),
    );
  }
}
