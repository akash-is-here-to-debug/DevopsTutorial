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

    @IsTest
    static void testdiv() {
        calculator.div();
    }

    @IsTest
    static void testmul() {
        calculator.mul();
    }
}

