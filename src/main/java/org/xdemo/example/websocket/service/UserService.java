package org.xdemo.example.websocket.service;

import java.util.List;

import org.xdemo.example.websocket.entity.User;


public interface UserService {
		
		public User getUser(int id);
		
		public User getUser(String name);
		
		public void addUser(User user);
		
		public int  deleteUser(int id);
		
		public int  updateUser(User user);
		
		public List<User> getAllUser(); 
}
