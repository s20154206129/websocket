package org.xdemo.example.websocket.entity;

import java.sql.Timestamp;

import com.alibaba.fastjson.annotation.JSONField;
/**
 * 群组
 * @author 0000
 *
 */
public class Group {
	private int id;
	//群号码
	private String groupId;
	private String groupName;
	private int groupCreaterId;
	private Timestamp groupCreateTime;
	private String groupIntroduction;
	private int groupUserCount;
	private String groupMembers;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	
	
	public String getGroupId() {
		return groupId;
	}
	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}
	
	
	public String getGroupName() {
		return groupName;
	}
	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}
	
	public int getGroupCreaterId() {
		return groupCreaterId;
	}
	public void setGroupCreaterId(int groupCreaterId) {
		this.groupCreaterId = groupCreaterId;
	}
	
	
	public Timestamp getGroupCreateTime() {
		return groupCreateTime;
	}
	public void setGroupCreateTime(Timestamp groupCreateTime) {
		this.groupCreateTime = groupCreateTime;
	}
	
	
	public String getGroupIntroduction() {
		return groupIntroduction;
	}
	public void setGroupIntroduction(String groupIntroduction) {
		this.groupIntroduction = groupIntroduction;
	}
	
	
	public int getGroupUserCount() {
		return groupUserCount;
	}
	public void setGroupUserCount(int groupUserCount) {
		this.groupUserCount = groupUserCount;
	}
	
	
	public String getGroupMembers() {
		return groupMembers;
	}
	public void setGroupMembers(String groupMembers) {
		this.groupMembers = groupMembers;
	}
	@Override
	public String toString() {
		return "Group [id=" + id + ", groupId=" + groupId + ", groupName=" + groupName + ", groupCreaterId="
				+ groupCreaterId + ", groupCreateTime=" + groupCreateTime + ", groupIntroduction=" + groupIntroduction
				+ ", groupUserCount=" + groupUserCount + ", groupMembers=" + groupMembers + "]";
	}
	
}
