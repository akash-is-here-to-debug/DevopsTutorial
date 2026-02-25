/**
 * @description Unit tests for AccountTrigger and AccountTriggerHandler.
 * Verifies before/after operations and bulk behavior.
 */
@IsTest
private class AccountTriggerTest {
    @TestSetup
    static void setupData() {
        // Minimal org data if needed in future
    }

    @IsTest
    static void testBeforeInsert_setsDefaultRating() {
        List<Account> accts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            accts.add(new Account(Name = 'Acct ' + i));
        }

        Test.startTest();
        insert accts;
        Test.stopTest();

        // Verify Rating defaulted to Warm
        for (Account a : [SELECT Id, Rating FROM Account WHERE Id IN :accts]) {
            System.assertEquals('Warm', a.Rating, 'Rating should default to Warm on before insert');
        }
    }

    @IsTest
    static void testBeforeUpdate_setsDescriptionNoteWhenNameChanges() {
        Account a = new Account(Name = 'Original');
        insert a;

        a.Name = 'Updated';
        Test.startTest();
        update a;
        Test.stopTest();

        Account updated = [SELECT Id, Name, Description FROM Account WHERE Id = :a.Id];
        System.assertEquals('Updated', updated.Name, 'Name should be updated');
        System.assert(updated.Description != null && updated.Description.contains('Name updated via trigger'),
            'Description should contain note about name update');
    }

    @IsTest
    static void testBulkUpdate_doesNotError() {
        List<Account> accts = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            accts.add(new Account(Name = 'Bulk ' + i));
        }
        insert accts;

        // Change names to trigger beforeUpdate logic
        for (Account a : accts) {
            a.Name = a.Name + ' X';
        }

        Test.startTest();
        update accts;
        Test.stopTest();

        // Sanity query
        List<Account> updated = [SELECT Id, Name FROM Account WHERE Id IN :accts];
        System.assertEquals(200, updated.size(), 'All records should be updated without errors');
    }

    @IsTest
    static void testDelete_and_UndeletePaths_execute() {
        Account a = new Account(Name = 'To Delete');
        insert a;

        Test.startTest();
        delete a;
        // After undelete path
        undelete a;
        Test.stopTest();

        // Validate record exists again
        Account undeleted = [SELECT Id, IsDeleted FROM Account WHERE Id = :a.Id ALL ROWS];
        System.assertNotEquals(null, undeleted, 'Record should exist after undelete');
    }
}
