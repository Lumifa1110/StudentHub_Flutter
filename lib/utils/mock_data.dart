class Project {
  final String titleOfJob;
  final String projectDetail;
  final String studentGain;
  final String projectScope;
  final String requireStudents;
  final String author;
  final String timeCreated;
  final String numOfProposals;

  Project({
    required this.titleOfJob,
    required this.projectDetail,
    required this.studentGain,
    required this.projectScope,
    required this.requireStudents,
    required this.author,
    required this.timeCreated,
    required this.numOfProposals,
  });
}

List<Project> mockProjects = [
  Project(
    titleOfJob: 'Mobile App Development',
    projectDetail: 'Develop a mobile app for task management',
    studentGain:
        'Student looking for:\n- clear expectation about your project or deliverable\n- the skill required for your project',
    projectScope: '1 to 3 months',
    requireStudents: '6 students',
    author: 'Tech Solutions Inc.',
    timeCreated: '3 days',
    numOfProposals: 'less than 5',
  ),
  Project(
    titleOfJob: 'Mobile App Development',
    projectDetail: 'Develop a mobile app for task management',
    studentGain:
        'Student looking for:\t\n- clear expectation about your project or deliverable\t\n- the skill required for your project',
    projectScope: '3 to 6 months',
    requireStudents: '6 students',
    author: 'Tech Solutions Inc.',
    timeCreated: '1 hours',
    numOfProposals: 'less than 5',
  ),
  Project(
    titleOfJob: 'Mobile App Development',
    projectDetail: 'Develop a mobile app for task management',
    studentGain:
        'Student looking for:\t\n- clear expectation about your project or deliverable\t\n- the skill required for your project',
    projectScope: '3 to 6 months',
    requireStudents: '6 students',
    author: 'Tech Solutions Inc.',
    timeCreated: '1 week',
    numOfProposals: 'less than 5',
  ),
  Project(
    titleOfJob: 'Mobile App Development',
    projectDetail: 'Develop a mobile app for task management',
    studentGain:
        'Student looking for:\t\n- clear expectation about your project or deliverable\t\n- the skill required for your project',
    projectScope: '3 to 6 months',
    requireStudents: '6 students',
    author: 'Tech Solutions Inc.',
    timeCreated: '1 week',
    numOfProposals: 'less than 5',
  ),
  Project(
    titleOfJob: 'Mobile App Development',
    projectDetail: 'Develop a mobile app for task management',
    studentGain:
        'Student looking for:\t\n- clear expectation about your project or deliverable\t\n- the skill required for your project',
    projectScope: '3 to 6 months',
    requireStudents: '6 students',
    author: 'Tech Solutions Inc.',
    timeCreated: '1 week',
    numOfProposals: 'less than 5',
  ),
];
