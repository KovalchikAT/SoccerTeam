({
	getTeams : function(component, event, helper) {
        var action = component.get("c.getSoccerTeamStatisticsTable ");
		
        action.setParams({
            "limitNumber": component.get("v.limitNumber")
        });
        action.setCallback(this, function(response) {
            if (response.getState==="SUCCESS"){
            component.set("v.teams", response.getReturnValue());
            }else
            if (response.getState==="ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            

        });
        
        $A.enqueueAction(action);
	},
    
    setColumns : function(component) {
        component.set('v.columns', [
            {label: 'Team', fieldName: 'Name', type: 'text'},
            {label: 'Wins', fieldName: 'Total_Wins__c', type: 'Integer'},
            {label: 'Active Players', fieldName: 'Total_Active_Players__c', type: 'Integer'},
            {label: 'Played Home Matches', fieldName: 'Played_Home_Matches_Count__c', type: 'Integer'}
        ]);
    }
})