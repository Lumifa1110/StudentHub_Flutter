import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studenthub/components/textfield_label_v2.dart';
import 'package:studenthub/utils/colors.dart';

class BottomSheetSchedule extends StatefulWidget {
  final String title;
  final DateTime startDate;
  final DateTime endDate;

  const BottomSheetSchedule({
    Key? key,
    required this.title,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  _BottomSheetScheduleState createState() => _BottomSheetScheduleState();
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Schedule a video call interview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: blackTextColor,
            ),
          ),
          TextFieldWithLabel2(
            label: 'Title',
            controller: _titleController,
            hint: 'Enter title for meeting',
          ),
          const SizedBox(height: 10),
          const Text(
            'Start time',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: blackTextColor,
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
          const SizedBox(height: 10),
          const Text(
            'End time',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: blackTextColor,
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
          Text('Duration: ${_duration.inMinutes} minutes'),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 180,
                height: 40,
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  border: Border.all(color: blackTextColor, width: 2.0),
                  color: whiteTextColor,
                  boxShadow: const [
                    BoxShadow(
                      color: blackTextColor,
                      offset: Offset(2, 3),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      color: blackTextColor,
                    ),
                  ),
                ),
              ),
              Container(
                width: 180,
                height: 40,
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  border: Border.all(color: blackTextColor, width: 2.0),
                  color: whiteTextColor,
                  boxShadow: const [
                    BoxShadow(
                      color: blackTextColor,
                      offset: Offset(2, 3),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Send Invite',
                    style: TextStyle(
                      fontSize: 16,
                      color: blackTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
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
