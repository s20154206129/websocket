package org.xdemo.example.websocket.entity;


public class User {
	private Long id;

	private String name;

	private String password;
	//昵称
	private String userNickName;
	//是否在线
	private int userIsOnline;
	//角色
	private int userRole;

	private  String  userImgPath;
	//好友
	private  String userRelations;
	//加入的群组
	private  String userGroups;
	
	public User(){};
	public User(UserDetail userDetail){
		this.id = userDetail.getUserDetailId();
		this.name = userDetail.getUserDetailName();
		this.userNickName = userDetail.getUserDetailNickName();
		this.userIsOnline = 0;
		this.userRole = userDetail.getUserDetailRole();
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getUserNickName() {
		return userNickName;
	}

	public void setUserNickName(String userNickName) {
		this.userNickName = userNickName;
	}

	public int getUserIsOnline() {
		return userIsOnline;
	}

	public void setUserIsOnline(int userIsOnline) {
		this.userIsOnline = userIsOnline;
	}

	public int getUserRole() {
		return userRole;
	}

	public void setUserRole(int userRole) {
		this.userRole = userRole;
	}
    
	
	
	
	public String getUserImgPath() {
		return userImgPath;
	}
	public void setUserImgPath(String userImgPath) {
		this.userImgPath = userImgPath;
	}
	public String getUserRelations() {
		return userRelations;
	}
	public void setUserRelations(String userRelations) {
		this.userRelations = userRelations;
	}
	public String getUserGroups() {
		return userGroups;
	}
	public void setUserGroups(String userGroups) {
		this.userGroups = userGroups;
	}
	
	@Override
	public String toString() {
		return "User [id=" + id + ", name=" + name + ", password=" + password + ", userNickName=" + userNickName
				+ ", userIsOnline=" + userIsOnline + ", userRole=" + userRole + ", userImgPath=" + userImgPath
				+ ", userRelations=" + userRelations + ", userGroups=" + userGroups + "]";
	}
}
