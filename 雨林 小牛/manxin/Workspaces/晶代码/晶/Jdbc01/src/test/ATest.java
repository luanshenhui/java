package test;

import static org.junit.Assert.*;

import org.junit.Test;

public class ATest {

	@Test
	public void testSum() {
		A a = new A();
		System.out.println(a.sum(1, 1));
	}
	
	@Test
	public void testF1(){
		A a = new A();
		a.f1();
	}

}
