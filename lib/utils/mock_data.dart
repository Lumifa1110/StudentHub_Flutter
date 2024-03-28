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

