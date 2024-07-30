({
    checkValidations : function(cmp) {
        
        cmp.set("v.showSpinner",true);        
        var scooterId =cmp.get("v.recordId");        
        var action = cmp.get('c.checkValidation');
        action.setParams({ 
            scooterId : scooterId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS") {
                var objWrapper = response.getReturnValue();
                cmp.set('v.objWrapper',objWrapper);                     
                
                if(objWrapper.mapError.multipleAssignmnt==true){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Please check/correct assignment history",
                        "type": 'error'
                    });
                    toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
                    
                }else if(objWrapper.mapError.startDateOverlapping==true){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Start Date will overlap with End date of existing assignments",
                        "type": 'error'
                    });
                    toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
                    
                } else if(objWrapper.mapError.alreadyAssign==true){
                    cmp.set('v.showReassignConfirm',true);
                    
                }else{
                    var filter= 'recordTypeId='+'\''+objWrapper.contactRecTypeId+'\'' +' or ' +'recordTypeId='+'\''+objWrapper.contactWalkInRecTypeId+'\''+
                       ' or ' +'recordTypeId='+ '\''+objWrapper.contactJ1RecTypeId+'\'';
                    cmp.set('v.contactFilter',filter);
                    cmp.set("v.showDetails",true);
                }
                
                cmp.set("v.showSpinner",false);
                
            }
            else{
                cmp.set("v.showSpinner",false);
            }
            
        });
        $A.enqueueAction(action);
        
    },
    
    createAssignment : function(cmp) {
        cmp.set("v.showSpinner",true);        
        var scooterId =cmp.get("v.recordId");
        var contactId =cmp.get('v.contactId'); 
        var paymentDuration = cmp.get('v.paymentValue');
        //var objWrapper = cmp.get('v.objWrapper');
        var action = cmp.get('c.createAssignmnt');        
        action.setParams({ 
            scooterId : scooterId,
            contactId:contactId, 
            selectedPaymentType: paymentDuration,
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS") {
                var mapMsg = response.getReturnValue();
                if(mapMsg.success==true){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success",
                        "message": "Successfully assigned the scooter.",
                        "type": 'success'
                    });
                    toastEvent.fire();
                    
                    $A.get("e.force:closeQuickAction").fire();
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": scooterId,
                        "slideDevName": "detail"
                        
                    });
                    navEvt.fire(); 
                }
                else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Error Occured",
                        "type": 'error'
                    });
                    toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
                }
                
                cmp.set("v.showSpinner",false);
            }
        });
        $A.enqueueAction(action);          
        
        
        
    },
    
    getScooterInfo: function (component, recordId) {
        var action = component.get("c.getScooterById");
        action.setParams({ scooterId: recordId });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var scooter = response.getReturnValue();
                component.set("v.scooter", scooter);
            } else {
                // Handle error
            }
        });

        $A.enqueueAction(action);
    },
})