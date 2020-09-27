package service;

import static org.junit.Assert.*;

import org.junit.Test;

public class AccountServiceTest {

	@Test
	public void testApply() {
		AccountService service = 
			new AccountService();
		try {
			String number = service.apply(
					"62251000", 5000);
			System.out.println(number);
		} catch (Exception e) {
			e.printStackTrace();
			if(e instanceof AccountLimitException){
				System.out.println("����");
			}else if(e instanceof AccountNotExsitException){
				System.out.println("�ʺŲ�����");
			}else{
				System.out.println("�Ժ�����");
			}
		}
	}

}
