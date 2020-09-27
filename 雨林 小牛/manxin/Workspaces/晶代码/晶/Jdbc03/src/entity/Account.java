package entity;

public class Account {
	private int id;
	private String accountNo;
	private int balance;
	public int getId() {
		return id;
	}
	@Override
	public String toString() {
		return accountNo + "," + balance;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getAccountNo() {
		return accountNo;
	}
	public void setAccountNo(String accountNo) {
		this.accountNo = accountNo;
	}
	public int getBalance() {
		return balance;
	}
	public void setBalance(int balance) {
		this.balance = balance;
	}
}
