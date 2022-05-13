class Stages {
  List<int> wallIndexList;
  List<int> syringeStartPosition;
  List<int> patientPositionList;
  List<int> emptySpacePositionList;

  bool completed;
  bool onLevel;
  int doctorStartIndex;

  Stages({
    required this.wallIndexList,
    required this.syringeStartPosition,
    required this.patientPositionList,
    required this.emptySpacePositionList,
    required this.doctorStartIndex,
    required this.completed,
    required this.onLevel,
  });
}

List<Stages> stages = [
  //lvl-1
  Stages(
    wallIndexList: [
      2,
      3,
      4,
      11,
      13,
      20,
      22,
      23,
      24,
      25,
      26,
      27,
      28,
      29,
      35,
      36,
      41,
      42,
      43,
      44,
      45,
      46,
      47,
      48,
      50,
      57,
      59,
      66,
      68,
      75,
      76,
      77
    ],
    syringeStartPosition: [30, 39, 49, 32],
    patientPositionList: [12, 33, 37, 58],
    emptySpacePositionList: [0,1,5,6,7,8,9,10,14,15,16,17,18,19,51,52,53,54,55,56,60,61,62,63,64,65,69,70,71,72,73,74,78,79,80,81],
    doctorStartIndex: 40,
    completed: false,
    onLevel: true,
  ),
  //lvl-2
  Stages(
    wallIndexList: [
      0,
      1,
      2,
      3,
      4,
      13,
      22,
      31,
      40,
      41,
      42,
      33,
      24,
      25,
      26,
      35,
      44,
      53,
      62,
      71,
      70,
      69,
      68,
      59,
      77,
      76,
      75,
      74,
      73,
      64,
      55,
      46,
      47,
      37,
      38,
      36,
      27,
      18,
      9
    ],
    syringeStartPosition: [21, 20, 29],
    patientPositionList: [34, 43, 52],
    emptySpacePositionList: [5,6,7,8,14,15,16,17,23,32,45,54,63,72,78,79, 80],
    doctorStartIndex: 12,
    completed: false,
    onLevel: false,
  ),
  //lvl-3
  Stages(
    wallIndexList: [
      10,
      11,
      19,
      28,
      37,
      46,
      47,
      56,
      65,
      3,
      12,
      30,
      34,
      66,
      4,
      67,
      5,
      68,
      6,
      15,
      24,
      33,
      69,
      37,
      43,
      52,
      61,
      70
    ],
    syringeStartPosition: [31, 41, 49, 59],
    patientPositionList: [48, 57, 58, 60],
    emptySpacePositionList: [2,7,8,9,16,17,18,25,26,27,35,36,44,45,53,54,55,62,63,64,71,72,73,74,75,76,77,78,79,80,0,1],
    doctorStartIndex: 22,
    completed: false,
    onLevel: false,
  ),
  //lvl-4
  Stages(
    wallIndexList: [
      1,
      2,
      3,
      4,
      13,
      14,
      15,
      24,
      33,
      34,
      43,
      44,
      53,
      61,
      62,
      70,
      69,
      68,
      67,
      66,
      65,
      64,
      63,
      54,
      45,
      36,
      27,
      28,
      29,
      38,
      19,
      10,
      31,
      40,
      50
    ],
    syringeStartPosition: [21, 59, 47],
    patientPositionList: [37, 46, 55],
    emptySpacePositionList: [0,5,6,7,8,9,16,17,18,25,26,35,71,72,73,74,75,76,77,78,79,80],
    doctorStartIndex: 11,
    completed: false,
    onLevel: false,
  ),
  //lvl-5
  Stages(
    wallIndexList: [
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      17,
      25,
      26,
      35,
      43,
      42,
      51,
      60,
      59,
      58,
      57,
      44,
      48,
      47,
      46,
      45,
      36,
      27,
      18,
      19,
      20,
      11
    ],
    syringeStartPosition: [38, 30, 21, 22, 23],
    patientPositionList: [39, 40, 41, 32, 31],
    emptySpacePositionList: [0,1,9,10,52,53,54,55,56,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80],
    doctorStartIndex: 28,
    completed: false,
    onLevel: false,
  ),
  //lvl-6
  Stages(
      wallIndexList: [2,3,4,5,9,10,11,14,18,23,27,31,32,33,34,36,37,38,40,43,44,47,53,56,61,62,65,68,69,70,74,75,76,77],
      syringeStartPosition: [49,50,59],
      patientPositionList:[31,42,66],
      emptySpacePositionList:[0,1,6,7,8,15,16,17,24,25,26,35,45,46,54,55,63,64,71,72,73,78,79,80],
      doctorStartIndex:41,
      completed:false,
      onLevel:false
  ),
  //lvl-7
  Stages(
      wallIndexList: [1,2,3,4,5,6,7,8,10,17,19,25,26,27,28,33,34,36,42,45,50,51,54,55,59,64,65,67,68,74,75,76],
      syringeStartPosition: [22,23,29,30,47,49],
      patientPositionList:[21,23,30,39,48,57],
      emptySpacePositionList:[0,9,18,35,43,44,52,53,60,61,62,63,69,70,71,72,73,77,78,79,80],
      doctorStartIndex:41,
      completed:false,
      onLevel:false
  ),
];
