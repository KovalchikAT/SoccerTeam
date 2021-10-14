public with sharing class SoccerDAO {
    public static List<Team__c> getTeamsByIds(set<Id> teamIds) {
        return new List<Team__c>([SELECT id, Name, Total_Wins__c, Total_Active_Players__c, Played_Home_Matches_Count__c FROM Team__c WHERE id =: teamIds]);
    }
    public static List<Player__c> getActivePlayers(Integer limitNumber, Integer offsetNumber){
        return new List<Player__c>([SELECT id, Name, Email__c, IsActive__c, Team__c FROM Player__c WHERE IsActive__c=true ORDER BY Name LIMIT: limitNumber OFFSET: offsetNumber]);
    }  
    public static Team__c getMostWinnerTeam(){
        Map<id, Integer> teamWinsMap = getTeamWins([SELECT id, score__c, Home_Team__c, Visitors__c FROM Match__c]);
        integer max =0;
        id tmpId;
        for (id tmp : teamWinsMap.keySet()) {
            if (teamWinsMap.get(tmp)>=max) {
               max= teamWinsMap.get(tmp);
               tmpId = tmp;
            }
        }
        List<Team__c> teamList = new List<Team__c>([SELECT id, Name, Total_Wins__c, Total_Active_Players__c, Played_Home_Matches_Count__c FROM Team__c WHERE id =: tmpId LIMIT 1]);
        return teamList.get(0);
    }
    public static Integer getWonMatchesCountByTeamId(Id teamId){
        Map<id, Integer> teamWinsMap = getTeamWins([SELECT id, score__c, Home_Team__c, Visitors__c FROM Match__c]);
        if (teamWinsMap.containsKey(teamId)){
            return teamWinsMap.get(teamId);
        }else{
            return 0;
        }
    }   
    public static Map<Id, Integer> getTeamsWithPlayerNumber(Set<Id> teamIds){
        Map<Id,Integer> teamActivePlayersCount = new Map<Id,Integer>();
        if (teamIds.isEmpty()){
            for (Team__c tmp : new List<Team__c>([SELECT id FROM Team__c])){
                teamIds.add(tmp.id);
            }
        }
        for (id tmp : teamIds) {
            AggregateResult[] tmpRes = [select count(id) countID from player__c where isActive__c=true and team__c=:tmp];
          teamActivePlayersCount.put(tmp, (integer)tmpRes.get(0).get('countID'));             
        }
        return teamActivePlayersCount;
    }
    public static Integer getTeamStatistics(Set<Id> teamIds){
        Map<Id, Integer> teamWithPlayer = getTeamsWithPlayerNumber(teamIds);
        Integer playerCount=0 , average=0;
        for (id tmp : teamWithPlayer.keySet()) {
            average=average+teamWithPlayer.get(tmp);   
            playerCount++;          
        }
        return average/playerCount;
     }
    public static Team__c getTeamWithMostScores(){
        List<Team__c> teamList = new List<Team__c>([SELECT id FROM Team__c]);
        List<Match__c> matchList = new List<Match__c>([SELECT id, score__c, Home_Team__c, Visitors__c FROM Match__c]);
        Integer score=0, max=0;
        Team__c retTeam;
        for (Team__c tmpTeam : teamList) {
            score=0;
            for (Match__c tmpMatch: matchList){
                Integer a = Integer.valueOf(tmpMatch.score__c.substringBefore(':'));
                Integer b = Integer.valueOf(tmpMatch.score__c.substringAfter(':'));
                if((a>b && tmpMatch.Home_Team__c==tmpTeam.id)||(a<b && tmpMatch.Visitors__c==tmpTeam.id)){
                    score=score+2;
                }
                if(a==b && (tmpMatch.Home_Team__c==tmpTeam.id || tmpMatch.Visitors__c==tmpTeam.id)){
                    score=score+1;
                }
            }
            if (max<score) {
                max=score;
                retTeam=tmpTeam;
            }
        }
        return retTeam;
    } 
    public static Map<Id, Integer> getTeamWins(List<Match__c> matchList){
        List<Team__c> teamList = new List<Team__c>([SELECT id FROM Team__c]);
        Map<id, Integer> teamWinsMap = new Map<id, Integer>();
        for (Team__c tmp : teamList) {teamWinsMap.put(tmp.id, 0);}
        for (Match__c tmp: matchList){
            Integer a = Integer.valueOf(tmp.score__c.substringBefore(':'));
            Integer b = Integer.valueOf(tmp.score__c.substringAfter(':'));
            if(a>b){
                if (teamWinsMap.containsKey(tmp.Home_Team__c)){
                   teamWinsMap.put(tmp.Home_Team__c,teamWinsMap.get(tmp.Home_Team__c)+1);
                }
            }
            if(a<b){
                if (teamWinsMap.containsKey(tmp.Visitors__c)){
                   teamWinsMap.put(tmp.Visitors__c,teamWinsMap.get(tmp.Visitors__c)+1);
                }
        }
        }
       // system.debug(System.LoggingLevel.DEBUG, teamWinsMap);
        return teamWinsMap;
    }
}
