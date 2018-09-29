package org.xdemo.example.websocket.entity;
import java.sql.Timestamp;
public class UserRelation{
	private int userIdA;
	private int userIdB;
	//关系状态״̬
	private int relationStatus;
	private Timestamp relationStart;
	
	public int getUserIdA() {
		return userIdA;
	}
	public void setUserIdA(int userIdA) {
		this.userIdA = userIdA;
	}
	
	public int getUserIdB() {
		return userIdB;
	}
	public void setUserIdB(int userIdB) {
		this.userIdB = userIdB;
	}
	
	public int getRelationStatus() {
		return relationStatus;
	}
	public void setRelationStatus(int relationStatus) {
		this.relationStatus = relationStatus;
	}
	
	
	public Timestamp getRelationStart() {
		return relationStart;
	}
	public void setRelationStart(Timestamp relationStart) {
		this.relationStart = relationStart;
	}
	
}
