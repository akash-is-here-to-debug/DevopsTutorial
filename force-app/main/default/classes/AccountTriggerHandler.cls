/**
 * @description Trigger handler for Account. Follows one-trigger-per-object and bulkified patterns.
 * @author Agentforce
 * @group Account
 * @date 2026-02-25
 */
public with sharing class AccountTriggerHandler {
    // Prevent recursion within a single transaction if needed
    private static Boolean hasRun = false;

    public void beforeInsert(List<Account> newList) {
        if (hasRun) return;
        hasRun = true;

        // Example logic: default Rating to 'Warm' if not provided
        for (Account acc : newList) {
            if (acc.Rating == null) {
                acc.Rating = 'Warm';
            }
        }
    }

    public void beforeUpdate(List<Account> newList, Map<Id, Account> oldMap) {
        if (hasRun) return;
        hasRun = true;

        // Example logic: if Name changed, set Description note
        for (Account acc : newList) {
            Account oldRec = oldMap.get(acc.Id);
            if (oldRec != null && acc.Name != oldRec.Name) {
                // Only set if field is accessible; LDS/UI enforces FLS but add guard for Apex usage
                acc.Description = (acc.Description == null ? '' : acc.Description + ' | ') + 'Name updated via trigger';
            }
        }
    }

    public void beforeDelete(List<Account> oldList) {
        if (hasRun) return;
        hasRun = true;

        // Placeholder: add validation rules if needed
        // Example: block deletion when Account has a specific condition
        // for (Account acc : oldList) {
        //     if (acc.AccountNumber != null) {
        //         acc.addError('Deletion is not allowed when Account Number is populated.');
        //     }
        // }
    }

    public void afterInsert(List<Account> newList) {
        if (hasRun) return;
        hasRun = true;

        // Placeholder for async or related updates. Keep DML/SOQL out of loops.
        // Example no-op to keep sample clean.
    }

    public void afterUpdate(List<Account> newList, Map<Id, Account> oldMap) {
        if (hasRun) return;
        hasRun = true;

        // Placeholder for post-update logic
    }

    public void afterDelete(List<Account> oldList) {
        if (hasRun) return;
        hasRun = true;

        // Placeholder for post-delete logic
    }

    public void afterUndelete(List<Account> newList) {
        if (hasRun) return;
        hasRun = true;

        // Placeholder for post-undelete logic
    }
}
