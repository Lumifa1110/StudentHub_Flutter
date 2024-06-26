
class Proposal {
   final String position;
   final int postingTime;
   final int numberOfStudents;
   final String executionTime;
   final List<String> description;
   final bool working;

   Proposal({
     required this.position,
     required this.postingTime,
     required this.numberOfStudents,
     required this.executionTime,
     required this.description,
     required this.working,
});
}
 List<Proposal> mockProposal = [
   Proposal(
     position: 'Senior front end developer(Fintech)',
     postingTime: 3,
     numberOfStudents: 4,
     executionTime: '1-3 months',
     description: ["clear expectation about your project or deliverables", ],
     working: false,
   ),
   Proposal(
       position: 'Senior front end developer(Fintech)',
       postingTime: 3,
       numberOfStudents: 4,
       executionTime: '4-6 months',
       description: ["clear expectation about your project or deliverables", ],
       working: true,
   )
 ];

class Project {
  final String projectId;
  final String titleOfJob;
  final String projectDetail;
  final String studentGain;
  final String projectScope;
  final String requireStudents;
  final String author;
  final String timeCreated;
  final String numOfProposals;

  Project({
    required this.projectId,
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
    projectId: '00000001',
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
    projectId: '00000002',
    titleOfJob: 'Wed App Development',
    projectDetail: 'Develop a web app for task management',
    studentGain:
        'Student looking for:\n\t\t\t\t\t\t-clear expectation about your project or deliverable\n\t\t\t\t\t\t-the skill required for your project',
    projectScope: '3 to 6 months',
    requireStudents: '6 students',
    author: 'Tech Solutions Inc.',
    timeCreated: '1 hours',
    numOfProposals: 'less than 5',
  ),
  Project(
    projectId: '00000003',
    titleOfJob: 'Database Development',
    projectDetail: 'Develop a database for task management',
    studentGain:
        'Student looking for:\t\n- clear expectation about your project or deliverable\t\n- the skill required for your project',
    projectScope: '3 to 6 months',
    requireStudents: '6 students',
    author: 'Tech Solutions Inc.',
    timeCreated: '1 week',
    numOfProposals: 'less than 5',
  ),
  Project(
    projectId: '00000004',
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
    projectId: '00000005',
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