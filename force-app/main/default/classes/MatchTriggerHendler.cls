public with sharing class MatchTriggerHendler {
    public static void updatePreviousMatchDateTime(List<Match__c> matchList) {
        for (Match__c matchTmp : matchList) {
            matchTmp.Previous_Match_Between_Teams_Datetime__c= SoccerDAO.previousMatchDatetimeSet(matchTmp);
        }
    }
    public static void teamWinsUpdate(List<Match__c> matchList) {
        Map<Id, Integer> tmpTeam= SoccerDAO.getTeamWins(matchList);
        List<Team__C> tmpTeamList = new List<Team__C>();
        for (Id tmp : tmpTeam.keySet()) {
            tmpTeamList.add(new Team__c(Id=tmp, Total_Wins__c=tmpTeam.get(tmp)));
        }
        update tmpTeamList;
    }
}
