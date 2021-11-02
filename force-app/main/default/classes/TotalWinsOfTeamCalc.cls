public with sharing class TotalWinsOfTeamCalc {
    public static Integer calc(Id Id){
        Set<Id> IdSet = new Set<Id>();
        for (Id tmp : IdSet) {
            return SoccerDAo.getWonMatchesCountByTeamId(tmp);
        }
        return 0;
    }
}