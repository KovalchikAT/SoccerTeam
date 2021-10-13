public with sharing class SoccerDAO {
    public List<Team__c> getTeamsByIds(set<Id> teamIds) {
        return new List<Team__c>([SELECT id, Name, Total_Wins__c, Total_Active_Players__c, Played_Home_Matches_Count__c FROM Team__c WHERE id =: teamIds]);
    }

    public List<Player__c> getActivePlayers(Integer limitNumber, Integer offsetNumber){
        return new List<Player__c>([SELECT id, Name, Email__c, IsActive__c, Team__c FROM Player__c WHERE IsActive=true ORDER BY Name LIMIT: limitNumber OFFSET: offsetNumber]);
    }
    
    public Team__c getMostWinnerTeam(){

        return new Team__c();
    }

    public Integer getWonMatchesCountByTeamId(){

        return null;
    }
    
    public Map<Id, Integer> getTeamsWithPlayerNumber(Set<Id> teamIds){

        return null;
    }

    public Integer getTeamStatistics(Set<Id> teamIds){

        return null;
    }

    public Team__c getTeamWithMostScores(){

        return null;
    } 
}
