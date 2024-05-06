import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studenthub/components/index.dart';
import 'package:studenthub/components/textfield/textfield_label_v2.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class BottomSheetSchedule extends StatefulWidget {
  final int? interviewId;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final bool enableEdit;
  final Function(String, DateTime, DateTime)? handleCreateInterview;
  final Function(int, String, DateTime, DateTime)? handleEditInterview;

  const BottomSheetSchedule(
      {super.key,
      this.interviewId,
      required this.title,
      required this.startDate,
      required this.endDate,
      required this.enableEdit,
      this.handleCreateInterview,
      this.handleEditInterview});

  @override
  State<BottomSheetSchedule> createState() => _BottomSheetScheduleState();
}

class _BottomSheetScheduleState extends State<BottomSheetSchedule> {
  late TextEditingController _titleController;
  late Duration _duration;
  late DateTime _startDate;
  late DateTime _endDate;

  String? _errorText;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _duration = const Duration(minutes: 60);
    _startDate = widget.startDate;
    _endDate = widget.endDate.add(_duration);
  }

  String calculateDuration(DateTime startTime, DateTime endTime) {
    Duration difference = endTime.difference(startTime);
    int hours = difference.inHours;
    int minutes = difference.inMinutes.remainder(60);
    if (hours > 0 && minutes > 0) {
      return '$hours hour${hours > 1 ? 's' : ''} $minutes minute${minutes > 1 ? 's' : ''}';
    } else if (hours > 0) {
      return '$hours hour${hours > 1 ? 's' : ''}';
    } else {
      return '$minutes minute${minutes > 1 ? 's' : ''}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Schedule a video call interview',
            style: TextStyle(
              fontSize: AppFonts.h2FontSize,
              fontWeight: FontWeight.bold,
              color: blackTextColor,
            ),
          ),
          TextFieldWithLabel2(
            label: 'Title',
            controller: _titleController,
            hint: 'Enter title for meeting',
          ),
          const SizedBox(height: 20),
          const Text(
            'Start time',
            style: TextStyle(
              fontSize: AppFonts.h3FontSize,
              fontWeight: FontWeight.w500,
              color: AppFonts.secondaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 120, // Set a fixed width
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: whiteTextColor,
                  border: Border.all(color: blackTextColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: InkWell(
                  onTap: () => _selectDate(context, true),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${_startDate.day}/${_startDate.month}/${_startDate.year}",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () => _selectDate(context, true),
                icon: const FaIcon(FontAwesomeIcons.calendarDays),
              ),
              const SizedBox(width: 10),
              // Display time
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: whiteTextColor,
                  border: Border.all(color: blackTextColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                width: 80,
                child: InkWell(
                  onTap: () async {
                    final TimeOfDay? timeOfDay = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(
                          hour: _startDate.hour, minute: _startDate.minute),
                    );
                    if (timeOfDay != null) {
                      setState(() {
                        _startDate = DateTime(_startDate.year, _startDate.month,
                            _startDate.day, timeOfDay.hour, timeOfDay.minute);
                        validateDate(_startDate, _endDate);
                      });
                    }
                  },
                  child: Text(
                    "${_startDate.hour}:${_startDate.minute}",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 30),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'End time',
            style: TextStyle(
              fontSize: AppFonts.h3FontSize,
              fontWeight: FontWeight.w500,
              color: AppFonts.secondaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 120,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: whiteTextColor,
                  border: Border.all(color: blackTextColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: InkWell(
                  onTap: () => _selectDate(context, false),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${_endDate.day}/${_endDate.month}/${_endDate.year}",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () => _selectDate(context, false),
                icon: const FaIcon(FontAwesomeIcons.calendarDays),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: whiteTextColor,
                  border: Border.all(color: blackTextColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                width: 80,
                child: InkWell(
                  onTap: () async {
                    final TimeOfDay? timeOfDay = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(
                          hour: _endDate.hour, minute: _endDate.minute),
                    );
                    if (timeOfDay != null) {
                      setState(() {
                        _endDate = DateTime(_endDate.year, _endDate.month,
                            _endDate.day, timeOfDay.hour, timeOfDay.minute);
                        validateDate(_startDate, _endDate);
                      });
                    }
                  },
                  child: Text(
                    "${_endDate.hour}:${_endDate.minute}",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 30),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          _errorText != null
              ? Text(
                  _errorText!,
                  style: const TextStyle(color: Colors.red),
                )
              : const SizedBox(),
          Text('Duration: ${calculateDuration(_startDate, _endDate)}'),
          const SizedBox(height: 40),
          SizedBox(
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE8E8E8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center, // Center the text
                  ),
                  child: const Text('Cancel',
                      style: TextStyle(
                          color: AppFonts.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
                ButtonSimple(
                    label: 'Confirm',
                    onPressed: () {
                      if (widget.enableEdit) {
                        widget.handleEditInterview!(widget.interviewId!,
                            _titleController.text, _startDate, _endDate);
                      } else {
                        widget.handleCreateInterview!(
                            _titleController.text, _startDate, _endDate);
                      }
                      Navigator.pop(context);
                    },
                    isButtonEnabled: _titleController.text.isNotEmpty),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          validateDate(_startDate, _endDate);
        } else {
          _endDate = picked;
          validateDate(_startDate, _endDate);
        }
      });
    }
  }

  void validateDate(DateTime dateStart, DateTime dateEnd) {
    if (dateEnd.isBefore(dateStart)) {
      setState(() {
        _errorText = 'Selected start and end times are incorrect.';
      });
    } else {
      setState(() {
        _errorText = null;
      });
    }
  }
}
