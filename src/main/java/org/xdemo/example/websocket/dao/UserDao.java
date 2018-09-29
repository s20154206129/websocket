package org.xdemo.example.websocket.dao;
import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.xdemo.example.websocket.entity.User;


public interface UserDao {
	
	public User getUserById(@Param("id")int id);
	
	public User getUserByName(@Param("name")String name);

	public void addUser(User user);

	public int  deleteUser(@Param("id")int id);

	public int  updateUser(User user);

	public List<User> getAllUser(); 
}
