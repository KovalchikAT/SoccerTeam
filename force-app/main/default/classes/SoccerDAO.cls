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
    public Map<Id, Integer> getTeamWins(List<Match__c> matchList){
        List<id> teamList = new List<id>([SELECT id FROM Team__c]);
        Map<id, Integer> teamWinsMap = new Map<id, Integer>(teamList);
        teamWinsMap.putAll(teamList,'0');
        for (Match__c tmp: matchList){
            Integer a = Integer.valueOf(left(String(tmp.score__c).indexOf(':')-1));
            Integer b = Integer.valueOf(right(String(tmp.score__c).indexOf(':')-1));
            switch on a {
                when  a>b{
                    if (teamWinsMap.containsKey(tmp.Home_Team__c)){
                        teamWinsMap.put(teamWinsMap.get(tmp.Home_Team__c)+1);
                    }
                }
                when a<b{
                    if (teamWinsMap.containsKey(tmp.Visitors__c)){
                        teamWinsMap.put(teamWinsMap.get(tmp.Visitors__c)+1);
                    }
                }
            }          
        }
        return teamWinsMap;
    }
}
