@IsTest
public with sharing class calculatorTest {

    @IsTest
    static void testAdd() {
        calculator.add();
    }

    @IsTest
    static void testSub() {
        calculator.sub();
    }
}

