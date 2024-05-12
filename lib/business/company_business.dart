String convertProjectScoreFlagToTime(int flag) {
  if (flag == 0) {
    return 'Less Than 1 Month';
  } else if (flag == 1) {
    return '1 to 3 months';
  } else if (flag == 2) {
    return '3 to 6 months';
  } else {
    return 'More than 6 months';
  }
}
