package org.xdemo.example.websocket.service;

import java.util.List;

import org.xdemo.example.websocket.entity.UserRelation;
public interface UserRelationService {
		
		public UserRelation getUserRelation(int idA, int idB);
	
		public void addUserRelation(UserRelation userRelation);
		
		public boolean deleteUserRelation(int idA, int idB);
		
		public boolean updateUser(UserRelation userRelation);
		
		@SuppressWarnings("rawtypes")
		public List getAllFriends(int id);
}
