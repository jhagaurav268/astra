({
    doInit: function (component, event, helper) {
        helper.checkValidations(component);
        var recordId = component.get("v.recordId");
        console.log('Record Id ', recordId);
        helper.getScooterInfo(component, recordId);
        
    },
    
    showDetails: function (component, event, helper) {
        component.set('v.showDetails', true);
        component.set('v.showReassignConfirm', false);
    },
    
    hideDetails: function (component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    
    hideReassignConfirm: function (component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    
    showSubmitConfirmation: function (component, event, helper) {
        // alert('Error');
        var contactId = component.get('v.contactId');
        var objWrapper = component.get('v.objWrapper');
        var paymentValue = component.get('v.paymentValue');
        var scooterType = component.get('v.scooter.Type__c');
        console.log('scooterType ' + scooterType);
        
        //var selectedType = component.get('v.selectedValue');
        
        if (contactId == undefined || contactId == null || contactId == '') {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please select the Contact",
                "type": 'error'
            });
            toastEvent.fire();
            
        }else if (scooterType == 'Rent' && (paymentValue == undefined || paymentValue == null || paymentValue == '')) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please select Payment Duration",
                "type": 'error'
            });
            toastEvent.fire();
        }else if (contactId == objWrapper.objScooter.Contact__c) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please select a different Contact",
                "type": 'error'
            });
            toastEvent.fire();
            
        }/*else if(objWrapper.mapError.alreadyAssign!=undefined && objWrapper.objAssignmnt.Contact__c==contactId){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please select a different Contact",
                "type": 'error'
            });
            toastEvent.fire();
            
        }*/else {
            component.set('v.showSubmitConfirm', true);
            component.set('v.showReassignConfirm', false);
        }
        
    },
    
    hideSubmitConfirmation: function (component, event, helper) {
        component.set('v.showDetails', true);
        component.set('v.showSubmitConfirm', false);
        component.set('v.showReassignConfirm', false);
    },
    
    processAssign: function (component, event, helper) {
        component.set('v.showDetails', true);
        component.set('v.showSubmitConfirm', false);
        component.set('v.showReassignConfirm', false);
        helper.createAssignment(component);
        
        // setTimeout(() => {
        //     var scooterId = component.get("v.recordId");
        //     console.log('Id ', component.get('v.selectedValue'));
        //     if (scooterId != undefined || scooterId != null || scooterId != '') {
        //         var action = component.get('c.updateScooterAssignment');
        
        //         action.setParams({
        //             scooterId: scooterId,
        //             scooterType: component.get('v.selectedValue')
        //         });
        //         action.setCallback(this, function (response) {
        //             var state = response.getState();
        //             console.log('State', state);
        //             if (state === 'SUCCESS') {
        //                 // Handle success
        //             } else if (state === 'ERROR') {
        //                 // Handle error
        //             }
        //         });
        //         $A.enqueueAction(action);
        
        //     }
        // }, 2000);
        
        
    },
    
    /*scooterType: function (component, event, helper) {
        var action = component.get("c.getScooterType");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var picklistValues = response.getReturnValue();
                var opts = [
                    {
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    }
                ];
                for (var i = 0; i < picklistValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: picklistValues[i],
                        value: picklistValues[i]
                    });
                }
                component.set("v.picklistValues", opts);
            } else if (state === "ERROR") {
                var errors = response.getError();
                // Handle the error
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
    },*/
    
    paymentType: function (component, event, helper) {
        var action = component.get("c.getPaymentType");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var picklistValues = response.getReturnValue();
                var opts = [
                    {
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    }
                ];
                for (var i = 0; i < picklistValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: picklistValues[i],
                        value: picklistValues[i]
                    });
                }
                component.set("v.paymentDurationValues", opts);
            } else if (state === "ERROR") {
                var errors = response.getError();
                // Handle the error
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
    },
    
    /*onPicklistChange: function (component, event, helper) {
        // Get the value of the selected option
        var selectedType = event.getSource().get("v.value");
        component.set("v.selectedValue", selectedType);
    },*/
    
    onPaymentChange: function (component, event, helper) {
        // Get the value of the selected option
        var paymentType = event.getSource().get("v.value");
        component.set("v.paymentValue", paymentType);
    }
    
})