<<<<<<< HEAD
=======
/**
 * Apex Class Name: HandleCustomExceptionTest
 * created Date: 17-Apr-22
 * @Author: Shiva Karna
 * Description: this test class was developed to increase coverage for HandleCustomException. 
 * Modification log
 * Ver   Date          Author                               Modification
 * 1.0   17-Apr-2022   Shiva Karna                      Initial Version
 * 
 * 
 */
>>>>>>> 49c5e33fea438895d6fc3658662391f0c9c60600
@isTest
public class HandleCustomExceptionTest {
    @isTest
    public static void CreateAccount() {
        try {
            Account m = new Account();
            insert m;
        } catch (Exception e) {
            HandleCustomException.LogException(e);
        }    
    } 
}