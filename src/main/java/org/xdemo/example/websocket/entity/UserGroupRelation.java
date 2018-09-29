package org.xdemo.example.websocket.entity;

import java.sql.Timestamp;


public class UserGroupRelation {
	private int userId;
	private int groupId;
	// 群等级
	private int groupLevel;
	//群昵称
	private String groupUserNickName;
	//入群时间
	private Timestamp enterGroupTime;
	
	
	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	
	
	public int getGroupId() {
		return groupId;
	}
	public void setGroupId(int groupId) {
		this.groupId = groupId;
	}
	
	
	public int getGroupLevel() {
		return groupLevel;
	}
	public void setGroupLevel(int groupLevel) {
		this.groupLevel = groupLevel;
	}
	
	
	public String getGroupUserNickName() {
		return groupUserNickName;
	}
	public void setGroupUserNickName(String groupUserNickName) {
		this.groupUserNickName = groupUserNickName;
	}	
	public Timestamp getEnterGroupTime() {
		return enterGroupTime;
	}
	public void setEnterGroupTime(Timestamp enterGroupTime) {
		this.enterGroupTime = enterGroupTime;
	}
}
